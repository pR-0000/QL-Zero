; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Union of raw asphalt intervals, independently for each sampled row.
; Reuse 80 bytes of the dead projection cache for 40 word heads.
; Queue records become row offset.w, next offset.w, left.w, right.w.
; Sorted linked intervals preserve genuine gaps. Rail width depends on depth,
; never on a clipped segment chord, so shared caps cannot taper into points.
; All nodes are the existing 768-byte stack queue: no additional allocation.
draw_contour_rails:
        lea     s_projection_xy(a6),a3
        movea.l a3,a0
        moveq   #-1,d0
        rept 20
        move.l  d0,(a0)+
        endr
        movea.l s_contour_base(a6),a5
        movea.l a5,a4
        move.l  s_contour_next(a6),d7
        sub.l   a5,d7
        lsr.w   #3,d7
        subq.w  #1,d7
        bmi     .done
.record:
        ; Both QL pages are 32K aligned: their low 15 bits are row offset.
        move.w  2(a4),d4
        andi.w  #$7fff,d4
        move.w  d4,d0
        lsr.w   #6,d0             ; row head byte offset
        lea     0(a3,d0.w),a0     ; link to replace
        move.w  4(a4),d1
        move.w  6(a4),d2
        move.w  (a0),d5
.search:
        tst.w   d5
        bmi     .new
        lea     0(a5,d5.w),a1
        cmp.w   6(a1),d1
        ble.s   .found
        lea     2(a1),a0
        move.w  (a0),d5
        bra.s   .search
.found:
        cmp.w   4(a1),d2
        blt.s   .new
        ; Fully contained spans need neither MULU nor a new node.
        cmp.w   4(a1),d1
        blt.s   .extend
        cmp.w   6(a1),d2
        ble     .next_record
.extend:
        cmp.w   4(a1),d1
        bge.s   .extend_right
        move.w  d1,4(a1)
.extend_right:
        cmp.w   6(a1),d2
        ble.s   .consume
        move.w  d2,6(a1)
.consume:
        move.w  2(a1),d5
        bmi.s   .next_record
        lea     0(a5,d5.w),a0
        move.w  4(a0),d1
        cmp.w   6(a1),d1
        bgt.s   .next_record
        move.w  6(a0),d2
        cmp.w   6(a1),d2
        ble.s   .unlink
        move.w  d2,6(a1)
.unlink:
        move.w  2(a0),2(a1)
        bsr     contour_clock
        bra.s   .consume
.new:
        move.l  a4,d3
        sub.l   a5,d3
        move.w  d4,(a4)
        move.w  d5,2(a4)
        move.w  d3,(a0)
.next_record:
        addq.l  #8,a4
        subq.w  #1,s_render_poll(a6)
        bpl.s   .record_clock_done
        move.w  #3,s_render_poll(a6)
        bsr     poll_clock
.record_clock_done:
        dbra    d7,.record
        ; Paint exterior rails only. Neighbour endpoints also bound width:
        ; a narrow genuine gap must not paint across the other road branch.
        move.l  #$aaffaaff,d0
        moveq   #39,d7
.row:
        move.w  (a3)+,d1
        bmi     .next_row
        move.w  #-32768,d6
.component:
        lea     0(a5,d1.w),a4
        movea.l s_frame_budget(a6),a0
        adda.w  (a4),a0
        move.w  6(a4),d5
        move.w  4(a4),d2
        tst.w   d2
        bgt.s   .visible
        cmpi.w  #256,d5
        bge     .next_component
.visible:

        move.w  d6,(a4)
        ; Nominal 1.2-world-unit rail, perspective 72*x/z and y=224/z.
        ; One table read replaces one/two MULU and endpoint-width tracking.
        moveq   #39,d3
        sub.w   d7,d3
        add.w   d3,d3
        lea     contour_depth_widths(pc),a1
        move.w  0(a1,d3.w),d3
        move.w  d3,d6
        tst.w   d2
        ble.s   .right
        cmpi.w  #256,d2
        bge.s   .right
        move.w  d2,d1
        sub.w   d3,d1
        bpl.s   .left_nonnegative
        clr.w   d1
.left_nonnegative:
        cmp.w   (a4),d1
        bge.s   .left_ready
        move.w  (a4),d1
.left_ready:
        bsr     fill_rail_span
.right:
        move.w  d5,d1
        bmi.s   .next_component
        cmpi.w  #256,d1
        bge.s   .next_component
        move.w  d1,d2
        add.w   d6,d2
        cmpi.w  #256,d2
        ble.s   .right_viewport
        move.w  #256,d2
.right_viewport:
        move.w  2(a4),d3
        bmi.s   .right_ready
        lea     0(a5,d3.w),a1
        cmp.w   4(a1),d2
        ble.s   .right_ready
        move.w  4(a1),d2
.right_ready:
        bsr     fill_rail_span
.next_component:
        move.w  d5,d6
        subq.w  #1,s_render_poll(a6)
        bpl.s   .component_clock_done
        move.w  #3,s_render_poll(a6)
        bsr     poll_clock
.component_clock_done:
        move.w  2(a4),d1
        bpl     .component
.next_row:
        dbra    d7,.row
.done:
        rts
contour_depth_widths:
        dc.w 1,2,4,5,7,8,10,12
        dc.w 13,15,16,18,19,21,22,24
        dc.w 25,27,29,30,32,33,35,36
        dc.w 38,39,41,42,44,46,47,49
        dc.w 50,52,53,55,56,58,59,61
contour_clock:
        subq.w  #1,s_render_poll(a6)
        bpl.s   .poll_done
        move.w  #3,s_render_poll(a6)
        bra     poll_clock
.poll_done:
        rts
