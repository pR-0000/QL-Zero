; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Byte LZ, bounded input/output and overlapping matches. 68000/68008.
; A0 input, A2 input end, A1 output, A3 output end. D0=0 or -15.
cup_unpack:
        movea.l a1,a4
.command:
        cmpa.l  a2,a0
        beq.s   .end
        bhi.s   .bad
        moveq   #0,d0
        move.b  (a0)+,d0
        bmi.s   .match
        addq.w  #1,d0
        movea.l a0,a5
        adda.w  d0,a5
        cmpa.l  a2,a5
        bhi.s   .bad
        movea.l a1,a5
        adda.w  d0,a5
        cmpa.l  a3,a5
        bhi.s   .bad
        subq.w  #1,d0
.literal:
        move.b  (a0)+,(a1)+
        dbra    d0,.literal
        bra.s   .command
.match:
        andi.w  #127,d0
        addq.w  #3,d0
        movea.l a0,a5
        addq.l  #2,a5
        cmpa.l  a2,a5
        bhi.s   .bad
        moveq   #0,d1
        move.b  (a0)+,d1
        lsl.w   #8,d1
        move.b  (a0)+,d1
        tst.w   d1
        beq.s   .bad
        movea.l a1,a5
        suba.l  d1,a5
        cmpa.l  a4,a5
        blo.s   .bad
        move.l  a1,d2
        add.l   d0,d2
        cmp.l   a3,d2
        bhi.s   .bad
        subq.w  #1,d0
.copy:
        move.b  (a5)+,(a1)+
        dbra    d0,.copy
        bra.s   .command
.end:
        cmpa.l  a3,a1
        bne.s   .bad
        moveq   #0,d0
        rts
.bad:
        moveq   #-15,d0
        rts
