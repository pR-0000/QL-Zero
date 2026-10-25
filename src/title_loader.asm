; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Relocatable user-mode QDOS CALL. No traps, MMIO, heap or OS changes.
; Loaded at a+512. The ready routine is retained at a while the
; game replaces this file at a+512. Everything is discarded by takeover.
; SuperBASIC CALL enters with D0=-15 and interprets the returned D0 as an
; error code. Preserve D1-D7/A0-A6, but return D0=0 after a successful CALL.
title_entry:
        movem.l d0-d7/a0-a6,-(sp)
        lea     ready_code(pc),a0
        lea     title_entry(pc),a1
        suba.l  #512,a1
        move.w  #(ready_end-ready_code)/2-1,d0
.retain:
        move.w  (a0)+,(a1)+
        dbra    d0,.retain
        lea     packed(pc),a0
        lea     packed_end(pc),a4
        movea.l #$20000,a1
        movea.l #$28000,a5
.token:
        cmpa.l  a5,a1
        beq     .complete
        cmpa.l  a4,a0
        bhs     .invalid
        moveq   #0,d0
        move.b  (a0)+,d0
        bmi.s   .match
        move.w  d0,d2
        addq.w  #1,d2
        movea.l a0,a3
        adda.w  d2,a3
        cmpa.l  a4,a3
        bhi     .invalid
        movea.l a1,a3
        adda.w  d2,a3
        cmpa.l  a5,a3
        bhi     .invalid
.literal:
        move.b  (a0)+,(a1)+
        dbra    d0,.literal
        bra.s   .token
.match:
        andi.w  #127,d0
        addq.w  #2,d0
        move.w  d0,d2
        addq.w  #1,d2
        movea.l a1,a3
        adda.w  d2,a3
        cmpa.l  a5,a3
        bhi.s   .invalid
        lea     2(a0),a3
        cmpa.l  a4,a3
        bhi.s   .invalid
        moveq   #0,d1
        move.b  (a0)+,d1
        lsl.w   #8,d1
        move.b  (a0)+,d1
        tst.w   d1
        beq.s   .invalid
        movea.l a1,a2
        suba.l  d1,a2
        cmpa.l  #$20000,a2
        blo.s   .invalid
.copy:
        move.b  (a2)+,(a1)+
        dbra    d0,.copy
        bra     .token
.complete:
        cmpa.l  a4,a0
        bne.s   .invalid
        movem.l (sp)+,d0-d7/a0-a6
        moveq   #0,d0
        rts
.invalid:
        movem.l (sp)+,d0-d7/a0-a6
        moveq   #-15,d0
        rts

        even
ready_code:
        movem.l d0-d1/a0-a1,-(sp)
        lea     ready_pixels(pc),a0
        movea.l #$20000+248*128+40,a1
        moveq   #7,d1
.row:
        moveq   #23,d0
.word:
        move.w  (a0)+,(a1)+
        dbra    d0,.word
        lea     80(a1),a1
        dbra    d1,.row
        movem.l (sp)+,d0-d1/a0-a1
        moveq   #0,d0
        rts
ready_pixels:
        incbin  "../assets/title/ready.q8"
ready_end:
        ifgt ready_end-ready_code-512
        fail "Ready routine exceeds its 512-byte reservation"
        endif
packed:
        incbin  "../assets/title/loading.lz"
packed_end:
        even
