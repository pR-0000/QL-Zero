; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Between-race MDV1 access. Only documented $124..$12A ROM vectors are used.
; ROM routines preserve A3/A6 and have skip-word returns, NOT D0 errors.
; The filesystem map/directory remain read-only. Scores overwrite preallocated
; one-sector journal files, never the allocation map or directory.
        include "data/cup_disk.inc"

cup_storage_init:
        movem.l d0-d7/a0-a5,-(sp)
        clr.w   qzr_medium_valid-state(a6)
        clr.w   qzr_loaded-state(a6)
        clr.w   qzr_active_slot-state(a6)
        clr.l   qzr_generation-state(a6)
        clr.l   qzr_saved_crc-state(a6)
        clr.w   qzr_save_status-state(a6)
        ; First restore can read several tape revolutions. Do not leave the
        ; bootstrap's VRAM stream on screen while those reads take place.
        lea     qzr_loading_text(pc),a1
        bsr     qzr_loading_screen
        bsr     qzr_restore_records
        movem.l (sp)+,d0-d7/a0-a5
        rts

qzr_motor_on:
        bsr     music_stop
        bsr     stop_microdrives
        move.b  #$10,pc_tctrl  ; shared serial transmitter: microdrive mode
        move.b  #3,pc_ipcrd
        moveq   #$39,d0
        ror.l   d0,d0
        move.b  #1,pc_ipcrd    ; clock one SELECT bit into internal MDV1
        moveq   #$39,d0
        ror.l   d0,d0
        moveq   #63,d1
.settle:
        move.w  #1023,d0
.delay:
        dbra    d0,.delay
        dbra    d1,.settle
        clr.w   qzr_map_valid-state(a6)
        move.w  #1024,qzr_attempts-state(a6)
        rts

qzr_motor_off:
        movem.l d0-d2,-(sp)
        bsr     stop_microdrives
        move.b  #1,pc_tctrl
        move.b  #$1f,pc_intr   ; discard the menu/loading VBL backlog
        move.w  s_ticks(a6),s_last_tick(a6)
        move.w  s_ticks(a6),s_fps_tick(a6)
        clr.w   s_frames(a6)
        movem.l (sp)+,d0-d2
        rts

; Locate next matching sector. Map filtering saves reading irrelevant bodies.
; qzr_target holds file/block (block $FF means any); return 0 / -7 / -22.
qzr_sector:
.scan:
        subq.w  #1,qzr_attempts-state(a6)
        bmi     .bad_medium
        lea     qzr_header(pc),a1
        lea     pc_ipcrd,a3
        movea.w $12a,a4
        jsr     $4000(a4)
        bra.s   .bad_medium   ; return +0: no gap
        bra.s   .scan         ; return +2: corrupt header
        tst.w   qzr_medium_valid-state(a6)
        beq.s   .identity_ok
        lea     qzr_header+2(pc),a0
        lea     qzr_medium(pc),a1
        moveq   #11,d0
.identity:
        cmpm.b  (a0)+,(a1)+
        bne     .wrong_medium
        dbra    d0,.identity
.identity_ok:
        move.w  d7,qzr_sector_number-state(a6)
        tst.w   qzr_map_valid-state(a6)
        beq.s   .read
        add.w   d7,d7
        lea     qzr_map(pc),a0
        move.w  0(a0,d7.w),d0
        move.w  qzr_target-state(a6),d1
        cmpi.b  #$ff,d1
        bne.s   .exact
        andi.w  #$ff00,d0
        andi.w  #$ff00,d1
.exact:
        cmp.w   d1,d0
        bne.s   .scan
.read:
        lea     qzr_sector_buffer(pc),a1
        lea     pc_ipcrd,a3
        movea.w $124,a4
        jsr     $4000(a4)
        bra.s   .scan         ; return +0: unreadable block/checksum
        move.w  qzr_target-state(a6),d0
        move.w  d0,d3
        lsr.w   #8,d3
        cmp.b   d3,d1
        bne     .scan
        cmpi.b  #$ff,d0
        beq.s   .good
        cmp.b   d0,d2
        bne     .scan
.good:
        move.w  d2,qzr_block_number-state(a6)
        moveq   #0,d0
        rts
.bad_medium:
        moveq   #-7,d0
        rts
.wrong_medium:
        moveq   #-22,d0
        rts

qzr_map_read:
        clr.w   qzr_map_valid-state(a6)
        move.w  #$8000,qzr_target-state(a6)
        bsr     qzr_sector
        tst.l   d0
        bne.s   .done
        lea     qzr_sector_buffer(pc),a0
        lea     qzr_map(pc),a1
        moveq   #127,d0
.copy:
        move.l  (a0)+,(a1)+
        dbra    d0,.copy
        move.w  #1,qzr_map_valid-state(a6)
        moveq   #0,d0
.done:
        rts

; A0 seven-character name, return file/length in qzr_file/qzr_file_size.
; Directory file 0 consists of 64-byte headers; file number = entry index.
qzr_find:
        move.w  #1024,qzr_attempts-state(a6)
        move.l  a0,qzr_name_ptr-state(a6)
        clr.w   qzr_directory_block-state(a6)
.block:
        move.w  qzr_directory_block-state(a6),qzr_target-state(a6)
        bsr     qzr_sector
        tst.l   d0
        bne     .done
        tst.w   qzr_directory_block-state(a6)
        bne.s   .headers
        move.l  qzr_sector_buffer-state(a6),d0
        cmpi.l  #64,d0
        blo.s   .bad
        cmpi.l  #8192,d0
        bhi.s   .bad
        move.w  d0,qzr_directory_size-state(a6)
.headers:
        lea     qzr_sector_buffer(pc),a1
        move.w  qzr_directory_block-state(a6),d6
        lsl.w   #3,d6
        moveq   #7,d7
.entry:
        move.w  d6,d0
        lsl.w   #6,d0
        cmp.w   qzr_directory_size-state(a6),d0
        bhs.s   .bad
        cmpi.w  #7,14(a1)
        bne.s   .next
        movea.l qzr_name_ptr-state(a6),a0
        lea     16(a1),a2
        moveq   #6,d0
.name:
        cmpm.b  (a0)+,(a2)+
        bne.s   .next
        dbra    d0,.name
        move.w  d6,qzr_file-state(a6)
        move.l  (a1),qzr_file_size-state(a6)
        moveq   #0,d0
        rts
.next:
        addq.w  #1,d6
        adda.w  #64,a1
        dbra    d7,.entry
        addq.w  #1,qzr_directory_block-state(a6)
        bra     .block
.bad:
        moveq   #-7,d0
.done:
        rts

; Collect every block in one tape sweep, regardless of physical block order.
; Scene heap is scratch only between races. Never touch the active track yet.
qzr_read_file:
        bsr     menu_reset      ; staging overwrites the menu's reused icon bank
        move.w  #1024,qzr_attempts-state(a6)
        move.l  qzr_file_size-state(a6),d0
        cmpi.l  #64,d0
        blo     .bad
        cmpi.l  #6656,d0
        bhi     .bad
        addi.w  #511,d0
        lsr.w   #8,d0
        lsr.w   #1,d0
        move.w  d0,qzr_blocks_left-state(a6)
        move.w  d0,qzr_block_count-state(a6)
        clr.w   qzr_seen-state(a6)
        move.w  qzr_file-state(a6),d0
        lsl.w   #8,d0
        ori.w   #$ff,d0
        move.w  d0,qzr_target-state(a6)
.next:
        bsr     qzr_sector
        tst.l   d0
        bne.s   .done
        move.w  qzr_block_number-state(a6),d0
        cmp.w   qzr_block_count-state(a6),d0
        bhs.s   .bad
        move.w  qzr_seen-state(a6),d1
        bset    d0,d1
        bne.s   .next
        move.w  d1,qzr_seen-state(a6)
        lsl.w   #8,d0
        lsl.w   #1,d0
        movea.l #$28000,a1
        adda.w  d0,a1
        lea     qzr_sector_buffer(pc),a0
        moveq   #127,d0
.copy:
        move.l  (a0)+,(a1)+
        dbra    d0,.copy
        subq.w  #1,qzr_blocks_left-state(a6)
        bne.s   .next
        moveq   #0,d0
.done:
        rts
.bad:
        moveq   #-7,d0
        rts

; CRC-32/ISO-HDLC, identical to Python zlib; only offline data uses this.
; A0/D0 = bytes/count; return D0. D1/D2/A0 volatile.
qzr_crc32:
        move.l  d0,d2
        moveq   #-1,d0
.byte:
        tst.l   d2
        beq.s   .done
        moveq   #0,d1
        move.b  (a0)+,d1
        eor.b   d1,d0
        moveq   #7,d1
.bit:
        lsr.l   #1,d0
        bcc.s   .shift
        eori.l  #$edb88320,d0
.shift:
        dbra    d1,.bit
        subq.l  #1,d2
        bra.s   .byte
.done:
        not.l   d0
        rts

cup_disk_load_course:
        lea     qzr_loading_text(pc),a1
        bsr     qzr_loading_screen
.retry:
        bsr     qzr_motor_on
        bsr     qzr_map_read
        tst.l   d0
        bne     .failed
        move.w  cup_round-state(a6),d0
        addi.b  #'0',d0
        move.b  d0,qzr_course_file+6-state(a6)
        lea     qzr_course_file(pc),a0
        bsr     qzr_find
        tst.l   d0
        bne     .failed
        bsr     qzr_read_file
        tst.l   d0
        bne     .failed
        bsr     qzr_motor_off
        movea.l #$28040,a5
        cmpi.l  #$515a4332,(a5)
        bne     .failed
        cmpi.l  #qzr_game_id,4(a5)
        bne     .failed
        move.w  cup_round-state(a6),d0
        cmp.w   8(a5),d0
        bne     .failed
        cmpi.w  #11312,14(a5)
        bne     .failed
        cmpi.w  #848,16(a5)
        bne     .failed
        moveq   #0,d0
        move.w  10(a5),d0
        add.w   12(a5),d0
        move.l  d0,d3
        addi.l  #88,d3
        cmp.l   qzr_file_size-state(a6),d3
        bne     .failed
        lea     24(a5),a0
        bsr     qzr_crc32
        cmp.l   20(a5),d0
        bne     .failed
        lea     qzr_header+2(pc),a0
        lea     qzr_medium(pc),a1
        moveq   #2,d0
.medium:
        move.l  (a0)+,(a1)+
        dbra    d0,.medium
        move.w  #1,qzr_medium_valid-state(a6)
        move.w  #1,qzr_loaded-state(a6)
        lea     24(a5),a0
        movea.l a0,a2
        adda.w  10(a5),a2
        move.l  a2,qzr_track_source-state(a6)
        move.w  12(a5),qzr_track_length-state(a6)
        movea.l #track_buffer,a1
        lea     848(a1),a3
        bsr     cup_unpack
        tst.l   d0
        bne     cup_corrupt
        rts
.failed:
        bsr     qzr_motor_off
        tst.w   qzr_loaded-state(a6)
        bne.s   .error
        clr.w   qzr_medium_valid-state(a6)
.error:
        lea     qzr_load_error(pc),a1
        bsr     qzr_loading_screen
        bsr     qzr_wait_enter
        lea     qzr_loading_text(pc),a1
        bsr     qzr_loading_screen
        bra     .retry

cup_disk_decode_track:
        movea.l qzr_track_source-state(a6),a0
        movea.l a0,a2
        adda.w  qzr_track_length-state(a6),a2
        movea.l #track_buffer,a1
        lea     11312(a1),a3
        bsr     cup_unpack
        tst.l   d0
        bne     cup_corrupt
        rts

qzr_loading_screen:
        move.l  a1,-(sp)
        move.l  #$20000,s_page(a6)
        move.b  #10,mc_stat     ; hide clear/paint, including the cold bootstrap
        movea.l #$20000,a0
        moveq   #0,d0
        moveq   #127,d7
        bsr     fill_256bytes
        movea.l (sp)+,a1
        move.w  #248,d2         ; reserved I/O footer, below every menu caption
        bsr     cup_center
        lea     qzr_medium_hint(pc),a1
        move.w  #228,d2
        bsr     cup_center
        move.b  #8,mc_stat      ; reveal only the complete loading/error screen
        rts

qzr_wait_enter:
.up:
        moveq   #1,d0
        bsr     read_keyrow
        btst    #0,d0
        bne.s   .up
.down:
        moveq   #1,d0
        bsr     read_keyrow
        btst    #0,d0
        beq.s   .down
        rts

        even
qzr_loading_text: dc.b 'LOADING COURSE...',0
qzr_load_error: dc.b 'READ FAILED - PRESS ENTER',0
qzr_medium_hint: dc.b 'KEEP GAME CARTRIDGE IN MDV1',0
qzr_course_file: dc.b 'course0',0
        even
qzr_header: dcb.b 14,0
qzr_medium: dcb.b 12,0
qzr_medium_valid: dc.w 0
qzr_loaded: dc.w 0
qzr_requested: dc.w 0
qzr_map_valid: dc.w 0
qzr_attempts: dc.w 0
qzr_target: dc.w 0
qzr_sector_number: dc.w 0
qzr_block_number: dc.w 0
qzr_file: dc.w 0
qzr_file_size: dc.l 0
qzr_name_ptr: dc.l 0
qzr_directory_block: dc.w 0
qzr_directory_size: dc.w 0
qzr_blocks_left: dc.w 0
qzr_block_count: dc.w 0
qzr_seen: dc.w 0
qzr_track_source: dc.l 0
qzr_track_length: dc.w 0
qzr_map: dcb.b 512,0
qzr_sector_buffer: dcb.b 512,0
