; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Foreground byte reader: bounded LZ history, no disk I/O or interrupt work.
; D0 returns an unsigned byte; all other registers survive. Pitch keeps all
; eight bits. Offset zero resets the history at bank changes and loop points.
cup_music_read:
        movem.l d1-d3/a0-a2,-(sp)
        lea     cup_music_decoder(pc),a2
        tst.w   s_music_offset(a6)
        bne.s   .ready
        movea.l #cup_music_banks,a0
        move.w  s_music_bank(a6),d1
        mulu.w  #6,d1
        move.w  0(a0,d1.w),d1
        adda.w  d1,a0
        move.l  a0,(a2)
        clr.l   4(a2)
.ready:
        movea.l (a2),a0
        tst.w   4(a2)
        bne.s   .byte
        moveq   #0,d1
        move.b  (a0)+,d1
        bmi.s   .match
        addq.w  #1,d1
        clr.w   6(a2)
        bra.s   .command
.match:
        andi.w  #127,d1
        addq.w  #3,d1
        moveq   #0,d2
        move.b  (a0)+,d2
        lsl.w   #8,d2
        move.b  (a0)+,d2
        move.w  d2,6(a2)
.command:
        move.w  d1,4(a2)
.byte:
        lea     cup_music_history(pc),a1
        move.w  s_music_offset(a6),d1
        andi.w  #511,d1
        moveq   #0,d0
        move.w  6(a2),d2
        beq.s   .literal
        move.w  d1,d3
        sub.w   d2,d3
        andi.w  #511,d3
        move.b  0(a1,d3.w),d0
        bra.s   .store
.literal:
        move.b  (a0)+,d0
.store:
        move.b  d0,0(a1,d1.w)
        move.l  a0,(a2)
        subq.w  #1,4(a2)
        addq.w  #1,s_music_offset(a6)
        movem.l (sp)+,d1-d3/a0-a2
        rts
        even
cup_music_decoder: dc.l 0
        dc.w 0,0
cup_music_history: dcb.b 512,0
