; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Spin attack: 40 ticks, two visual turns; one press and 60 recovery ticks.
; Camera/flight heading stay independent from the animation. No disk I/O.
cup_combat_tick:
        bsr     cup_offense_tick
        movem.l d0-d2/a0-a2,-(sp)
        tst.w   cup_attack_cooldown-state(a6)
        beq.s   .attack
        subq.w  #1,cup_attack_cooldown-state(a6)
.attack:
        tst.w   cup_attack_ticks-state(a6)
        beq.s   .key
        subq.w  #1,cup_attack_ticks-state(a6)
.key:
        move.w  s_controls(a6),d0
        andi.w  #256,d0
        move.w  cup_ctrl_latch-state(a6),d1
        move.w  d0,cup_ctrl_latch-state(a6)
        tst.w   d0
        beq.s   .enemies
        tst.w   d1
        bne.s   .enemies
        tst.w   s_dead(a6)
        bne.s   .enemies
        tst.w   cup_finishing-state(a6)
        bne.s   .enemies
        tst.w   cup_attack_cooldown-state(a6)
        bne.s   .enemies
        move.w  #40,cup_attack_ticks-state(a6)
        move.w  #100,cup_attack_cooldown-state(a6)
.enemies:
        lea     cup_npc_dead(pc),a0
        lea     cup_npc_wall_delay(pc),a1
        moveq   #1,d2
.npc:
        tst.w   (a1)
        beq.s   .age
        subq.w  #1,(a1)
.age:
        tst.w   (a0)
        beq.s   .next
        cmpi.w  #65,(a0)
        bhs.s   .next
        addq.w  #1,(a0)
.next:
        addq.l  #2,a0
        addq.l  #2,a1
        dbra    d2,.npc
        movem.l (sp)+,d0-d2/a0-a2
        rts

cup_attack_controls:
        tst.w   cup_attack_ticks-state(a6)
        beq.s   .done
        andi.w  #$ff2d,s_controls(a6) ; no steering, brake or boost
        ori.w   #4,s_controls(a6)     ; normal throttle, keep inertial velocity
        clr.w   s_boost_ticks(a6)
        clr.w   s_pad_ticks(a6)
        clr.w   s_boosting(a6)
.done:
        rts

cup_draw_attack:
        moveq   #40,d0
        sub.w   cup_attack_ticks-state(a6),d0
        divu.w  #5,d0
        andi.w  #3,d0
        add.w   d0,d0
        lea     cup_player_view_offsets-state(a6),a1
        move.w  0(a1,d0.w),d0
        adda.w  d0,a1
        movea.l s_page(a6),a0
        adda.w  #156*128+52,a0
        moveq   #29,d2
        btst    #3,cup_attack_ticks+1-state(a6)
        bne     blit_player
        moveq   #9,d0         ; tint red + silhouette, same overlay pass
        bra     queue_player_overlay

; D7 NPC 0/1, D0 damage, D1=1 if player caused the hit. Preserve callers.
cup_hit_npc:
        movem.l d0-d3/a0-a2,-(sp)
        tst.w   cup_finishing-state(a6)
        bne     .done
        move.w  d7,d2
        add.w   d2,d2
        lea     cup_npc_attack(pc),a0
        tst.w   0(a0,d2.w)
        bne     .done
        lea     cup_npc_dead(pc),a0
        tst.w   0(a0,d2.w)
        bne     .done
        tst.w   cup_mode-state(a6)
        bne.s   .damage
        lea     cup_places+2(pc),a1
        tst.w   0(a1,d2.w)      ; finishers have already locked their result
        bne     .done
.damage:
        lea     cup_npc_energy(pc),a1
        sub.w   d0,0(a1,d2.w)
        bgt     .done
        clr.w   0(a1,d2.w)
        move.w  #1,0(a0,d2.w)
        lea     cup_npc_boost(pc),a1
        clr.w   0(a1,d2.w)
        move.w  d7,d3
        lsl.w   #4,d3
        lea     s_rivals(a6),a1
        clr.l   8(a1,d3.w)
        move.w  d7,d3
        mulu.w  #12,d3
        lea     s_npc_physics(a6),a1
        clr.w   0(a1,d3.w)
        tst.w   d1
        bne.s   .star
        cmpi.w  #3,cup_mode-state(a6)
        bne.s   .place
.star:
        addq.w  #1,cup_stars-state(a6)
        addq.w  #1,cup_race_stars-state(a6)
.place:
        ; First retired machine is third, the next second; retired machines
        ; never increment the finish count and receive no GP points.
        lea     cup_places+2(pc),a1
        moveq   #3,d0
        move.w  d2,d3
        eori.w  #2,d3
        tst.w   0(a0,d3.w)
        beq.s   .retire
        moveq   #2,d0
.retire:
        move.w  d0,0(a1,d2.w)
        move.w  #6,s_message(a6)
        move.w  #70,s_message_ticks(a6)
.done:
        movem.l (sp)+,d0-d3/a0-a2
        rts

cup_contact_damage:
        moveq   #16,d0
        tst.w   cup_attack_ticks-state(a6)
        beq.s   .hit
        moveq   #80,d0
.hit:
        moveq   #1,d1
        bra     cup_hit_npc

cup_wall_damage:
        movem.l d0-d1/a0,-(sp)
        move.w  d7,d0
        add.w   d0,d0
        lea     cup_npc_wall_delay(pc),a0
        tst.w   0(a0,d0.w)
        bne.s   .done
        move.w  #15,0(a0,d0.w)
        moveq   #8,d0
        moveq   #0,d1
        bsr     cup_hit_npc
.done:
        movem.l (sp)+,d0-d1/a0
        rts

; Existing proximity test calls this only for a stationary wreck. It cannot
; be moved or damaged; the player's velocity reflects on the dominant axis.
cup_wreck_bounce:
        movem.l d0-d7/a0-a5,-(sp)
        move.w  s_x(a6),d0
        sub.w   4(a4),d0
        move.w  d0,d2
        bpl.s   .x
        neg.w   d2
.x:
        move.w  s_y(a6),d1
        sub.w   6(a4),d1
        move.w  d1,d3
        bpl.s   .y
        neg.w   d3
.y:
        moveq   #0,d6
        cmp.w   d3,d2
        bge.s   .axis
        move.w  d1,d0
        moveq   #2,d6
.axis:
        moveq   #1,d4
        tst.w   d0
        bpl.s   .sign
        moveq   #-1,d4
.sign:
        lea     s_vx(a6),a0
        move.w  0(a0,d6.w),d5
        add.w   d5,d5
        bsr     collision_impulse
        add.w   d5,0(a0,d6.w)
        move.w  s_x(a6),d1
        move.w  s_y(a6),d2
        lsl.w   #6,d4
        tst.w   d6
        bne.s   .push_y
        add.w   d4,d1
        bra.s   .move
.push_y:
        add.w   d4,d2
.move:
        bsr     safe_move_player
        move.w  #12,s_bump_timer(a6)
        moveq   #8,d0
        bsr     take_damage
        movem.l (sp)+,d0-d7/a0-a5
        rts

cup_death_results:
        lea     cup_death_title(pc),a1
        moveq   #40,d2
        bsr     cup_center
        movea.l a6,a1
        adda.l  #track_buffer-state+16,a1
        moveq   #64,d2
        bsr     cup_center
        move.w  cup_round-state(a6),d1
        lsl.w   #2,d1
        lea     cup_best_deaths(pc),a0
        move.l  s_race_ticks(a6),d0
        tst.l   0(a0,d1.w)
        beq.s   .record
        cmp.l   0(a0,d1.w),d0
        bhs.s   .time
.record:
        move.l  d0,0(a0,d1.w)
.time:
        lea     cup_total_line+6(pc),a1
        bsr     cup_format_time
        lea     cup_total_line(pc),a1
        moveq   #96,d2
        bsr     cup_center
        move.w  cup_round-state(a6),d1
        lsl.w   #2,d1
        lea     cup_best_deaths(pc),a0
        move.l  0(a0,d1.w),d0
        lea     cup_race_best_line+6(pc),a1
        bsr     cup_format_time
        lea     cup_race_best_line(pc),a1
        move.w  #120,d2
        bsr     cup_center
        lea     cup_star_line(pc),a1
        move.w  cup_race_stars-state(a6),d0
        addi.b  #'0',d0
        move.b  d0,8(a1)
        move.w  #156,d2
        bsr     cup_center
        rts

cup_star_line: dc.b 'STARS: *0',0
cup_death_title: dc.b 'DEATH RACE RESULTS',0
cup_death_rules: dc.b 'CTRL: ATTACK - DESTROY BOTH',0
        even
cup_best_deaths: dcb.l mode_menu_course_count,0

cup_machine_down: dc.b 'Enemy machine destroyed!',0
        even
