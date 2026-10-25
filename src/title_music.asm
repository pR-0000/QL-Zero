; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Relocatable foreground QDOS CALL, original 68000/68008 and 8049 only.
; Loaded over the title file, then overwritten by the race. No resident RAM.
; QDOS owns interrupts and IPC throughout; no MMIO or supervisor takeover.
; ENTER opens the mode selector, then a second press confirms the choice.

intro_entry:
        movem.l d1-d7/a0-a6,-(sp)
        lea     intro_state(pc),a5
        bsr     intro_menu_init
        clr.b   intro_released-intro_state(a5)
        clr.w   intro_clock-intro_state(a5)
        move.w  #-4,intro_key_clock-intro_state(a5)
        lea     intro_poll_link(pc),a0
        lea     intro_poll_tick(pc),a1
        move.l  a1,4(a0)
        bsr     intro_link_clock
        lea     music_data(pc),a4
        move.l  a4,intro_stream-intro_state(a5)
        clr.w   intro_deadline-intro_state(a5)
        bsr     intro_silence
intro_tick:
        bsr     intro_music_update
        move.w  intro_clock-intro_state(a5),d7
        move.w  d7,d0
        sub.w   intro_key_clock-intro_state(a5),d0
        cmpi.w  #4,d0
        blo.s   .wait
        move.w  d7,intro_key_clock-intro_state(a5)
        bsr     intro_menu_keys
        tst.w   d0
        bne.s   intro_exit
.wait:
        movem.l d1-d7/a0-a6,-(sp)
        moveq   #8,d0                 ; MT.SUSJB, current job, one PAL tick
        moveq   #-1,d1
        moveq   #1,d3
        suba.l  a1,a1
        trap    #1
        movem.l (sp)+,d1-d7/a0-a6
        bra     intro_tick
intro_exit:
        ; Remove our callback before BASIC overwrites this temporary overlay.
        bsr     intro_unlink_clock
        bsr     intro_silence
        ; Restore LOADING before the slow microdrive read of the race.
        lea     intro_loading_pixels(pc),a0
        movea.l #$20000+248*128+40,a1  ; reserved bottom I/O footer
        moveq   #7,d1
.row:
        moveq   #11,d0
.word:
        move.l  (a0)+,(a1)+
        dbra    d0,.word
        adda.w  #80,a1               ; 128-byte stride, 48-byte footer
        dbra    d1,.row
        movem.l (sp)+,d1-d7/a0-a6
        moveq   #0,d0                 ; SuperBASIC CALL success contract
        rts

; Called both by the idle loop and bounded drawing slices. State survives
; menu_draw's register use; IPC remains serialized in QDOS foreground code.
intro_music_update:
        movem.l d0-d7/a0-a6,-(sp)
        lea     intro_state(pc),a5
        move.w  intro_clock-intro_state(a5),d7
        move.w  intro_deadline-intro_state(a5),d6
        move.w  d6,d0
        sub.w   d7,d0
        bgt.s   .done
        movea.l intro_stream-intro_state(a5),a4
.next:
        moveq   #0,d0
        move.b  (a4)+,d0
        cmpi.b  #$ff,d0
        bne.s   .event
        lea     music_data(pc),a4
        bra.s   .next
.event:
        moveq   #0,d1
        move.b  (a4)+,d1
        lsl.w   #8,d1
        move.b  (a4)+,d1
        add.w   d1,d6
        moveq   #0,d2
        move.b  (a4)+,d2
        move.w  intro_clock-intro_state(a5),d7
        move.w  d6,d1
        sub.w   d7,d1
        ble.s   .next
        move.l  a4,intro_stream-intro_state(a5)
        move.w  d6,intro_deadline-intro_state(a5)
        cmpi.b  #$fe,d0
        beq.s   .rest
        bsr     intro_tone
        bra.s   .done
.rest:
        bsr     intro_silence
.done:
        movem.l (sp)+,d0-d7/a0-a6
        rts

; Only a clock counter runs in QDOS's 50 Hz poll list. Sound and keyboard
; remain serialized in the foreground. Original JS ROM MT.LPOLL/MT.RPOLL.
intro_poll_tick:
        move.l  a0,-(sp)
        lea     intro_clock(pc),a0
        addq.w  #1,(a0)
        movea.l (sp)+,a0
        rts
intro_link_clock:
        movem.l d0-d7/a0-a6,-(sp)
        lea     intro_poll_link(pc),a0
        moveq   #$1c,d0
        trap    #1
        movem.l (sp)+,d0-d7/a0-a6
        rts
intro_unlink_clock:
        movem.l d0-d7/a0-a6,-(sp)
        lea     intro_poll_link(pc),a0
        moveq   #$1d,d0
        trap    #1
        movem.l (sp)+,d0-d7/a0-a6
        rts

intro_keys:
        movem.l d6-d7,-(sp)
        moveq   #0,d6
        moveq   #7,d7
.row:
        move.b  d7,intro_key_param-intro_state(a5)
        lea     intro_key_packet-intro_state(a5),a3
        bsr     intro_ipcom
        or.b    d0,d6
        dbra    d7,.row
        move.b  d6,d0
        movem.l (sp)+,d6-d7
        rts

intro_tone:
        addq.w  #1,d0                 ; stream pitch -> raw IPC period
        mulu.w  #6,d2
        lea     music_effects(pc),a0
        adda.w  d2,a0
        move.w  d0,d1
        add.w   (a0)+,d1
        cmpi.w  #1,d1
        bge.s   .floor
        moveq   #1,d1
.floor:
        cmpi.w  #255,d1
        ble.s   .limit
        move.w  #255,d1
.limit:
        cmp.w   d0,d1
        bge.s   .ordered
        exg     d0,d1
.ordered:
        lea     intro_sound_params-intro_state(a5),a3
        move.b  d0,(a3)+
        move.b  d1,(a3)+
        move.w  (a0)+,d2
        ror.w   #8,d2                 ; IPC interval is little-endian
        move.w  d2,(a3)+
        clr.w   (a3)+                 ; sustain, no firmware duration limit
        move.b  (a0)+,(a3)+
        move.b  (a0)+,(a3)+
        lea     intro_sound_packet-intro_state(a5),a3
        bra.s   intro_ipcom
intro_silence:
        lea     intro_kill_packet-intro_state(a5),a3
intro_ipcom:
        ; Original ROM IPC routine also destroys D5. Keep stream/counters and
        ; the BASIC caller's registers independent of the ROM implementation.
        movem.l d1-d7/a0-a6,-(sp)
        moveq   #$11,d0
        trap    #1
        move.l  d1,d0
        movem.l (sp)+,d1-d7/a0-a6
        rts

        even
intro_state:
intro_poll_link: dc.l 0,0
intro_clock: dc.w 0
intro_key_clock: dc.w 0
intro_stream: dc.l 0
intro_deadline: dc.w 0
intro_mode: dc.w 0
intro_level: dc.w 1
intro_course: dc.w 0
intro_old_keys: dc.w 255
intro_menu_stage: dc.w 0
intro_sound_packet:
        dc.b    10,8
        dc.l    $0000aaaa
intro_sound_params:
        dc.b    1,1,0,0,0,0,0,0,1
        even
intro_kill_packet:
        dc.b    11,0
        dc.l    0
        dc.b    1
        even
intro_key_packet:
        dc.b    9,1
        dc.l    0
intro_key_param:
        dc.b    0,2
intro_released:
        dc.b    0
        even
        include "../assets/music/music_title.inc"
        include "title_menu.asm"
        even
intro_loading_pixels:
        incbin "../assets/title/intro_loading.q8"
        include "../assets/title/mode_menu.inc"
        ; Temporary decoded icons occupy unused bytes in the SAME allocation
        ; as the title/menu. The game later overwrites this entire allocation.
intro_menu_scratch:
intro_menu_scratch_end equ intro_menu_scratch+mode_menu_icon_bank_bytes
