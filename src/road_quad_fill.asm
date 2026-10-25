; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Only whole-width spans are emitted directly to all four physical rows.
; Subsequent sample writes dirty four 32-byte chunks. Final expansion copies
; only those chunks; other bands retain the original complete expansion.
fill_road_four_span:
        tst.w   s_contour_collect(a6)
        beq.s   .contour_recorded
        tst.b   (a3)
        bpl.s   .contour_recorded
        movea.l s_contour_next(a6),a1
        cmpa.l  s_contour_end(a6),a1
        bhs.s   .contour_full
        move.l  a0,(a1)+
        move.w  s_contour_left(a6),(a1)+
        move.w  s_contour_right(a6),(a1)+
        move.l  a1,s_contour_next(a6)
        bra.s   .contour_recorded
.contour_full:
        move.w  #1,s_contour_overflow(a6)
        clr.w   s_contour_collect(a6)
.contour_recorded:
        tst.b   (a3)
        bmi.s   .forward
        rts
.forward:
        cmpi.l  #$aaffaaff,d0
        beq     fill_rail_span
        bra     fill_road_span
