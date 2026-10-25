; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Single sampled quad: find the two intersected edges directly, avoiding
; general edge records, event spans, stored increments and their reloads.
geometry_single_quad:
        move.w  s_min_y(a6),280(a6)
        move.w  284(a6),d7
        moveq   #4,d6
        bsr.s   geometry_single_edge
        move.w  d0,-(sp)
        move.w  284(a6),d7
        moveq   #-4,d6
        bsr.s   geometry_single_edge
        move.w  d0,d2
        move.w  (sp)+,d1
        cmp.w   d1,d2
        bge.s   .ordered
        exg     d1,d2
.ordered:
        move.w  d1,s_contour_left(a6)
        move.w  d2,s_contour_right(a6)
        tst.w   d1
        bpl.s   .left
        clr.w   d1
.left:
        cmpi.w  #256,d2
        ble.s   .right
        move.w  #256,d2
.right:
        cmp.w   d1,d2
        ble.s   .done
        move.w  s_min_y(a6),d3
        lsr.w   #2,d3
        lea     460(a6),a3
        adda.w  d3,a3
        tst.b   (a3)
        bpl.s   .done
        move.w  s_min_y(a6),d0
        subq.w  #2,d0
        lsr.w   #2,d0
        lsl.w   #7,d0
        movea.l s_frame_budget(a6),a0
        adda.w  d0,a0
        move.l  s_fill_pattern(a6),d0
        bra     fill_road_four_span
.done:
        rts
geometry_single_edge:
        lea     s_projected(a6),a0
single_edge_find:
        lea     0(a0,d7.w),a1
        add.w   d6,d7
        andi.w  #15,d7
        lea     0(a0,d7.w),a2
        move.w  2(a2),d3
        cmp.w   280(a6),d3
        ble.s   single_edge_find
geometry_single_calculate:
        move.w  (a1),d0
        move.w  280(a6),d1
        sub.w   2(a1),d1
        beq.s   single_edge_vertex_pixel
        move.w  (a2),d2
        sub.w   d0,d2
        sub.w   2(a1),d3
        ; Start lies at most three rows above the sampled centre. Only the
        ; X at that centre is needed: do not form/store a four-row increment.
        ext.l   d2
        lsl.l   #8,d2
        divs.w  d3,d2
        bvs.s   single_edge_wide
        move.w  d2,d4
        ext.l   d4
        bra.s   single_edge_slope
single_edge_wide:
        asr.l   #8,d2
        divs.w  d3,d2
        move.w  d2,d4
        ext.l   d4
        lsl.l   #8,d4
        swap    d2
        ext.l   d2
        lsl.l   #8,d2
        divs.w  d3,d2
        ext.l   d2
        add.l   d2,d4
single_edge_slope:
        ext.l   d0
        lsl.l   #8,d0
        move.w  280(a6),d1
        sub.w   2(a1),d1
        beq.s   single_edge_pixel
        subq.w  #1,d1
single_edge_start:
        add.l   d4,d0
        dbra    d1,single_edge_start
single_edge_pixel:
        asr.l   #8,d0
single_edge_vertex_pixel:
        rts

; Four-vertex edge events wrap by a fixed mask. Near clipping keeps the
; original 3/5-vertex walker and exact wide arithmetic.
geometry_quad_edge:
.find:
        move.w  10(a4),d0
        move.w  d0,d1
        lea     s_projected(a6),a0
        lea     0(a0,d0.w),a1
        add.w   d6,d0
        andi.w  #15,d0
        move.w  d0,10(a4)
        lea     0(a0,d0.w),a2
        move.w  2(a2),d3
        cmp.w   280(a6),d3
        ble.s   .find
        move.w  d3,8(a4)
        move.w  (a1),d0
        move.w  (a2),d2
        sub.w   d0,d2
        sub.w   2(a1),d3
        bra     geometry_edge_math
