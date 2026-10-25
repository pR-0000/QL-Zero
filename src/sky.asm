; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; No sky bitmap buffer. Cache-independent geometry remains identical.
select_sky_dirty:
        lea     s_sky_dirty0(a6),a4
        cmpi.l  #$20000,s_page(a6)
        beq.s   .done
        lea     s_sky_dirty1(a6),a4
.done:
        rts

; A far sprite can only cross the bottom eight sky rows: every building is
; at least eight rows high, so the underlying pixels are uniformly magenta.

restore_sky_sprites:
        bsr.s   select_sky_dirty
        move.w  (a4),d1
        cmp.w   2(a4),d1
        bge.s   .reset
        move.w  4(a4),d7
        movea.l s_page(a6),a0
        move.w  d7,d0
        lsl.w   #7,d0
        adda.w  d0,a0
        movem.l a4-a5,-(sp)
        bsr     sky_horizon_cache
        move.w  (a4),d0
        movem.l (sp)+,a4-a5
        sub.w   d7,d0
        move.w  d0,d7
        subq.w  #1,d7
        bmi.s   .reset
.row:
        move.w  (a4),d1
        add.w   d1,d1
        move.w  2(a4),d2
        add.w   d2,d2
        move.l  cup_city_color-state(a6),d0
        bsr     fill_road_span
        adda.w  #128,a0
        dbra    d7,.row
        bsr     poll_clock
.reset:
        move.l  #$00800000,(a4)
        clr.w   4(a4)
        rts

; D4 byte left, D3 byte width, D5 top. A5 and all caller data registers survive.
mark_sky_sprite:
        cmp.w   s_view_horizon(a6),d5
        bge.s   .done
        movem.l d0-d2/a4,-(sp)
        move.w  d4,d0
        move.w  d4,d1
        add.w   d3,d1
        tst.w   d0
        bpl.s   .left
        clr.w   d0
.left:
        cmpi.w  #128,d1
        ble.s   .right
        move.w  #128,d1
.right:
        cmp.w   d0,d1
        ble.s   .restore
        bsr     select_sky_dirty
        cmp.w   (a4),d0
        bge.s   .keep_left
        move.w  d0,(a4)
.keep_left:
        cmp.w   2(a4),d1
        ble.s   .keep_right
        move.w  d1,2(a4)
.keep_right:
        move.w  d5,d0
        move.w  s_view_horizon(a6),d1
        subq.w  #8,d1
        cmp.w   d1,d0
        bge.s   .top
        move.w  d1,d0
.top:
        move.w  4(a4),d1
        beq.s   .set_top
        cmp.w   d1,d0
        bge.s   .restore
.set_top:
        move.w  d0,4(a4)
.restore:
        movem.l (sp)+,d0-d2/a4
.done:
        rts

; Exact interval differences of old/new city columns. Old sky outside these
; intervals already contains the desired cyan/magenta pixels. Ground below
; the new horizon is overwritten later by the floor renderer.
update_sky_columns:
        movem.l a4-a5,-(sp)
        move.w  (a4),d2
        move.w  s_view_horizon(a6),d3
        move.w  2(a5),d4
        move.w  s_angle(a6),d5
        lsr.w   #2,d5
        andi.w  #31,d5
        movea.l #city_heights,a2
        moveq   #0,d6            ; column byte offset
        moveq   #31,d7
.column:
        moveq   #0,d0
        move.b  0(a2,d4.w),d0
        move.w  d2,a3
        suba.w  d0,a3            ; old top, positive
        moveq   #0,d0
        move.b  0(a2,d5.w),d0
        move.w  d3,a4
        suba.w  d0,a4            ; new top
        move.w  a3,d0
        move.w  a4,d1
        cmp.w   d0,d1
        ble.s   .no_clear
        move.l  cup_sky_color-state(a6),a5
        bsr     themed_sky_segment
.no_clear:
        move.w  a4,d0
        move.w  a3,d1
        cmp.w   d0,d1
        ble.s   .no_upper_fill
        cmp.w   d3,d1
        ble.s   .upper_end
        move.w  d3,d1
.upper_end:
        move.l  cup_city_color-state(a6),a5
        bsr     sky_column_segment
.no_upper_fill:
        cmp.w   d2,d3
        ble.s   .next
        move.w  a4,d0
        cmp.w   d2,d0
        bge.s   .bottom_start
        move.w  d2,d0
.bottom_start:
        move.w  d3,d1
        move.l  cup_city_color-state(a6),a5
        bsr     sky_column_segment
.next:
        addq.w  #1,d4
        andi.w  #31,d4
        addq.w  #1,d5
        andi.w  #31,d5
        addq.w  #4,d6
        move.w  d7,d0
        andi.w  #3,d0
        bne.s   .clock_done
        bsr     poll_clock
.clock_done:
        dbra    d7,.column
        movem.l (sp)+,a4-a5
        rts

sky_column_segment:
        sub.w   d0,d1
        ble     .done
        movea.l s_page(a6),a0
        lsl.w   #7,d0
        adda.w  d0,a0
        adda.w  d6,a0
        ; Computed entry into 96 stores: no per-row loop/address arithmetic.
        ; Horizon <=120 and top >=24, so this interval always fits.
        move.w  d1,d0
        lsl.w   #7,d0
        adda.w  d0,a0
        neg.w   d1
        add.w   d1,d1
        add.w   d1,d1
        lea     .unrolled_end(pc),a1
        jmp     0(a1,d1.w)
        include "data/sky_stores.inc"
.unrolled_end:
        rts
.done:
        rts
