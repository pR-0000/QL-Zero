; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Two independent waypoint pilots with distinct sprites. No allocation or
; storage access during racing. Steering decisions run at 12.5 Hz; motion
; and the player's small slope load run at the normal 50 Hz physics rate.
; Record: target waypoint 8.8, cruise cap, x, y, vx, vy, laps, heading.
race_init:
        tst.w   s_options_ready(a6)
        bne.s   .options
        move.w  #1,s_options_ready(a6)
        clr.w   s_far_lod(a6)
        move.w  #1,s_hills(a6)
        move.w  #1,s_opponents(a6)
        move.w  #1,s_decor(a6)
        move.w  #4096,s_far_depth(a6) ; profile's initial view distance
.options:
        move.w  #96,s_horizon(a6)
        move.w  #96,s_goal_horizon(a6)
        move.w  #96,s_view_horizon(a6)
        clr.w   s_ai_clock(a6)
        clr.w   s_player_section(a6)
        clr.w   s_bump_timer(a6)
        lea     s_rivals(a6),a0
        moveq   #7,d0
.clear:
        clr.l   (a0)+
        dbra    d0,.clear
        lea     s_rivals(a6),a4
        move.w  #128,(a4)
        move.w  #84,2(a4)          ; outside lane: compensate the longer line
        moveq   #0,d7
        bsr     ai_position
        move.w  d0,4(a4)
        move.w  d1,6(a4)
        move.w  s_angle(a6),14(a4)
        move.w  #256,(a4)
        lea     s_rivals+16(a6),a4
        move.w  #384,(a4)
        move.w  #80,2(a4)
        moveq   #1,d7
        bsr     ai_position
        move.w  d0,4(a4)
        move.w  d1,6(a4)
        move.w  s_angle(a6),14(a4)
        move.w  #512,(a4)
        lea     s_npc_physics(a6),a0
        moveq   #5,d0
.clear_physics:
        clr.l   (a0)+
        dbra    d0,.clear_physics
        clr.l   s_npc_damage(a6)
        rts

read_extra_controls:
        move.w  d3,d0
        andi.w  #17,d0               ; F4/F3/F5: row 0 contacts 0/4/5
        bne.s   .pressed
        clr.w   s_f3_latch(a6)
        clr.w   s_f4_latch(a6)
        clr.w   s_f5_latch(a6)
        rts
.pressed:
        movem.l d0-d2/d4-d7/a0,-(sp)
        btst    #4,d3                ; F3, QL contact 4
        beq.s   .f3_up
        tst.w   s_f3_latch(a6)
        bne.s   .f3_done
        move.w  #1,s_f3_latch(a6)
        eori.w  #1,s_hills(a6)
        move.w  #96,s_horizon(a6)
        move.w  #96,s_goal_horizon(a6)
        tst.w   s_hills(a6)
        beq.s   .f3_done
        bsr     player_find_section
        bra.s   .f3_done
.f3_up:
        clr.w   s_f3_latch(a6)
.f3_done:
        btst    #0,d3                ; F4, QL contact 0
        beq.s   .f4_up
        tst.w   s_f4_latch(a6)
        bne.s   .done
        move.w  #1,s_f4_latch(a6)
        cmpi.w  #1,cup_mode-state(a6)
        bne.s   .f4_unchanged
        eori.w  #1,ghost_visible-state(a6)
        move.w  #-1,cup_hud_cache-state(a6)
.f4_unchanged:
        bra.s   .done
.f4_up:
        clr.w   s_f4_latch(a6)
.done:
        movem.l (sp)+,d0-d2/d4-d7/a0
        rts

ai_tick:
        tst.w   cup_phase-state(a6)
        bne     .done
        tst.w   s_started(a6)
        bne.s   .active
        tst.w   s_dead(a6)
        bne.s   .active
        tst.w   cup_finishing-state(a6)
        beq     .done
.active:
        addq.w  #1,s_ai_clock(a6)
        move.w  s_ai_clock(a6),d0
        andi.w  #7,d0
        bne.s   .terrain_done
        tst.w   s_dead(a6)
        bne.s   .terrain_done
        tst.w   cup_finishing-state(a6)
        bne.s   .terrain_done
        bsr     terrain_tick
        bsr     wrong_way_tick
.terrain_done:
        tst.w   s_opponents(a6)
        beq     .done
        tst.w   s_bump_timer(a6)
        beq.s   .bump_ready
        subq.w  #1,s_bump_timer(a6)
.bump_ready:
        lea     s_rivals(a6),a4
        moveq   #0,d7
.pilot:
        lea     s_npc_offsets(a6),a5
        move.w  d7,d0
        lsl.w   #2,d0
        adda.w  d0,a5
        lea     s_npc_physics(a6),a3
        move.w  d7,d0
        mulu.w  #12,d0
        adda.w  d0,a3
        lea     s_npc_damage(a6),a0
        move.w  d7,d0
        add.w   d0,d0
        tst.w   0(a0,d0.w)
        beq.s   .flash_done
        subq.w  #1,0(a0,d0.w)
.flash_done:
        move.w  d7,d0
        add.w   d0,d0
        lea     cup_npc_dead(pc),a0
        tst.w   0(a0,d0.w)
        bne.s   .contact
        cmpi.w  #25,8(a3)
        bhi.s   .move              ; retain collision recoil before pursuit
        move.w  s_ai_clock(a6),d0
        andi.w  #3,d0
        bne.s   .move
        bsr     npc_controls
.move:
        bsr     npc_physics_tick
.contact:
        tst.w   s_dead(a6)
        bne.s   .next
        tst.w   cup_finishing-state(a6)
        bne.s   .next
        tst.w   s_bump_timer(a6)
        bne.s   .next
        move.w  4(a4),d0
        sub.w   s_x(a6),d0
        bpl.s   .x_abs
        neg.w   d0
.x_abs:
        cmpi.w  #320,d0
        bhs.s   .next
        move.w  6(a4),d0
        sub.w   s_y(a6),d0
        bpl.s   .y_abs
        neg.w   d0
.y_abs:
        cmpi.w  #320,d0
        bhs.s   .next
        bsr     enemy_bounce
.next:
        adda.w  #16,a4
        addq.w  #1,d7
        cmpi.w  #2,d7
        blo     .pilot
        bsr     npc_pair_bounce
.done:
        rts

; Target interpolates adjacent sections, with quarter-halfwidth lane offsets
; taken from THIS circuit's actual asphalt edges. Returns x/y in D0/D1.
ai_position:
        movem.l d6/a2,-(sp)
        move.w  (a4),d6
        lsr.w   #4,d6
        andi.w  #$03f0,d6
        movea.l a6,a2
        adda.l  #track_buffer-state,a2
        adda.w  #track_mesh_offset,a2
        lea     0(a2,d6.w),a0
        bsr.s   ai_lane_point
        tst.b   1(a4)
        beq.s   .offsets
        move.w  d0,d4
        move.w  d1,d5
        addi.w  #16,d6
        andi.w  #$03ff,d6
        lea     0(a2,d6.w),a0
        bsr.s   ai_lane_point
        move.w  (a4),d2
        andi.w  #255,d2
        sub.w   d4,d0
        muls.w  d2,d0
        asr.l   #8,d0
        add.w   d4,d0
        sub.w   d5,d1
        muls.w  d2,d1
        asr.l   #8,d1
        add.w   d5,d1
.offsets:
        lea     s_npc_offsets(a6),a0
        move.w  d7,d2
        lsl.w   #2,d2
        add.w   0(a0,d2.w),d0
        add.w   2(a0,d2.w),d1
        movem.l (sp)+,d6/a2
        rts

ai_lane_point:
        move.w  4(a0),d0
        move.w  8(a0),d2
        move.w  d0,d3
        add.w   d2,d0
        lsr.w   #1,d0
        sub.w   d2,d3
        asr.w   #3,d3
        tst.w   d7
        beq.s   .left_x
        neg.w   d3
.left_x:
        add.w   d3,d0
        move.w  6(a0),d1
        move.w  10(a0),d2
        move.w  d1,d3
        add.w   d2,d1
        lsr.w   #1,d1
        sub.w   d2,d3
        asr.w   #3,d3
        tst.w   d7
        beq.s   .left_y
        neg.w   d3
.left_y:
        add.w   d3,d1
        rts

; One full reacquisition when F3 is enabled. Normal tracking examines only

player_find_section:
        moveq   #0,d4
        moveq   #63,d7
        bra.s   player_scan_section

terrain_tick:
        move.w  s_player_section(a6),d4
        subq.w  #1,d4
        moveq   #2,d7
        bsr.s   player_scan_section
        tst.w   s_hills(a6)
        beq.s   .done
        move.w  s_player_section(a6),d0
        add.w   d0,d0
        lea     cup_hills-state(a6),a0
.profile_ready:
        move.w  0(a0,d0.w),d0
        addi.w  #96,d0
        move.w  d0,s_goal_horizon(a6)
        cmp.w   s_horizon(a6),d0
        beq.s   .done
        blt.s   .rise
        addq.w  #4,s_horizon(a6)
        rts
.rise:
        subq.w  #4,s_horizon(a6)
.done:
        rts

player_scan_section:
        move.w  #$ffff,d6
        movea.l a6,a0
        adda.l  #track_buffer-state,a0
        adda.w  #track_path_offset,a0
.scan:
        move.w  d4,d5
        andi.w  #63,d5
        move.w  d5,d2
        lsl.w   #2,d2
        move.w  0(a0,d2.w),d0
        sub.w   s_x(a6),d0
        bpl.s   .x_abs
        neg.w   d0
.x_abs:
        move.w  2(a0,d2.w),d1
        sub.w   s_y(a6),d1
        bpl.s   .y_abs
        neg.w   d1
.y_abs:
        add.w   d1,d0
        cmp.w   d6,d0
        bhs.s   .next
        move.w  d0,d6
        move.w  d5,s_player_section(a6)
.next:
        addq.w  #1,d4
        dbra    d7,.scan
        rts

draw_rivals:
        cmpi.w  #9,cup_phase-state(a6)
        bne.s   .ordinary_draw
        tst.w   podium_stage-state(a6)
        beq.s   .ordinary_draw
        rts
.ordinary_draw:
        tst.w   s_opponents(a6)
        beq     .done
        lea     s_rivals+4(a6),a0
        lea     s_rival_camera(a6),a1
        bsr     world_to_camera
        adda.w  #12,a0
        bsr     world_to_camera
        moveq   #0,d7
        move.w  s_rival_camera+2(a6),d0
        cmp.w   s_rival_camera+6(a6),d0
        bge.s   .ordered
        moveq   #4,d7
.ordered:
        bsr     draw_one_rival
        eori.w  #4,d7
        bsr     draw_one_rival
.done:
        rts

rival_sort_pair:
        lea     s_rival_camera(a6),a0
        move.w  (a4),d0
        move.w  2(a4),d1
        move.w  2(a0,d0.w),d2
        cmp.w   2(a0,d1.w),d2
        bge.s   .done
        move.w  d1,(a4)
        move.w  d0,2(a4)
.done:
        rts

draw_one_rival:
        movem.l d7/a4-a5,-(sp)
        lea     s_rival_camera(a6),a0
        move.w  2(a0,d7.w),d1
        cmpi.w  #384,d1             ; normal NPC near plane is unchanged
        bge.s   .depth_visible
        cmpi.w  #1,cup_mode-state(a6)
        bne     .done
        cmpi.w  #128,d1             ; calibrated, close Time Attack ghost only
        blt     .done
.depth_visible:
        move.w  0(a0,d7.w),d0
        move.w  #72,d2
        move.l  #28672,d3
        move.w  s_quality(a6),d4
        beq.s   .projection
        cmpi.w  #5,d4
        beq.s   .projection
        move.w  #96,d2
        move.l  #18432,d3
.projection:
        muls.w  d2,d0
        divs.w  d1,d0
        addi.w  #128,d0
        move.w  d0,d4
        divu.w  d1,d3
        move.w  d3,d5
        moveq   #0,d0
        cmpi.w  #14,d5
        blt.s   .size
        moveq   #2,d0
        cmpi.w  #28,d5
        blt.s   .size
        moveq   #4,d0
        cmpi.w  #44,d5
        blt.s   .size
        moveq   #6,d0
.size:
        move.w  d7,d1
        lsl.w   #2,d1
        lea     s_rivals(a6),a0
        move.w  14(a0,d1.w),d1
        sub.w   s_angle(a6),d1
        addi.w  #32,d1
        andi.w  #255,d1
        lsr.w   #6,d1
        lsl.w   #3,d1
        add.w   d1,d0
        move.w  d0,364(a6)       ; view/size, retained across source-bank lookup
        bsr     cup_sprite_select
        move.w  (a1)+,d3
        move.w  (a1)+,d2
        lsr.w   #1,d3
        sub.w   d3,d4
        andi.w  #$fffc,d4
        asr.w   #1,d4
        move.w  d4,s_sprite_x(a6)
        add.w   s_view_horizon(a6),d5
        sub.w   d2,d5
        move.w  d5,s_sprite_y(a6)
        move.w  d4,d0
        add.w   d3,d0
        ble     .done              ; reject invisible ships before row clipping
        cmpi.w  #128,d4
        bge     .done
        bsr     mark_sky_sprite
        ; Independent of physical stun: white/normal/white over 32 ticks.
        move.w  d7,d0
        lsr.w   #1,d0
        lea     s_npc_damage(a6),a0
        move.w  0(a0,d0.w),d0
        move.w  d7,d6
        lsr.w   #1,d6
        lea     cup_npc_dead(pc),a0
        tst.w   0(a0,d6.w)
        beq.s   .alive_flash
        move.w  0(a0,d6.w),d0
        cmpi.w  #8,d0
        blo.s   .white
        moveq   #0,d0
.alive_flash:
        beq.s   .flash_ready
        cmpi.w  #16,d0
        bhs.s   .white
        cmpi.w  #8,d0
        bhs.s   .no_flash
.white:
        moveq   #1,d0
        bra.s   .flash_ready
.no_flash:
        moveq   #0,d0
.flash_ready:
        bsr     cup_npc_attack_tint
        move.w  d0,d6
        ; Most ships fit wholly in the viewport. Their prepacked row runs can
        ; use the fast player blitter; only edge-crossing ships pay clipping.
        tst.w   d4
        bmi.s   .clipped
        move.w  d4,d0
        add.w   d3,d0
        cmpi.w  #128,d0
        bgt.s   .clipped
        cmpi.w  #24,d5
        blt.s   .clipped
        move.w  d5,d0
        add.w   d2,d0
        cmpi.w  #224,d0
        bgt.s   .clipped
        movea.l s_page(a6),a0
        lsl.w   #7,d5
        adda.w  d5,a0
        adda.w  d4,a0
        subq.w  #1,d2
        tst.w   d6
        bne.s   .white_inside
        bsr     blit_player
        bra.s   .done
.white_inside:
        btst    #3,d6
        beq.s   .ordinary_white
        moveq   #9,d0
        bsr     queue_player_overlay
        bra.s   .done
.ordinary_white:
        bsr     blit_player_white
        bra.s   .done
.clipped:
        tst.w   d6
        bne.s   .white_clipped
        bsr     blit_rival
        bra.s   .done
.white_clipped:
        btst    #3,d6
        beq.s   .ordinary_clipped
        moveq   #9,d0
        bsr     queue_clipped_overlay
        bra.s   .done
.ordinary_clipped:
        bsr     blit_rival_white
.done:
        movem.l (sp)+,d7/a4-a5
        rts

; Pre-scaled sprites, native-word alignment. Clip before any VRAM access,
; including words at the left/right edge and rows near sky/HUD boundaries.
        include "sprite_clip.asm"
