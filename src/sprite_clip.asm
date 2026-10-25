; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Clip ONCE per RLE run, never once per pixel group. The source end pointer
; advances over invisible groups without decoding them. No offscreen access.
; D6 selects opaque/masked records, D7 normal/white; A3 is the row base.
blit_rival:
        movea.l #frame_profile,a2
        tst.w   42(a2)
        beq.s   .normal_blit
        moveq   #0,d0
        bra     queue_clipped_overlay
.normal_blit:
        movem.l d7/a4-a5,-(sp)
        moveq   #0,d7
        bra.s   sprite_clip_start
blit_rival_white:
        movea.l #frame_profile,a2
        tst.w   42(a2)
        beq.s   .normal_blit
        moveq   #1,d0
        bra     queue_clipped_overlay
.normal_blit:
        movem.l d7/a4-a5,-(sp)
        moveq   #1,d7
sprite_clip_start:
        cmpi.w  #24,d2
        blt.s   .format_ready
        bset    #2,d7
.format_ready:
        move.w  s_sprite_y(a6),d5
        movea.l s_page(a6),a3
        move.w  d5,d0
        lsl.w   #7,d0
        adda.w  d0,a3
        subq.w  #1,d2
.row:
        movea.w #1,a4
        btst    #2,d7
        beq.s   .run
        movea.w (a1)+,a4
        movea.l a1,a5
        cmpa.w  #2,a4
        bne.s   .run
        cmpi.w  #24,d5
        blt.s   .pair_fallback
        cmpi.w  #223,d5
        blt.s   .run
.pair_fallback:
        movea.w #1,a4
        bset    #1,d7            ; process a HUD-crossing pair separately
.row_ready:
        ; Vertical visibility is constant for all runs of a row. Entire
        ; invisible rows advance through records without decoding pixels.
        cmpi.w  #24,d5
        blt     .skip_row
        cmpi.w  #224,d5
        bge     .skip_row
.run:
        move.w  (a1)+,d3
        bmi     .next_row
        move.w  s_sprite_x(a6),d4
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
        add.w   d4,d3            ; exclusive right, byte coordinates
        tst.w   d6
        beq.s   .source_end
        add.w   d0,d0
.source_end:
        lea     0(a1,d0.w),a2
        tst.w   d3
        ble     .skip
        cmpi.w  #128,d4
        bge     .skip
        tst.w   d4
        bpl.s   .left_ready
        suba.w  d4,a1          ; skip left-clipped source words
        tst.w   d6
        beq.s   .left_skip_done
        suba.w  d4,a1          ; masks double the source size
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
.skip_row:
        move.w  (a1)+,d3
        bmi.s   .next_row
        move.w  (a1)+,d1
        bpl.s   .skip_opaque
        neg.w   d1
        add.w   d1,d1
.skip_opaque:
        add.w   d1,d1
        adda.w  d1,a1
        bra.s   .skip_row
.next_row:
        addq.w  #1,d5
        adda.w  #128,a3
        subq.w  #1,s_render_poll(a6)
        subq.w  #1,d2
        cmpa.w  #2,a4
        bne.s   .clock
        addq.w  #1,d5
        adda.w  #128,a3
        subq.w  #1,s_render_poll(a6)
        subq.w  #1,d2
.clock:
        tst.w   s_render_poll(a6)
        bpl.s   .clock_done
        move.w  #3,s_render_poll(a6)
        bsr     poll_clock
.clock_done:
        tst.w   d2
        bmi.s   .done
        btst    #1,d7
        beq     .row
        bclr    #1,d7
        movea.l a5,a1
        bra     .row_ready
.done:
        move.w  d5,s_sprite_y(a6)
        movem.l (sp)+,d7/a4-a5
        rts
