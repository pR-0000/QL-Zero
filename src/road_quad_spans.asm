; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Stable-edge runs in groups of at most four sampled bands. Arithmetic and
; painter order match the original recurrence; clock polling stays bounded.
        move.w  d7,280(a6)
        move.w  d7,d0
        subq.w  #2,d0
        lsr.w   #2,d0
        lsl.w   #7,d0
        movea.l s_frame_budget(a6),a0
        adda.w  d0,a0
        move.w  s_max_y(a6),d1
        sub.w   d7,d1
        cmpi.w  #4,d1
        bls     .single_band
        move.l  4(a4),d5
        move.l  4(a5),d6
        movea.l (a4),a4
        movea.l (a5),a5
        bra.s   .run
.edges:
        move.l  a0,-(sp)
        move.w  280(a6),d7
        cmp.w   s_spans_left+8(a6),d7
        blt.s   .left_ready
        move.l  d6,-(sp)
        lea     s_spans_left(a6),a4
        moveq   #4,d6
        bsr     polygon_walk_edge
        move.l  4(a4),d5
        movea.l (a4),a4
        move.l  (sp)+,d6
.left_ready:
        cmp.w   s_spans_right+8(a6),d7
        blt.s   .right_ready
        exg     a4,a5
        lea     s_spans_right(a6),a4
        moveq   #-4,d6
        bsr     polygon_walk_edge
        move.l  4(a4),d6
        movea.l (a4),a4
        exg     a4,a5
.right_ready:
        movea.l (sp)+,a0
.run:
        move.w  s_max_y(a6),d7
        cmp.w   s_spans_left+8(a6),d7
        ble.s   .left_end
        move.w  s_spans_left+8(a6),d7
.left_end:
        cmp.w   s_spans_right+8(a6),d7
        ble.s   .right_end
        move.w  s_spans_right+8(a6),d7
.right_end:
        sub.w   280(a6),d7
        addq.w  #3,d7
        lsr.w   #2,d7
        move.w  d7,382(a6)
        move.l  s_fill_pattern(a6),d0
        lea     460(a6),a3
        move.w  280(a6),d3
        lsr.w   #2,d3
        adda.w  d3,a3
        tst.w   380(a6)
        bne     .interior_run
.clip_run:
        cmpi.w  #4,d7
        blo     .clip_tail
.clip_group:
        move.l  a4,d1
        swap    d1
        move.l  a5,d2
        swap    d2
        cmp.w   d1,d2
        bge.s   .ordered_clip0
        exg     d1,d2
.ordered_clip0:
        move.w  d1,s_contour_left(a6)
        move.w  d2,s_contour_right(a6)
        tst.w   d1
        bpl.s   .left_clip0
        clr.w   d1
.left_clip0:
        cmpi.w  #256,d2
        ble.s   .right_clip0
        move.w  #256,d2
.right_clip0:
        cmp.w   d1,d2
        ble.s   .step_clip0
        bsr     fill_road_four_span
.step_clip0:
        adda.w  #128,a0
        addq.l  #1,a3
        adda.l  d5,a4
        adda.l  d6,a5
        move.l  a4,d1
        swap    d1
        move.l  a5,d2
        swap    d2
        cmp.w   d1,d2
        bge.s   .ordered_clip1
        exg     d1,d2
.ordered_clip1:
        move.w  d1,s_contour_left(a6)
        move.w  d2,s_contour_right(a6)
        tst.w   d1
        bpl.s   .left_clip1
        clr.w   d1
.left_clip1:
        cmpi.w  #256,d2
        ble.s   .right_clip1
        move.w  #256,d2
.right_clip1:
        cmp.w   d1,d2
        ble.s   .step_clip1
        bsr     fill_road_four_span
.step_clip1:
        adda.w  #128,a0
        addq.l  #1,a3
        adda.l  d5,a4
        adda.l  d6,a5
        move.l  a4,d1
        swap    d1
        move.l  a5,d2
        swap    d2
        cmp.w   d1,d2
        bge.s   .ordered_clip2
        exg     d1,d2
.ordered_clip2:
        move.w  d1,s_contour_left(a6)
        move.w  d2,s_contour_right(a6)
        tst.w   d1
        bpl.s   .left_clip2
        clr.w   d1
.left_clip2:
        cmpi.w  #256,d2
        ble.s   .right_clip2
        move.w  #256,d2
.right_clip2:
        cmp.w   d1,d2
        ble.s   .step_clip2
        bsr     fill_road_four_span
.step_clip2:
        adda.w  #128,a0
        addq.l  #1,a3
        adda.l  d5,a4
        adda.l  d6,a5
        move.l  a4,d1
        swap    d1
        move.l  a5,d2
        swap    d2
        cmp.w   d1,d2
        bge.s   .ordered_clip3
        exg     d1,d2
.ordered_clip3:
        move.w  d1,s_contour_left(a6)
        move.w  d2,s_contour_right(a6)
        tst.w   d1
        bpl.s   .left_clip3
        clr.w   d1
.left_clip3:
        cmpi.w  #256,d2
        ble.s   .right_clip3
        move.w  #256,d2
.right_clip3:
        cmp.w   d1,d2
        ble.s   .step_clip3
        bsr     fill_road_four_span
.step_clip3:
        adda.w  #128,a0
        addq.l  #1,a3
        adda.l  d5,a4
        adda.l  d6,a5
        subq.w  #4,d7
        beq     .end_run
        bsr     poll_clock
        cmpi.w  #4,d7
        bhs     .clip_group
.clip_tail:
        subq.w  #1,d7
.clip_single:
        move.l  a4,d1
        swap    d1
        move.l  a5,d2
        swap    d2
        cmp.w   d1,d2
        bge.s   .ordered_cliptail
        exg     d1,d2
.ordered_cliptail:
        move.w  d1,s_contour_left(a6)
        move.w  d2,s_contour_right(a6)
        tst.w   d1
        bpl.s   .left_cliptail
        clr.w   d1
.left_cliptail:
        cmpi.w  #256,d2
        ble.s   .right_cliptail
        move.w  #256,d2
.right_cliptail:
        cmp.w   d1,d2
        ble.s   .step_cliptail
        bsr     fill_road_four_span
.step_cliptail:
        adda.w  #128,a0
        addq.l  #1,a3
        adda.l  d5,a4
        adda.l  d6,a5
        dbra    d7,.clip_single
        bra     .end_run
.interior_run:
        cmpi.w  #4,d7
        blo     .interior_tail
.interior_group:
        move.l  a4,d1
        swap    d1
        move.l  a5,d2
        swap    d2
        cmp.w   d1,d2
        bge.s   .ordered_interior0
        exg     d1,d2
.ordered_interior0:
        move.w  d1,s_contour_left(a6)
        move.w  d2,s_contour_right(a6)
        cmp.w   d1,d2
        ble.s   .step_interior0
        bsr     fill_road_four_span
.step_interior0:
        adda.w  #128,a0
        addq.l  #1,a3
        adda.l  d5,a4
        adda.l  d6,a5
        move.l  a4,d1
        swap    d1
        move.l  a5,d2
        swap    d2
        cmp.w   d1,d2
        bge.s   .ordered_interior1
        exg     d1,d2
.ordered_interior1:
        move.w  d1,s_contour_left(a6)
        move.w  d2,s_contour_right(a6)
        cmp.w   d1,d2
        ble.s   .step_interior1
        bsr     fill_road_four_span
.step_interior1:
        adda.w  #128,a0
        addq.l  #1,a3
        adda.l  d5,a4
        adda.l  d6,a5
        move.l  a4,d1
        swap    d1
        move.l  a5,d2
        swap    d2
        cmp.w   d1,d2
        bge.s   .ordered_interior2
        exg     d1,d2
.ordered_interior2:
        move.w  d1,s_contour_left(a6)
        move.w  d2,s_contour_right(a6)
        cmp.w   d1,d2
        ble.s   .step_interior2
        bsr     fill_road_four_span
.step_interior2:
        adda.w  #128,a0
        addq.l  #1,a3
        adda.l  d5,a4
        adda.l  d6,a5
        move.l  a4,d1
        swap    d1
        move.l  a5,d2
        swap    d2
        cmp.w   d1,d2
        bge.s   .ordered_interior3
        exg     d1,d2
.ordered_interior3:
        move.w  d1,s_contour_left(a6)
        move.w  d2,s_contour_right(a6)
        cmp.w   d1,d2
        ble.s   .step_interior3
        bsr     fill_road_four_span
.step_interior3:
        adda.w  #128,a0
        addq.l  #1,a3
        adda.l  d5,a4
        adda.l  d6,a5
        subq.w  #4,d7
        beq     .end_run
        bsr     poll_clock
        cmpi.w  #4,d7
        bhs     .interior_group
.interior_tail:
        subq.w  #1,d7
.interior_single:
        move.l  a4,d1
        swap    d1
        move.l  a5,d2
        swap    d2
        cmp.w   d1,d2
        bge.s   .ordered_interiortail
        exg     d1,d2
.ordered_interiortail:
        move.w  d1,s_contour_left(a6)
        move.w  d2,s_contour_right(a6)
        cmp.w   d1,d2
        ble.s   .step_interiortail
        bsr     fill_road_four_span
.step_interiortail:
        adda.w  #128,a0
        addq.l  #1,a3
        adda.l  d5,a4
        adda.l  d6,a5
        dbra    d7,.interior_single
.end_run:
        move.w  382(a6),d7
        lsl.w   #2,d7
        add.w   d7,280(a6)
        move.w  280(a6),d7
        cmp.w   s_max_y(a6),d7
        bge.s   .done
        bsr     poll_clock
        bra     .edges
.done:
        rts
.single_band:
        move.w  (a4),d1
        move.w  (a5),d2
        cmp.w   d1,d2
        bge.s   .single_ordered
        exg     d1,d2
.single_ordered:
        move.w  d1,s_contour_left(a6)
        move.w  d2,s_contour_right(a6)
        tst.w   d1
        bpl.s   .single_left
        clr.w   d1
.single_left:
        cmpi.w  #256,d2
        ble.s   .single_right
        move.w  #256,d2
.single_right:
        cmp.w   d1,d2
        ble.s   .single_done
        move.l  s_fill_pattern(a6),d0
        lea     460(a6),a3
        move.w  280(a6),d3
        lsr.w   #2,d3
        adda.w  d3,a3
        bsr     fill_road_four_span
.single_done:
        rts
