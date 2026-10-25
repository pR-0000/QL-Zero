; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Foreground 50 Hz sequencer for midi2ql format 2. No interrupt owns IPC:
; keyboard and sound packets complete serially, on the original 8049.
; The beeper sustains autonomously; missed events are skipped, never burst.
music_init:
        move.w  #1,s_music_enabled(a6)
        move.w  #1,s_music_ready(a6)
        clr.w   s_music_offset(a6)
        move.w  s_ticks(a6),s_music_deadline(a6)
        lea     s_sound_packet(a6),a0
        move.w  #$0a08,(a0)+
        move.l  #$0000aaaa,(a0)+
        clr.l   (a0)+
        clr.l   (a0)+
        move.b  #1,(a0)
        rts

music_toggle:
        movem.l d0-d4/a0-a3,-(sp)
        eori.w  #1,s_music_enabled(a6)
        tst.w   s_music_enabled(a6)
        bne.s   .restart
        bsr     music_stop
        bra.s   .done
.restart:
        clr.w   s_music_offset(a6)
        move.w  s_ticks(a6),s_music_deadline(a6)
.done:
        movem.l (sp)+,d0-d4/a0-a3
        rts

music_update:
        tst.w   s_music_ready(a6)
        beq     .done
        tst.w   s_music_enabled(a6)
        beq     .done
        ; Most VBLs have no note due: save one register, rather than nine.
        ; A due event enters exactly the same sequencer and IPC packet path.
        move.l  d4,-(sp)
        move.w  s_ticks(a6),d4
        sub.w   s_music_deadline(a6),d4
        bpl.s   .due
        move.l  (sp)+,d4
        rts
.due:
        movem.l d0-d3/a0-a3,-(sp)
.next:
        bsr     cup_music_read
        cmpi.b  #255,d0
        bne.s   .event
        movea.l #cup_music_banks,a0
        move.w  s_music_bank(a6),d1
        mulu.w  #6,d1
        tst.w   4(a0,d1.w)
        beq.s   .finished
        clr.w   s_music_offset(a6)
        bra.s   .next
.finished:
        clr.w   s_music_enabled(a6)
        bsr     music_stop
        bra     .restore
.event:
        move.w  d0,s_music_pitch(a6)
        bsr     cup_music_read
        tst.b   d0
        beq.s   .escape
        move.w  d0,d1
        andi.w  #127,d1
        lsr.w   #7,d0
        move.w  d0,s_music_effect(a6)
        bra.s   .duration_ready
.escape:
        bsr     cup_music_read
        move.w  d0,d1
        lsl.w   #8,d1
        bsr     cup_music_read
        or.w    d0,d1
        bsr     cup_music_read
        move.w  d0,s_music_effect(a6)
.duration_ready:
        add.w   d1,s_music_deadline(a6)
        move.w  s_ticks(a6),d4
        sub.w   s_music_deadline(a6),d4
        bpl     .next
        cmpi.w  #$fe,s_music_pitch(a6)
        beq.s   .rest
        bsr     music_note
        bra.s   .restore
.rest:
        bsr     music_stop
.restore:
        movem.l (sp)+,d0-d3/a0-a3
        move.l  (sp)+,d4
.done:
        rts

music_note:
        move.w  s_music_pitch(a6),d0
        addq.w  #1,d0             ; BEEP value -> IPC counter
        move.w  s_music_effect(a6),d2
        mulu.w  #6,d2
        movea.l #cup_music_banks,a0
        move.w  s_music_bank(a6),d1
        mulu.w  #6,d1
        move.w  2(a0,d1.w),d1
        adda.w  d1,a0
        adda.w  d2,a0
        move.w  d0,d1
        add.w   (a0)+,d1
        cmpi.w  #1,d1
        bge.s   .floor
        moveq   #1,d1
.floor:
        cmpi.w  #255,d1
        ble.s   .bounds
        move.w  #255,d1
.bounds:
        cmp.w   d0,d1
        bge.s   .ordered
        exg     d0,d1
.ordered:
        lea     s_sound_packet+6(a6),a3
        move.b  d0,(a3)+
        move.b  d1,(a3)+
        move.w  (a0)+,d2
        ror.w   #8,d2
        move.w  d2,(a3)+          ; little-endian IPC interval
        clr.w   (a3)+            ; sustained until next event, no busy wait
        move.b  (a0)+,(a3)+
        move.b  (a0)+,(a3)+
        lea     s_sound_packet(a6),a3
        bsr     music_send
        tst.w   s_ipc_failed(a6)
        bne.s   .failed
        move.w  #1,s_music_active(a6)
        rts
.failed:
        clr.w   s_music_enabled(a6)
        rts

music_stop:
        tst.w   s_music_active(a6)
        beq.s   .done
        movem.l d0-d4/a0-a3,-(sp)
        lea     music_kill_packet(pc),a3
        bsr     music_send
        clr.w   s_music_active(a6)
        movem.l (sp)+,d0-d4/a0-a3
.done:
        rts

; A3 = QDOS IPC packet. The direct path uses the SAME serialized nibble
; routine as KEYROW. Nothing calls this from the QDOS polling interrupt.
music_send:
        movem.l d5/a4,-(sp)
        bsr     poll_vbl
        ; Original JS ROM MT.IPCOM destroys D5 (parameter descriptor).
        ; A timestamp must live on the stack, not in a trap scratch register.
        move.w  s_ticks(a6),-(sp)
        bsr     music_send_packet
        bsr     poll_vbl
        move.w  s_ticks(a6),d0
        sub.w   (sp)+,d0
        movea.l #frame_profile,a4
        add.w   d0,24(a4)
        movem.l (sp)+,d5/a4
        rts
music_send_packet:
        clr.w   s_ipc_failed(a6)
        move.b  (a3),d0
        bsr     ipc_nibble
        moveq   #0,d4
        move.b  1(a3),d4
        beq.s   .done
        subq.w  #1,d4
        lea     6(a3),a0
.parameter:
        move.b  (a0)+,d3
        move.b  d3,d0
        lsr.b   #4,d0
        bsr     ipc_nibble
        move.b  d3,d0
        andi.w  #15,d0
        bsr     ipc_nibble
        dbra    d4,.parameter
.done:
        rts

music_kill_packet:
        dc.b    11,0
        dc.l    0
        dc.b    1
        even
