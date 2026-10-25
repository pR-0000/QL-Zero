; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0

; while projecting ships and preparing cached messages. Publish four final
; rows at a time; only bands touched by sprites need the 512-byte work tile.
scene_records       equ 5120
scene_stride        equ 176
scene_tile          equ 6176
scene_message       equ 6688
scene_heap_size     equ 6688

prepare_scene_overlays:
        movea.l #frame_profile,a0
        cmpi.w  #-1,36(a0)
        bne.s   .maps_ready
        movea.l s_frame_budget(a6),a0
        adda.w  #scene_records,a0
        moveq   #5,d0
.invalidate:
        clr.l   8(a0)
        adda.w  #scene_stride,a0
        dbra    d0,.invalidate
.maps_ready:
        movea.l #frame_profile+44,a0
        moveq   #12,d0
.clear_bands:
        clr.l   (a0)+
        dbra    d0,.clear_bands
        movea.l s_frame_budget(a6),a0
        move.l  s_sky_dirty0(a6),scene_tile(a0)
        move.w  s_sky_dirty0+4(a6),scene_tile+4(a0)
        move.l  #$00800000,s_sky_dirty0(a6)
        clr.w   s_sky_dirty0+4(a6)
        movea.l #frame_profile,a0
        clr.w   34(a0)
        move.w  #1,42(a0)
        bsr     draw_rivals
        bsr     cup_draw_ghost
        bsr     draw_ship
        movea.l #frame_profile,a0
        clr.w   42(a0)
        clr.w   36(a0)
        clr.w   40(a0)
.background:
        ; Restore only last frame's sky damage. Retain this frame's marks
        ; for the next frame, including ships crossing the city silhouette.
        movea.l s_frame_budget(a6),a0
        move.l  s_sky_dirty0(a6),scene_tile+8(a0)
        move.w  s_sky_dirty0+4(a6),scene_tile+12(a0)
        move.l  scene_tile(a0),s_sky_dirty0(a6)
        move.w  scene_tile+4(a0),s_sky_dirty0+4(a6)
        bsr     prepare_background
        movea.l s_frame_budget(a6),a0
        move.l  scene_tile+8(a0),s_sky_dirty0(a6)
        move.w  scene_tile+12(a0),s_sky_dirty0+4(a6)
        rts

queue_player_overlay:
        movem.l d0-d7/a0-a5,-(sp)
        move.l  a0,d3
        sub.l   s_page(a6),d3
        move.w  d3,d4
        andi.w  #127,d3
        lsr.w   #7,d4
        addq.w  #1,d2
        bset    #2,d0          ; wholly visible: omit horizontal run clipping
        bra.s   queue_overlay_rows
queue_clipped_overlay:
        movem.l d0-d7/a0-a5,-(sp)
        move.w  s_sprite_x(a6),d3
        move.w  s_sprite_y(a6),d4
queue_overlay_rows:
        movea.l #frame_profile,a0
        cmpi.w  #6,34(a0)
        bhs.s   .done
        move.w  34(a0),d1
        addq.w  #1,34(a0)
        mulu.w  #scene_stride,d1
        movea.l s_frame_budget(a6),a2
        adda.w  #scene_records,a2
        adda.w  d1,a2
        move.w  d3,(a2)
        move.w  d4,2(a2)
        move.w  d2,4(a2)
        move.w  d0,6(a2)
        bsr     scene_mark_bands
        cmpa.l  8(a2),a1
        beq.s   .done         ; unchanged asset: reuse its decoded row index
        move.l  a1,8(a2)
        lea     16(a2),a2
        moveq   #0,d7
        cmpi.w  #24,d2
        blt.s   .row
        moveq   #1,d7
.row:
        moveq   #1,d6
        tst.w   d7
        beq.s   .row_ready
        move.w  (a1)+,d6
.row_ready:
        movea.l a1,a3
.run:
        move.w  (a1)+,d1
        bmi.s   .row_end
        move.w  (a1)+,d1
        bpl.s   .opaque
        neg.w   d1
        add.w   d1,d1
.opaque:
        add.w   d1,d1
        adda.w  d1,a1
        bra.s   .run
.row_end:
        sub.w   d6,d2
        subq.w  #1,d6
.repeat:
        move.l  a3,(a2)+
        dbra    d6,.repeat
        tst.w   d2
        bgt.s   .row
.done:
        movem.l (sp)+,d0-d7/a0-a5
        rts

queue_fire_overlay:
        movem.l d0-d7/a0-a5,-(sp)
        movea.l #frame_profile,a2
        move.w  34(a2),d1
        addq.w  #1,34(a2)
        mulu.w  #scene_stride,d1
        movea.l s_frame_budget(a6),a2
        adda.w  #scene_records,a2
        adda.w  d1,a2
        move.l  a0,d0
        sub.l   s_page(a6),d0
        move.w  d0,d1
        andi.w  #127,d0
        lsr.w   #7,d1
        move.w  d0,(a2)
        move.w  d1,2(a2)
        move.w  #40,4(a2)
        move.w  #2,6(a2)
        bsr     scene_mark_bands
        cmpa.l  8(a2),a1
        beq.s   .done
        move.l  a1,8(a2)
        lea     16(a2),a2
        moveq   #39,d2
.row:
        move.l  a1,(a2)+
        addq.l  #1,a1
        moveq   #0,d0
        move.b  (a1)+,d0
        adda.w  d0,a1
        dbra    d2,.row
.done:
        movem.l (sp)+,d0-d7/a0-a5
        rts

scene_mark_bands:
        movea.l #frame_profile,a0
        move.w  34(a0),d5
        subq.w  #1,d5
        move.w  2(a2),d0
        move.w  d0,d1
        add.w   4(a2),d1
        subq.w  #1,d1
        asr.w   #2,d0
        asr.w   #2,d1
        cmpi.w  #6,d0
        bge.s   .top
        moveq   #6,d0
.top:
        cmpi.w  #55,d1
        ble.s   .end
        moveq   #55,d1
.end:
        lea     38(a0),a0
.mark:
        cmp.w   d1,d0
        bgt.s   .done
        bset    d5,0(a0,d0.w)
        addq.w  #1,d0
        bra.s   .mark
.done:
        rts

present_composite_scene:
        move.w  s_view_horizon(a6),d7
        movea.l #frame_profile,a0
        move.w  34(a0),d2
        subq.w  #1,d2
        bmi.s   .objects_checked
        movea.l s_frame_budget(a6),a1
        adda.w  #scene_records,a1
.minimum:
        move.w  2(a1),d0
        cmp.w   d7,d0
        bge.s   .min_next
        move.w  d0,d7
.min_next:
        adda.w  #scene_stride,a1
        dbra    d2,.minimum
.objects_checked:
        tst.w   40(a0)
        beq.s   .min_ready
        move.w  38(a0),d0
        cmp.w   d7,d0
        bge.s   .min_ready
        move.w  d0,d7
.min_ready:
        cmpi.w  #24,d7
        bge.s   .align
        moveq   #24,d7
.align:
        andi.w  #-4,d7
.band:
        movea.l #frame_profile,a0
.objects:
        move.w  d7,d0
        lsr.w   #2,d0
        lea     38(a0),a0
        tst.b   0(a0,d0.w)
        bne.s   .tile
        cmp.w   s_view_horizon(a6),d7
        blt     .next          ; prepared sky already correct
        bsr     scene_road_sample
        bsr     scene_screen_band
        bsr     scene_repeat_128
        bra     .next
.tile:
        bsr     scene_screen_band
        movea.l a0,a1
        movea.l s_frame_budget(a6),a0
        adda.w  #scene_tile,a0
        cmp.w   s_view_horizon(a6),d7
        bge.s   .road_tile
        bsr     scene_copy_512  ; restored city/sky as the tile background
        bra.s   .draw_tile
.road_tile:
        bsr     scene_road_sample
        bsr     scene_repeat_128
.draw_tile:
        movea.l s_frame_budget(a6),a0
        adda.w  #scene_tile,a0
        bsr     compose_overlay_band
        movea.l s_frame_budget(a6),a1
        adda.w  #scene_tile,a1
        bsr     scene_screen_band
        bsr     scene_copy_512
.next:
        bsr     poll_clock
        addq.w  #4,d7
        cmpi.w  #224,d7
        blt     .band
        rts

scene_screen_band:
        movea.l s_page(a6),a0
        move.w  d7,d0
        lsl.w   #7,d0
        adda.w  d0,a0
        rts
scene_road_sample:
        move.w  d7,d0
        sub.w   s_view_horizon(a6),d0
        lsl.w   #5,d0
        movea.l s_frame_budget(a6),a1
        adda.w  d0,a1
        rts
scene_copy_512:
        move.w  d7,-(sp)
        moveq   #15,d7
.chunk:
        movem.l (a1)+,d0-d5/a2-a3
        movem.l d0-d5/a2-a3,(a0)
        adda.w  #32,a0
        dbra    d7,.chunk
        move.w  (sp)+,d7
        rts
scene_repeat_128:
        move.w  d7,-(sp)
        moveq   #3,d7
.chunk:
        movem.l (a1)+,d0-d5/a2-a3
        movem.l d0-d5/a2-a3,0(a0)
        movem.l d0-d5/a2-a3,128(a0)
        movem.l d0-d5/a2-a3,256(a0)
        movem.l d0-d5/a2-a3,384(a0)
        adda.w  #32,a0
        dbra    d7,.chunk
        move.w  (sp)+,d7
        rts

compose_overlay_band:
        movem.l d7/a4-a5,-(sp)
        move.w  d7,-(sp)
        move.l  a0,-(sp)        ; tile base, then first band Y
        movea.l #frame_profile,a0
        move.w  34(a0),d2
        subq.w  #1,d2
        movea.l s_frame_budget(a6),a5
        adda.w  #scene_records,a5
.object:
        move.w  2(a5),d5
        move.w  d5,d1
        add.w   4(a5),d1
        move.w  4(sp),d0
        cmp.w   d0,d5
        bge.s   .top_ready
        move.w  d0,d5
.top_ready:
        addq.w  #4,d0
        cmp.w   d0,d1
        ble.s   .end_ready
        move.w  d0,d1
.end_ready:
        cmp.w   d1,d5
        bge     .next
        move.w  d1,-(sp)       ; exclusive end Y
        move.w  d5,d0
        sub.w   6(sp),d0
        lsl.w   #7,d0
        movea.l 2(sp),a3
        adda.w  d0,a3
.row:
        move.w  d5,d0
        sub.w   2(a5),d0
        lsl.w   #2,d0
        movea.l 16(a5,d0.w),a1
        move.w  6(a5),d7
        movea.w #1,a4
        btst    #1,d7
        bne     .fire
        move.w  d5,d1
        addq.w  #1,d1
        cmp.w   (sp),d1
        bge.s   .single_row
        cmpa.l  20(a5,d0.w),a1
        bne.s   .single_row
        movea.w #2,a4         ; decode identical adjacent rows just once
.single_row:
        btst    #2,d7
        beq.s   .run
.full_run:
        move.w  (a1)+,d3
        bmi     .row_done
        add.w   (a5),d3
        lea     0(a3,d3.w),a0
        move.w  (a1)+,d1
        moveq   #0,d6
        tst.w   d1
        bpl.s   .full_count
        neg.w   d1
        moveq   #1,d6
.full_count:
        bsr     sprite_run_copy
        bra.s   .full_run
.run:
        move.w  (a1)+,d3
        bmi     .row_done
        move.w  (a5),d4
        add.w   d3,d4
        move.w  (a1)+,d1
        moveq   #0,d6
        tst.w   d1
        bpl.s   .count
        neg.w   d1
        moveq   #1,d6
.count:
        move.w  d1,d0
        add.w   d0,d0
        move.w  d0,d3
        add.w   d4,d3
        tst.w   d6
        beq.s   .source_end
        add.w   d0,d0
.source_end:
        lea     0(a1,d0.w),a2
        tst.w   d3
        ble.s   .skip
        cmpi.w  #128,d4
        bge.s   .skip
        tst.w   d4
        bpl.s   .left_ready
        suba.w  d4,a1
        tst.w   d6
        beq.s   .left_skip_done
        suba.w  d4,a1
.left_skip_done:
        clr.w   d4
.left_ready:
        cmpi.w  #128,d3
        ble.s   .right_ready
        move.w  #128,d3
.right_ready:
        sub.w   d4,d3
        lsr.w   #1,d3
        move.w  d3,d1
        lea     0(a3,d4.w),a0
        bsr     sprite_run_copy
.skip:
        movea.l a2,a1
        bra     .run
.fire:
        moveq   #0,d0
        move.b  (a1)+,d0
        add.w   (a5),d0
        lea     0(a3,d0.w),a0
        moveq   #0,d1
        move.b  (a1)+,d1
        beq.s   .row_done
        subq.w  #1,d1
        lea     fire_decode(pc),a2
.fire_word:
        moveq   #0,d0
        move.b  (a1)+,d0
        bsr     cup_fire_word
        move.w  d3,(a0)+
        dbra    d1,.fire_word
.row_done:
        add.w   a4,d5
        adda.w  #128,a3
        cmpa.w  #2,a4
        bne.s   .row_advanced
        adda.w  #128,a3
.row_advanced:
        cmp.w   (sp),d5
        blt     .row
        addq.l  #2,sp
.next:
        adda.w  #scene_stride,a5
        dbra    d2,.object
        addq.l  #6,sp
        movem.l (sp)+,d7/a4-a5
        rts
