; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; D5/D6 hold the two edge increments throughout a native polygon.
        cmpi.w  #256,d2
        bne.s   .edges
        tst.w   d1
        bne.s   .edges
        ; Near asphalt often covers the entire native row. No masks or
        ; loop bookkeeping; six transfers preserve the live edge increments.
        movea.l a0,a1
        move.l  d0,d1
        move.l  d0,d2
        move.l  d0,d3
        move.l  d0,d4
        movea.l d0,a2
        movem.l d0-d4/a2,0(a1)
        movem.l d0-d4/a2,24(a1)
        movem.l d0-d4/a2,48(a1)
        movem.l d0-d4/a2,72(a1)
        movem.l d0-d4/a2,96(a1)
        movem.l d0-d1,120(a1)
        rts
.edges:
        ; Exact packed offset+left-mask for each native pixel coordinate.
        ; The complement is the exclusive right mask, including x=256.
        movea.l #span_positions,a1
        lsl.w   #2,d1
        move.w  0(a1,d1.w),d3
        move.w  2(a1,d1.w),d1
        lsl.w   #2,d2
        move.w  0(a1,d2.w),d4
        move.w  2(a1,d2.w),d2
        not.w   d2
        lea     0(a0,d3.w),a1
        lea     0(a0,d4.w),a2
        cmpa.l  a1,a2
        bne.s   .different_words
        and.w   d2,d1
        ; Most distant rails occupy one word. No middle/tail handling or
        ; second address comparison is needed for this exact masked write.
        move.w  d0,d4
        and.w   d1,d4
        not.w   d1
        and.w   (a1),d1
        or.w    d1,d4
        move.w  d4,(a1)
        rts
.different_words:
        cmpi.w  #$ffff,d1
        beq.s   .whole_words
.masked_first:
        move.w  d0,d4
        and.w   d1,d4
        not.w   d1
        and.w   (a1),d1
        or.w    d1,d4
        move.w  d4,(a1)+
        cmpa.l  a1,a2
        ; Equal-word case has advanced past its exclusive word address.
        blo     .done
.whole_words:
        move.l  a2,d3
        sub.l   a1,d3
        ; Every whole longword uses a two-byte postincrement store. A Duff
        ; entry avoids the MOVEM block's address update/DBRA instruction
        ; fetches on the QL's eight-bit bus. Edge words stay exact.
        move.w  d3,d4
        lsr.w   #2,d3
        add.w   d3,d3
        neg.w   d3
        jmp     .middle_end(pc,d3.w)
        include "data/span_stores.inc"
.middle_end:
        btst    #1,d4
        beq.s   .last_word
        move.w  d0,(a1)+
.last_word:
        move.w  d2,d1
        beq.s   .done
        move.w  d0,d4
        and.w   d1,d4
        not.w   d1
        and.w   (a1),d1
        or.w    d1,d4
        move.w  d4,(a1)
.done:
        rts
