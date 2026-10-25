; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Best full Time Attack race: standing start at GO, three continuous laps.
; Two 896-byte buffers, adaptive 5 Hz samples, no racing I/O. File version 2
; distinguishes a complete race from legacy flying-lap recordings.
ghost_capacity equ 224
ghost_bytes equ 896
cup_ghost_load:
        cmpi.w  #1,cup_mode-state(a6)
        bne     .done
        movem.l d0-d7/a0-a5,-(sp)
        move.w  cup_round-state(a6),d0
        cmp.w   ghost_course-state(a6),d0
        beq     .reset
        move.w  d0,ghost_course-state(a6)
        lea     ghost_buffer0-state(a6),a0
        move.l  a0,ghost_play-state(a6)
        lea     ghost_buffer1-state(a6),a0
        move.l  a0,ghost_record-state(a6)
        clr.w   ghost_valid-state(a6)
        clr.w   ghost_dirty-state(a6)
        clr.l   ghost_generation-state(a6)
        clr.w   ghost_active_slot-state(a6)
        bsr     qzr_motor_on
        bsr     qzr_map_read
        tst.l   d0
        bne     .off
        clr.w   ghost_slot-state(a6)
.slot:
        bsr     ghost_name_for_slot
        bsr     qzr_find
        tst.l   d0
        bne     .next
        cmpi.l  #1024,qzr_file_size-state(a6)
        bne     .next
        bsr     qzr_read_file
        tst.l   d0
        bne     .next
        bsr     ghost_check_file
        tst.l   d0
        bne     .next
        movea.l #$28040,a0
        tst.w   ghost_valid-state(a6)
        beq.s   .apply
        move.l  12(a0),d0
        sub.l   ghost_generation-state(a6),d0
        ble     .next
.apply:
        move.l  12(a0),ghost_generation-state(a6)
        move.l  16(a0),ghost_best-state(a6)
        move.w  20(a0),ghost_count-state(a6)
        move.w  22(a0),ghost_interval-state(a6)
        move.w  24(a0),ghost_duration-state(a6)
        move.w  ghost_slot-state(a6),ghost_active_slot-state(a6)
        lea     32(a0),a0
        movea.l ghost_play-state(a6),a1
        move.w  #ghost_bytes/4-1,d0
.copy:
        move.l  (a0)+,(a1)+
        dbra    d0,.copy
        move.w  #1,ghost_valid-state(a6)
.next:
        addq.w  #1,ghost_slot-state(a6)
        cmpi.w  #2,ghost_slot-state(a6)
        blo     .slot
.off:
        bsr     qzr_motor_off
.reset:
        clr.w   ghost_active-state(a6)
        move.w  #1,ghost_wait_start-state(a6)
        clr.w   ghost_clock-state(a6)
        clr.w   ghost_samples-state(a6)
        clr.w   ghost_next-state(a6)
        move.w  #10,ghost_step-state(a6)
        move.w  #-1,ghost_node-state(a6)
        movem.l (sp)+,d0-d7/a0-a5
.done:
        rts

cup_ghost_tick:
        cmpi.w  #1,cup_mode-state(a6)
        bne     .done
        tst.w   cup_phase-state(a6)
        bne     .done
        tst.w   s_started(a6)
        beq     .done
        tst.w   s_dead(a6)
        bne     .done
        tst.w   cup_finishing-state(a6)
        bne     .done
        movem.l d0-d2/a0-a1,-(sp)
        tst.w   ghost_wait_start-state(a6)
        bne.s   .restore
        move.w  ghost_clock-state(a6),d0
        cmpi.w  #60000,d0
        bhs.s   .restore
        cmp.w   ghost_next-state(a6),d0
        blo.s   .advance
        bsr     ghost_append
        move.w  ghost_step-state(a6),d0
        add.w   d0,ghost_next-state(a6)
.advance:
        addq.w  #1,ghost_clock-state(a6)
.restore:
        movem.l (sp)+,d0-d2/a0-a1
.done:
        rts

ghost_append:
        cmpi.w  #ghost_capacity,ghost_samples-state(a6)
        blo.s   .append
        ; One bounded compaction, only every 45/90/180... seconds.
        movea.l ghost_record-state(a6),a0
        movea.l a0,a1
        moveq   #ghost_capacity/2-1,d1
.compact:
        move.l  (a0),(a1)+
        addq.l  #8,a0
        dbra    d1,.compact
        move.w  #ghost_capacity/2,ghost_samples-state(a6)
        move.w  ghost_step-state(a6),d0
        add.w   d0,ghost_step-state(a6)
.append:
        movea.l ghost_record-state(a6),a0
        move.w  ghost_samples-state(a6),d1
        lsl.w   #2,d1
        move.l  s_x(a6),0(a0,d1.w)
        addq.w  #1,ghost_samples-state(a6)
        rts

; Called at each finish-line crossing. Only lap 3 seals a complete race;
; laps 1 and 2 never reset the sample clock or the playback position.
cup_ghost_lap:
        cmpi.w  #1,cup_mode-state(a6)
        bne     .done
        cmpi.w  #3,s_laps(a6)
        bne     .done
        movem.l d0-d7/a0-a5,-(sp)
        tst.w   ghost_clock-state(a6)
        beq     .restore
        cmpi.w  #60000,ghost_clock-state(a6)
        bhs     .restore
        cmpi.w  #2,ghost_samples-state(a6)
        blo     .restore
        move.l  s_race_ticks(a6),d1
        tst.w   ghost_valid-state(a6)
        beq.s   .best
        cmp.l   ghost_best-state(a6),d1
        bhs.s   .restore
.best:
        move.l  d1,-(sp)
        bsr     ghost_append       ; terminal crossing, at the next sample slot
        move.l  (sp)+,ghost_best-state(a6)
        move.w  ghost_clock-state(a6),ghost_duration-state(a6)
        move.w  ghost_samples-state(a6),ghost_count-state(a6)
        move.w  ghost_step-state(a6),ghost_interval-state(a6)
        move.l  ghost_play-state(a6),d0
        move.l  ghost_record-state(a6),ghost_play-state(a6)
        move.l  d0,ghost_record-state(a6)
        move.w  #1,ghost_valid-state(a6)
        move.w  #1,ghost_dirty-state(a6)
.restore:
        movem.l (sp)+,d0-d7/a0-a5
.done:
        rts

cup_draw_ghost:
        clr.w   ghost_active-state(a6)
        cmpi.w  #1,cup_mode-state(a6)
        bne     .done
        tst.w   s_started(a6)
        beq     .done
        tst.w   cup_phase-state(a6)
        bne     .done
        tst.w   ghost_wait_start-state(a6)
        bne     .done
        tst.w   ghost_visible-state(a6)
        beq     .done
        tst.w   ghost_valid-state(a6)
        beq     .done
        tst.w   s_dead(a6)
        bne     .done
        tst.w   cup_finishing-state(a6)
        bne     .done
        movem.l d0-d7/a0-a5,-(sp)
        moveq   #0,d0
        move.w  ghost_clock-state(a6),d0
        cmp.w   ghost_duration-state(a6),d0
        bhs     .restore
        divu.w  ghost_interval-state(a6),d0
        move.w  d0,d3
        addq.w  #1,d3
        cmp.w   ghost_count-state(a6),d3
        bhs     .restore
        subq.w  #1,d3
        move.w  d3,d4
        lsl.w   #2,d4
        movea.l ghost_play-state(a6),a0
        adda.w  d4,a0
        swap    d0
        andi.l  #$ffff,d0
        lsl.l   #8,d0
        move.w  ghost_interval-state(a6),d6
        move.w  ghost_count-state(a6),d7
        subq.w  #2,d7
        cmp.w   d7,d3
        bne.s   .fraction
        mulu.w  d7,d6
        neg.w   d6
        add.w   ghost_duration-state(a6),d6
.fraction:
        divu.w  d6,d0
        move.w  4(a0),d1
        sub.w   (a0),d1
        move.w  6(a0),d2
        sub.w   2(a0),d2
        move.w  d1,d4
        move.w  d2,d5
        muls.w  d0,d4
        asr.l   #8,d4
        add.w   (a0),d4
        move.w  d4,s_rivals+4(a6)
        muls.w  d0,d5
        asr.l   #8,d5
        add.w   2(a0),d5
        move.w  d5,s_rivals+6(a6)
        move.w  #1,ghost_active-state(a6) ; one shared pose for sprite/map/CHECK
        cmp.w   ghost_node-state(a6),d3
        beq.s   .camera
        move.w  d3,ghost_node-state(a6)
        move.w  d1,d0
        move.w  d2,d1
        bsr     vector_angle
        move.w  d0,s_rivals+14(a6)
.camera:
        lea     s_rivals+4(a6),a0
        lea     s_rival_camera(a6),a1
        bsr     world_to_camera
        ; Calibrate the near projection against the fixed player's anchor.
        ; At identical world coordinates both hulls must occupy (104,156),
        ; instead of the NPC camera placing the ghost 26 pixels ahead.
        ; The depth bias tends to zero on screen with increasing distance.
        lea     s_x(a6),a0
        lea     s_rival_camera+4(a6),a1
        bsr     world_to_camera
        move.w  s_rival_camera+4(a6),d0
        sub.w   d0,s_rival_camera(a6)
        move.w  #186,d0
        sub.w   s_view_horizon(a6),d0
        move.l  #28672,d1
        divu.w  d0,d1
        sub.w   s_rival_camera+6(a6),d1
        add.w   d1,s_rival_camera+2(a6)
        move.w  #32,s_npc_damage(a6) ; spectral white, existing row blitter
        moveq   #0,d7
        bsr     draw_one_rival
.restore:
        movem.l (sp)+,d0-d7/a0-a5
.done:
        rts

; One status line below the mini-map. Refresh only on F4 or a HUD clear.
; Reuse spare HUD-cache words: no extra buffers or per-tick work.
ghost_active equ cup_hud_cache+16
cup_ghost_status:
        cmpi.w  #1,cup_mode-state(a6)
        bne.s   .done
        move.w  ghost_visible-state(a6),d0
        cmp.w   cup_hud_cache+14-state(a6),d0
        beq.s   .done
        move.w  d0,cup_hud_cache+14-state(a6)
        lea     ghost_status_text(pc),a1
        tst.w   d0
        beq.s   .draw
        adda.w  #10,a1
.draw:
        moveq   #2,d1
        move.w  #248,d2
        moveq   #9,d4
        bra     draw_text
.done:
        rts

ghost_name_for_slot:
        lea     ghost_name(pc),a0
        move.w  ghost_course-state(a6),d0
        addi.b  #'0',d0
        move.b  d0,5(a0)
        move.w  ghost_slot-state(a6),d0
        addi.b  #'a',d0
        move.b  d0,6(a0)
        rts

ghost_check_file:
        movea.l #$28040,a0
        cmpi.l  #$515a4731,(a0)
        bne     .bad
        cmpi.l  #qzr_game_id,4(a0)
        bne     .bad
        cmpi.w  #2,8(a0)       ; never replay an old flying lap as a full race
        bne     .bad
        move.w  ghost_course-state(a6),d0
        cmp.w   10(a0),d0
        bne     .bad
        cmpi.w  #2,20(a0)
        blo     .bad
        cmpi.w  #ghost_capacity,20(a0)
        bhi     .bad
        move.w  22(a0),d0
        cmpi.w  #10,d0
        blo     .bad
        cmpi.w  #2560,d0
        bhi     .bad
        moveq   #0,d1
        move.w  d0,d1
        divu.w  #10,d1
        move.l  d1,d2
        swap    d2
        tst.w   d2
        bne     .bad
        move.w  d1,d2
        subq.w  #1,d2
        and.w   d1,d2
        bne     .bad
        cmpi.w  #60000,24(a0)
        bhs     .bad
        tst.w   24(a0)
        beq     .bad
        move.w  20(a0),d1
        subq.w  #2,d1
        mulu.w  d0,d1
        moveq   #0,d2
        move.w  24(a0),d2
        cmp.l   d1,d2
        bls     .bad
        andi.l  #$ffff,d0
        add.l   d0,d1
        cmp.l   d1,d2
        bhi     .bad
        move.l  28(a0),ghost_crc-state(a6)
        clr.l   28(a0)
        move.l  #960,d0
        bsr     qzr_crc32
        move.l  ghost_crc-state(a6),$28040+28
        cmp.l   ghost_crc-state(a6),d0
        bne.s   .bad
        moveq   #0,d0
        rts
.bad:
        moveq   #-7,d0
        rts

; Two-sector inactive-slot write, verify each block and the complete CRC.
cup_ghost_flush:
        moveq   #0,d0
        cmpi.w  #11,cup_phase-state(a6)
        beq     .done
        tst.w   ghost_dirty-state(a6)
        beq     .done
        tst.w   cup_phase-state(a6)
        beq     .done
        cmpi.w  #7,cup_phase-state(a6)
        beq     .done
        cmpi.w  #3,cup_phase-state(a6)
        beq     .done
        cmpi.w  #9,cup_phase-state(a6)
        beq     .done
        cmpi.w  #10,cup_phase-state(a6)
        beq     .done
        movem.l d1-d7/a0-a5,-(sp)
        movea.l #$27c00,a0
        moveq   #0,d0
        moveq   #3,d7
        bsr     fill_256bytes
        lea     qzr_saving_text(pc),a1
        move.w  #248,d2
        bsr     cup_center
        bsr     qzr_motor_on
        bsr     qzr_map_read
        tst.l   d0
        bne     .failed
        move.w  ghost_active_slot-state(a6),d0
        eori.w  #1,d0
        move.w  d0,ghost_slot-state(a6)
        bsr     ghost_name_for_slot
        bsr     qzr_find
        tst.l   d0
        bne     .failed
        cmpi.l  #1024,qzr_file_size-state(a6)
        bne     .failed
        bsr     qzr_read_file      ; retain QDOS header in staging
        tst.l   d0
        bne     .failed
        movea.l #$28040,a0
        move.w  #239,d0
.clear:
        clr.l   (a0)+
        dbra    d0,.clear
        movea.l #$28040,a0
        move.l  #$515a4731,(a0)
        move.l  #qzr_game_id,4(a0)
        move.w  #2,8(a0)
        move.w  ghost_course-state(a6),10(a0)
        move.l  ghost_generation-state(a6),d0
        addq.l  #1,d0
        move.l  d0,12(a0)
        move.l  ghost_best-state(a6),16(a0)
        move.w  ghost_count-state(a6),20(a0)
        move.w  ghost_interval-state(a6),22(a0)
        move.w  ghost_duration-state(a6),24(a0)
        lea     32(a0),a1
        movea.l ghost_play-state(a6),a0
        move.w  #ghost_bytes/4-1,d0
.samples:
        move.l  (a0)+,(a1)+
        dbra    d0,.samples
        movea.l #$28040,a0
        move.l  #960,d0
        bsr     qzr_crc32
        move.l  d0,$28040+28
        clr.w   ghost_block-state(a6)
.block:
        move.w  qzr_file-state(a6),d0
        lsl.w   #8,d0
        or.w    ghost_block-state(a6),d0
        move.w  d0,qzr_target-state(a6)
        bsr     qzr_sector
        tst.l   d0
        bne     .failed
        move.w  qzr_sector_number-state(a6),qzr_write_sector-state(a6)
        movea.l #$28000,a0
        move.w  ghost_block-state(a6),d0
        lsl.w   #8,d0
        add.w   d0,d0
        adda.w  d0,a0
        lea     qzr_sector_buffer(pc),a1
        moveq   #127,d0
.sector:
        move.l  (a0)+,(a1)+
        dbra    d0,.sector
        move.w  #1024,qzr_attempts-state(a6)
        bsr     qzr_seek_write
        tst.l   d0
        bne     .failed
        move.w  qzr_target-state(a6),-(sp)
        lea     qzr_sector_buffer(pc),a1
        lea     pc_ipcrd,a3
        movea.w $126,a4
        jsr     $4000(a4)
        addq.l  #2,sp
        move.w  #1024,qzr_attempts-state(a6)
        bsr     qzr_seek_write
        tst.l   d0
        bne     .failed
        lea     qzr_sector_buffer(pc),a1
        lea     pc_ipcrd,a3
        movea.w $128,a4
        jsr     $4000(a4)
        bra     .failed
        move.w  qzr_target-state(a6),d0
        cmp.b   d0,d2
        bne.s   .failed
        lsr.w   #8,d0
        cmp.b   d0,d1
        bne.s   .failed
        addq.w  #1,ghost_block-state(a6)
        cmpi.w  #2,ghost_block-state(a6)
        blo     .block
        bsr     qzr_read_file
        tst.l   d0
        bne.s   .failed
        bsr     ghost_check_file
        tst.l   d0
        bne.s   .failed
        addq.l  #1,ghost_generation-state(a6)
        move.w  ghost_slot-state(a6),ghost_active_slot-state(a6)
        clr.w   ghost_dirty-state(a6)
        bra.s   .off
.failed:
        move.w  #2,qzr_save_status-state(a6)
.off:
        bsr     qzr_motor_off
        bsr     qzr_clear_status
        clr.w   s_cache0(a6)
        clr.w   s_sky_horizon0(a6)
        cmpi.w  #5,cup_phase-state(a6)
        bne.s   .restore
        bsr     music_init
.restore:
        movem.l (sp)+,d1-d7/a0-a5
        moveq   #1,d0
.done:
        rts

ghost_course: dc.w -1
ghost_visible: dc.w 0
ghost_valid: dc.w 0
ghost_dirty: dc.w 0
ghost_play: dc.l 0
ghost_record: dc.l 0
ghost_clock: dc.w 0
ghost_wait_start: dc.w 1
ghost_next: dc.w 0
ghost_samples: dc.w 0
ghost_step: dc.w 10
ghost_count: dc.w 0
ghost_interval: dc.w 10
ghost_duration: dc.w 0
ghost_node: dc.w -1
ghost_best: dc.l 0
ghost_generation: dc.l 0
ghost_crc: dc.l 0
ghost_active_slot: dc.w 0
ghost_slot: dc.w 0
ghost_block: dc.w 0
ghost_name: dc.b 'ghost0a',0
ghost_hint: dc.b 'F4: GHOST ON/OFF',0
ghost_status_text: dc.b 'GHOST:OFF',0,'GHOST: ON',0
        even
ghost_buffer0: dcb.b ghost_bytes,0
ghost_buffer1: dcb.b ghost_bytes,0
