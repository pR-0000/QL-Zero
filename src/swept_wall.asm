; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; D1/D2 destination, A1 original X/Y pair. D0=1 for any non-asphalt traversed.
; Same-cell movement is free of extra map reads. Boundary traversal uses
; integer cross-products, not divisions. A corner tests both neighbouring
; cells before the diagonal. Preserve candidate/flags and every other register.
trace_wall:
        move.w  (a1),d0
        eor.w   d1,d0
        andi.w  #$ff00,d0
        bne.s   .walk
        move.w  2(a1),d0
        eor.w   d2,d0
        andi.w  #$ff00,d0
        beq     .clear
.walk:
        movem.l d1-d7/a0-a2,-(sp)
        lea     -16(sp),sp
        movea.l sp,a2
        move.w  (a1),d3
        move.w  2(a1),d4
        sub.w   d3,d1
        sub.w   d4,d2
        move.w  #1,4(a2)
        move.w  #128,6(a2)
        move.w  d3,d5
        andi.w  #255,d5
        tst.w   d1
        bmi.s   .left
        neg.w   d5
        addi.w  #256,d5
        bra.s   .x_ready
.left:
        neg.w   d1
        neg.w   4(a2)
.x_ready:
        move.w  d5,8(a2)
        move.w  d1,12(a2)
        move.w  d4,d5
        andi.w  #255,d5
        tst.w   d2
        bmi.s   .up
        neg.w   d5
        addi.w  #256,d5
        bra.s   .y_ready
.up:
        neg.w   d2
        neg.w   6(a2)
.y_ready:
        move.w  d5,10(a2)
        move.w  d2,14(a2)
        lsr.w   #8,d3
        lsr.w   #8,d4
        move.w  d4,d7
        lsl.w   #7,d7
        or.w    d3,d7
        ; Saved D1/D2 above the local words are the actual destination.
        move.w  18(sp),d0
        lsr.w   #8,d0
        sub.w   d3,d0
        bpl.s   .count_x
        neg.w   d0
.count_x:
        move.w  d0,(a2)
        move.w  22(sp),d0
        lsr.w   #8,d0
        sub.w   d4,d0
        bpl.s   .count_y
        neg.w   d0
.count_y:
        move.w  d0,2(a2)
.next:
        tst.w   (a2)
        beq.s   .only_y
        tst.w   2(a2)
        beq.s   .step_x
        move.w  8(a2),d0
        mulu.w  14(a2),d0
        move.w  10(a2),d6
        mulu.w  12(a2),d6
        cmp.l   d6,d0
        blo.s   .step_x
        bhi.s   .step_y
        ; Exact corner contact: either adjacent solid cell blocks motion.
        move.w  d7,d4
        add.w   4(a2),d4
        bsr.s   .cell
        bne.s   .blocked
        move.w  d7,d4
        add.w   6(a2),d4
        bsr.s   .cell
        bne.s   .blocked
        add.w   4(a2),d7
        subq.w  #1,(a2)
        addi.w  #256,8(a2)
        bra.s   .step_y
.only_y:
        tst.w   2(a2)
        beq.s   .passed
.step_y:
        add.w   6(a2),d7
        subq.w  #1,2(a2)
        addi.w  #256,10(a2)
        bra.s   .test
.step_x:
        add.w   4(a2),d7
        subq.w  #1,(a2)
        addi.w  #256,8(a2)
.test:
        move.w  d7,d4
        bsr.s   .cell
        beq.s   .next
.blocked:
        moveq   #1,d0
        bra.s   .restore
.passed:
        moveq   #0,d0
.restore:
        lea     16(sp),sp
        movem.l (sp)+,d1-d7/a0-a2
        rts
.cell:
        bsr     map_sample_flags
        andi.w  #40,d3
        cmpi.w  #8,d3           ; also close diagonal holes without rail cells
        rts
.clear:
        moveq   #0,d0
        rts
