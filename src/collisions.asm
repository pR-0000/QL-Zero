; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Impact work is kept off the rendering path. All motion remains at 50 Hz.
; D1/D2 candidate position -> D0=0 for asphalt, 1 otherwise; D1/D2 preserved.
test_road_point:
        moveq   #1,d0
        cmpi.w  #256,d1
        blo.s   .done
        cmpi.w  #32512,d1
        bhs.s   .done
        cmpi.w  #256,d2
        blo.s   .done
        cmpi.w  #32512,d2
        bhs.s   .done
        move.w  d1,d3
        lsr.w   #8,d3
        move.w  d2,d4
        lsr.w   #1,d4
        andi.w  #$3f80,d4
        or.w    d3,d4
        bsr     map_sample_flags
        move.w  d3,d4            ; full flags for NPC boost strip query
        andi.w  #40,d3
        cmpi.w  #8,d3
        bne.s   .done
        moveq   #0,d0
.done:
        rts

safe_move_player:
        bsr.s   test_road_point
        tst.w   d0
        bne.s   .done
        lea     s_x(a6),a1
        bsr     trace_wall
        tst.w   d0
        bne.s   .done
        move.w  d1,s_x(a6)
        move.w  d2,s_y(a6)
.done:
        rts

safe_move_rival:
        bsr.s   test_road_point
        tst.w   d0
        bne.s   .done
        lea     4(a4),a1
        bsr     trace_wall
        tst.w   d0
        bne.s   .done
        move.w  d1,4(a4)
        move.w  d2,6(a4)
.done:
        rts

        include "swept_wall.asm"
; Signed offset relaxes towards the path, never sticking at a tiny residue.
damp_offset:
        tst.w   d1
        beq.s   .done
        move.w  d1,d2
        asr.w   #3,d2
        bne.s   .subtract
        moveq   #1,d2
.subtract:
        sub.w   d2,d1
.done:
        rts

; Contact-only projection onto both segments adjacent to the nearest node.
; Returns closest centerline X/Y in D1/D2. No table or per-frame allocation.
player_centerline_point:
        movem.l d3-d7/a0,-(sp)
        move.w  s_player_section(a6),d0
        subq.w  #1,d0
        andi.w  #63,d0
        bsr.s   project_path_segment
        movem.l d0-d2,-(sp)
        move.w  s_player_section(a6),d0
        bsr.s   project_path_segment
        cmp.l   (sp),d0
        blo.s   .closer
        movem.l (sp),d0-d2
.closer:
        lea     12(sp),sp
        movem.l (sp)+,d3-d7/a0
        rts

; D0 section -> D1/D2 projected center, D0 squared distance to player.
; Scale only the projection ratio to half-units: the <=64-unit half-segment
; guarantees a word denominator. Position/distance remain full 8.8 precision.
project_path_segment:
        movea.l a6,a0
        adda.l  #track_buffer-state+track_path_offset,a0
        lsl.w   #2,d0
        move.w  0(a0,d0.w),d1
        move.w  2(a0,d0.w),d2
        addq.w  #4,d0
        andi.w  #255,d0
        move.w  0(a0,d0.w),d3
        sub.w   d1,d3
        move.w  2(a0,d0.w),d4
        sub.w   d2,d4
        movem.w d1-d4,-(sp)
        move.w  s_x(a6),d5
        sub.w   d1,d5
        asr.w   #7,d5
        move.w  s_y(a6),d6
        sub.w   d2,d6
        asr.w   #7,d6
        asr.w   #7,d3
        asr.w   #7,d4
        muls.w  d3,d5
        muls.w  d4,d6
        add.l   d6,d5
        ble.s   .start
        muls.w  d3,d3
        muls.w  d4,d4
        add.l   d4,d3
        beq.s   .start
        cmp.l   d3,d5
        bhs.s   .end
        lsl.l   #8,d5
        divu.w  d3,d5
        bra.s   .ratio
.end:
        move.w  #256,d5
        bra.s   .ratio
.start:
        moveq   #0,d5
.ratio:
        move.w  4(sp),d3
        muls.w  d5,d3
        asr.l   #8,d3
        add.w   (sp),d3
        move.w  d3,d1
        move.w  6(sp),d4
        muls.w  d5,d4
        asr.l   #8,d4
        add.w   2(sp),d4
        move.w  d4,d2
        lea     8(sp),sp
        sub.w   s_x(a6),d3
        muls.w  d3,d3
        sub.w   s_y(a6),d4
        muls.w  d4,d4
        add.l   d4,d3
        move.l  d3,d0
        rts

wall_bounce:
        ; Do not use the cross-section of a waypoint AHEAD of the bend.
        ; The closest point on either adjacent segment gives the inward side.
        bsr     player_find_section
        bsr     player_centerline_point
        movem.w d1-d2,-(sp)
        sub.w   s_x(a6),d1
        sub.w   s_y(a6),d2
        move.w  d1,d0
        move.w  d2,d1
        move.w  d0,d2
        or.w    d1,d2
        bne.s   .normal
        move.w  s_vx(a6),d0
        move.w  s_vy(a6),d1
        neg.w   d0
        neg.w   d1
.normal:
        bsr     vector_angle
        add.w   d0,d0
        lea     direction_x-state(a6),a0
        move.w  0(a0,d0.w),d4
        lea     direction_y-state(a6),a0
        move.w  0(a0,d0.w),d5
.inward_ready:
        ; N now points INWARD. Enforce an escape speed even on a glancing hit.
        move.w  s_vx(a6),d0
        muls.w  d4,d0
        move.w  s_vy(a6),d1
        muls.w  d5,d1
        add.l   d1,d0
        asr.l   #8,d0
        move.w  d0,d6
        bpl.s   .normal_abs
        neg.w   d0
.normal_abs:
        move.w  d0,d1
        lsr.w   #2,d1
        add.w   d1,d0             ; restitution 1.25
        cmpi.w  #96,d0
        bhs.s   .limit_escape
        moveq   #96,d0
.limit_escape:
        ; Repeated elastic rail contacts must not amplify velocity forever.
        ; Keep the strong minimum escape, bound only the outward response.
        cmpi.w  #192,d0
        bls.s   .escape_ready
        move.w  #192,d0
.escape_ready:
        sub.w   d6,d0
        move.w  d0,d1
        muls.w  d4,d1
        asr.l   #8,d1
        add.w   d1,s_vx(a6)
        muls.w  d5,d0
        asr.l   #8,d0
        add.w   d0,s_vy(a6)
.push:
        ; First try a short inward step. If raster corner checks prevent it,
        ; explicitly depenetrate onto the verified centerline (contact only).
        ; A swept check cannot resolve an origin already inside a solid cell.
        move.l  s_x(a6),-(sp)
        move.w  s_x(a6),d1
        add.w   d4,d1
        move.w  s_y(a6),d2
        add.w   d5,d2
        bsr     safe_move_player
        move.l  s_x(a6),d0
        cmp.l   (sp)+,d0
        bne.s   .pushed
        move.w  (sp),d1
        move.w  2(sp),d2
        bsr     test_road_point
        tst.w   d0
        bne.s   .pushed
        move.w  d1,s_x(a6)
        move.w  d2,s_y(a6)
.pushed:
        addq.l  #4,sp
        clr.w   s_offroad(a6)
        cmpi.w  #24,s_speed(a6)
        bhs.s   .speed_ready
        move.w  #24,s_speed(a6)
.speed_ready:
        move.w  #20,s_hit_ticks(a6)
        clr.w   s_vx_fraction(a6)
        clr.w   s_vy_fraction(a6)
        rts

; Equal-mass impulse along the dominant separation axis. Both craft move
; apart, both velocities react, and the pilot recovers its lane gradually.
; D4 separation sign, D5 relative velocity -> signed outward impulse.
; Exchange closing velocity for equal masses, with a minimum visible recoil.
collision_impulse:
        tst.w   d4
        bpl.s   .normal
        neg.w   d5
.normal:
        tst.w   d5
        bmi.s   .closing
        clr.w   d5
.closing:
        neg.w   d5
        cmpi.w  #96,d5
        bhs.s   .minimum
        moveq   #96,d5
.minimum:
        cmpi.w  #192,d5
        bls.s   .sign
        move.w  #192,d5
.sign:
        tst.w   d4
        bpl.s   .done
        neg.w   d5
.done:
        rts

enemy_bounce:
        move.w  d7,d0
        add.w   d0,d0
        lea     cup_npc_dead(pc),a0
        tst.w   0(a0,d0.w)
        bne     cup_wreck_bounce
        movem.l d7/a4-a5,-(sp)
        move.w  s_x(a6),d0
        sub.w   4(a4),d0
        move.w  s_y(a6),d1
        sub.w   6(a4),d1
        move.w  d0,d2
        bpl.s   .x_abs
        neg.w   d2
.x_abs:
        move.w  d1,d3
        bpl.s   .y_abs
        neg.w   d3
.y_abs:
        cmp.w   d3,d2
        blt.s   .axis_y
        moveq   #0,d6
        bra.s   .axis_ready
.axis_y:
        move.w  d1,d0
        moveq   #2,d6
.axis_ready:
        moveq   #1,d4
        tst.w   d0
        bpl.s   .side_ready
        moveq   #-1,d4
.side_ready:
        lea     s_vx(a6),a0
        move.w  0(a0,d6.w),d5
        lea     8(a4),a1
        sub.w   0(a1,d6.w),d5
        bsr     collision_impulse
        add.w   d5,0(a0,d6.w)
        sub.w   d5,0(a1,d6.w)
        move.w  d4,d5
        lsl.w   #6,d5
        sub.w   d5,0(a5,d6.w)
        move.w  4(a4),d1
        move.w  6(a4),d2
        tst.w   d6
        bne.s   .npc_y
        sub.w   d5,d1
        bra.s   .npc_move
.npc_y:
        sub.w   d5,d2
.npc_move:
        move.w  d5,-(sp)
        bsr     safe_move_rival
        move.w  (sp)+,d5
        move.w  s_x(a6),d1
        move.w  s_y(a6),d2
        tst.w   d6
        bne.s   .player_y
        add.w   d5,d1
        bra.s   .player_move
.player_y:
        add.w   d5,d2
.player_move:
        bsr     safe_move_player
        cmpi.w  #8,s_speed(a6)
        blo.s   .slow
        subq.w  #8,s_speed(a6)
        bra.s   .damage
.slow:
        clr.w   s_speed(a6)
.damage:
        lea     s_npc_damage(a6),a0
        move.w  d7,d0
        add.w   d0,d0
        move.w  #32,0(a0,d0.w)
        move.w  d7,d0
        mulu.w  #12,d0
        lea     s_npc_physics(a6),a0
        move.w  #32,8(a0,d0.w)
        move.w  0(a0,d0.w),d1
        subq.w  #8,d1
        bpl.s   .npc_speed
        clr.w   d1
.npc_speed:
        move.w  d1,0(a0,d0.w)
        move.w  #20,s_hit_ticks(a6)
        move.w  #24,s_bump_timer(a6)
        bsr     cup_contact_damage
        bsr     cup_enemy_damage
        bsr     take_damage
        movem.l (sp)+,d7/a4-a5
        rts

; Opponent/opponent contact: pair cooldown and opposing lane displacements.
npc_pair_bounce:
        tst.l   cup_npc_dead-state(a6)
        beq.s   .live_pair
        rts
.live_pair:
        tst.w   s_pair_timer(a6)
        beq.s   .test
        subq.w  #1,s_pair_timer(a6)
        rts
.test:
        lea     s_rivals(a6),a4
        move.w  4(a4),d0
        sub.w   20(a4),d0
        move.w  d0,d2
        bpl.s   .x_abs
        neg.w   d2
.x_abs:
        cmpi.w  #320,d2
        bhs     .done
        move.w  6(a4),d1
        sub.w   22(a4),d1
        move.w  d1,d3
        bpl.s   .y_abs
        neg.w   d3
.y_abs:
        cmpi.w  #320,d3
        bhs     .done
        moveq   #0,d6
        cmp.w   d3,d2
        bge.s   .axis
        moveq   #2,d6
        move.w  d1,d0
.axis:
        moveq   #1,d4
        tst.w   d0
        bpl.s   .sign
        moveq   #-1,d4
.sign:
        lea     8(a4),a0
        move.w  0(a0,d6.w),d5
        sub.w   16(a0,d6.w),d5
        bsr     collision_impulse
        add.w   d5,0(a0,d6.w)
        sub.w   d5,16(a0,d6.w)
        move.w  d4,d5
        lsl.w   #6,d5
        lea     s_npc_offsets(a6),a0
        add.w   d5,0(a0,d6.w)
        sub.w   d5,4(a0,d6.w)
        move.w  #32,s_npc_physics+8(a6)
        move.w  #32,s_npc_physics+20(a6)
        move.l  #$00200020,s_npc_damage(a6)
        move.w  #20,s_pair_timer(a6)
        movem.l d0-d1/d7,-(sp)
        moveq   #0,d7
        moveq   #8,d0
        moveq   #0,d1
        bsr     cup_hit_npc
        moveq   #1,d7
        bsr     cup_hit_npc
        movem.l (sp)+,d0-d1/d7
.done:
        rts
