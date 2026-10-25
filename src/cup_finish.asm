; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Only the active cup uses these helpers. No per-frame allocation/resources.
cup_line_reset:
        movem.l d0-d7/a0-a1,-(sp)
        movea.l a6,a0
        adda.l  #track_buffer-state+track_path_offset,a0
        move.w  4(a0),d0
        sub.w   (a0),d0
        move.w  6(a0),d1
        sub.w   2(a0),d1
        movea.l a6,a1
        adda.l  #track_buffer-state+track_marker_offset,a1
        move.w  8(a1),d2
        sub.w   4(a1),d2        ; normal to the actual drawn finish stripe
        move.w  2(a1),d3
        sub.w   6(a1),d3
        move.w  d2,cup_line_dx-state(a6)
        move.w  d3,cup_line_dy-state(a6)
        muls.w  d0,d2
        muls.w  d1,d3
        add.l   d3,d2
        bpl.s   .forward
        neg.w   cup_line_dx-state(a6)
        neg.w   cup_line_dy-state(a6)
.forward:
        moveq   #0,d7
        move.w  s_x(a6),d1
        move.w  s_y(a6),d2
        bsr     cup_line_cross
        moveq   #1,d7
        lea     s_rivals(a6),a1
        move.w  4(a1),d1
        move.w  6(a1),d2
        bsr     cup_line_cross
        moveq   #2,d7
        move.w  20(a1),d1
        move.w  22(a1),d2
        bsr     cup_line_cross
        movem.l (sp)+,d0-d7/a0-a1
        rts

; D7 pilot, D1/D2 current 8.8 position. D0=1 only on forward line crossing.
; Update signed long side even outside the old gate box, avoiding early laps.
cup_line_cross:
        movem.l d1-d4/a0,-(sp)
        movea.l a6,a0
        adda.l  #track_buffer-state+track_path_offset,a0
        sub.w   (a0),d1
        sub.w   2(a0),d2
        muls.w  cup_line_dx-state(a6),d1
        muls.w  cup_line_dy-state(a6),d2
        add.l   d2,d1
        move.w  d7,d3
        lsl.w   #2,d3
        lea     cup_line_sides(pc),a0
        move.l  0(a0,d3.w),d4
        move.l  d1,0(a0,d3.w)
        moveq   #0,d0
        tst.l   d4
        bpl.s   .done
        tst.l   d1
        bmi.s   .done
        moveq   #1,d0
.done:
        movem.l (sp)+,d1-d4/a0
        rts

; Normalize only invalid ranks: keep unique valid arrivals, fill missing slots.
; Fixed bounds for both loops. Normal results are left exactly unchanged.
cup_repair_places:
        movem.l d0-d5/a0,-(sp)
        lea     cup_places(pc),a0
        moveq   #0,d3
        moveq   #0,d4
.validate:
        move.w  0(a0,d4.w),d0
        cmpi.w  #1,d0
        blo.s   .invalid
        cmpi.w  #3,d0
        bhi.s   .invalid
        btst    d0,d3
        bne.s   .invalid
        bset    d0,d3
        bra.s   .next
.invalid:
        clr.w   0(a0,d4.w)
.next:
        addq.w  #2,d4
        cmpi.w  #6,d4
        blo.s   .validate
        moveq   #0,d4
.fill:
        tst.w   0(a0,d4.w)
        bne.s   .filled
        moveq   #1,d0
.free:
        btst    d0,d3
        beq.s   .assign
        addq.w  #1,d0
        cmpi.w  #3,d0
        bls.s   .free
.assign:
        move.w  d0,0(a0,d4.w)
        bset    d0,d3
.filled:
        addq.w  #2,d4
        cmpi.w  #6,d4
        blo.s   .fill
        move.w  #3,cup_finish_count-state(a6)
        movem.l (sp)+,d0-d5/a0
        rts

 ; Five-and-a-half-second cinematic: centerline interpolation is independent
; of racing inertia and walls. Camera yaw never changes the craft heading.
cup_finish_init:
        bsr     player_find_section
        move.w  s_player_section(a6),d0
        lsl.w   #8,d0
        addi.w  #32,d0
        move.w  d0,cup_finish_path-state(a6)
        move.w  s_angle(a6),cup_finish_heading-state(a6)
        clr.w   s_steer(a6)
        clr.w   s_controls(a6)
        clr.w   s_hit_ticks(a6)
        rts

cup_physics_tick:
        bsr     cup_ghost_tick
        bsr     cup_combat_tick
        tst.w   cup_finishing-state(a6)
        bne.s   .finish
        move.w  s_controls(a6),-(sp)
        bsr     cup_attack_controls
        bsr     physics_tick
        move.w  (sp)+,s_controls(a6)
        bra     cup_record_speed
.finish:
        movem.l d0-d7/a0-a2,-(sp)
        move.w  s_x(a6),d6
        move.w  s_y(a6),d7
        addi.w  #12,cup_finish_path-state(a6)
        andi.w  #$3fff,cup_finish_path-state(a6)
        move.w  cup_finish_path-state(a6),d3
        lsr.w   #8,d3
        move.w  d3,s_player_section(a6)
        movea.l a6,a0
        adda.l  #track_buffer-state+track_path_offset,a0
        move.w  d3,d0
        lsl.w   #2,d0
        lea     0(a0,d0.w),a1
        addq.w  #1,d3
        andi.w  #63,d3
        lsl.w   #2,d3
        move.w  0(a0,d3.w),d4
        sub.w   (a1),d4
        move.w  2(a0,d3.w),d5
        sub.w   2(a1),d5
        move.w  d4,d0
        move.w  d5,d1
        bsr     vector_angle
        sub.w   cup_finish_heading-state(a6),d0
        addi.w  #128,d0
        andi.w  #255,d0
        subi.w  #128,d0
        cmpi.w  #2,d0
        ble.s   .negative_turn
        moveq   #2,d0
.negative_turn:
        cmpi.w  #-2,d0
        bge.s   .heading_ready
        moveq   #-2,d0
.heading_ready:
        add.w   cup_finish_heading-state(a6),d0
        andi.w  #255,d0
        move.w  d0,cup_finish_heading-state(a6)
        move.w  cup_finish_path-state(a6),d2
        andi.w  #255,d2
        muls.w  d2,d4
        asr.l   #8,d4
        add.w   (a1),d4
        move.w  d4,s_x(a6)
        sub.w   d6,d4
        move.w  d4,s_vx(a6)
        muls.w  d2,d5
        asr.l   #8,d5
        add.w   2(a1),d5
        move.w  d5,s_y(a6)
        sub.w   d7,d5
        move.w  d5,s_vy(a6)
        moveq   #0,d0
        move.w  #275,d0
        sub.w   cup_finish_ticks-state(a6),d0
        lsl.l   #8,d0
        divu.w  #275,d0
        add.w   cup_finish_heading-state(a6),d0
        andi.w  #255,d0
        move.w  d0,s_angle(a6)
        move.w  s_ticks(a6),d0
        andi.w  #7,d0
        bne.s   .terrain_ready
        bsr     terrain_tick
.terrain_ready:
        clr.w   s_started(a6)
        clr.w   s_boosting(a6)
        clr.w   s_boost_ticks(a6)
        clr.w   s_controls(a6)
        clr.w   s_hit_ticks(a6)
        move.w  #4,s_message(a6)
        move.w  #275,s_message_ticks(a6)
        movem.l (sp)+,d0-d7/a0-a2
        rts

; Same queue/blitter as the ordinary player: identical doubling and shadows.
cup_draw_finish_ship:
        move.w  cup_finish_heading-state(a6),d0
        sub.w   s_angle(a6),d0
        addi.w  #32,d0
        andi.w  #255,d0
        lsr.w   #6,d0
        add.w   d0,d0
        lea     cup_player_view_offsets-state(a6),a1
        move.w  0(a1,d0.w),d0
        adda.w  d0,a1
        movea.l s_page(a6),a0
        adda.w  #156*128+52,a0
        moveq   #29,d2
        bra     blit_player

; Two 4-bit lookups replace the old 1024-byte fire table with 64 bytes.
; Used only by the explosion, with exactly the same final mask/ink pixels.
; D0 byte, A2 table, A0 destination; D3 merged word; preserve loop registers.
cup_fire_word:
        movem.l d4/d6,-(sp)
        move.w  d0,d4
        lsr.w   #4,d0
        lsl.w   #2,d0
        move.w  0(a2,d0.w),d3
        lsl.w   #4,d3
        move.w  2(a2,d0.w),d6
        lsl.w   #4,d6
        andi.w  #15,d4
        lsl.w   #2,d4
        or.w    0(a2,d4.w),d3
        or.w    2(a2,d4.w),d6
        and.w   (a0),d3
        or.w    d6,d3
        movem.l (sp)+,d4/d6
        rts
