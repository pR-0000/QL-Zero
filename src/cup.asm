; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; CLASSIC CUP: persistent scores, actual ordered checkpoints, configurable cup.
; Gameplay resources are active in RAM; the disk variant loads between races.
cup_init:
        lea     cup_state(pc),a0
        moveq   #(cup_state_end-cup_state)/4-1,d0
.clear:
        clr.l   (a0)+
        dbra    d0,.clear
        tst.w   cup_mode-state(a6)
        beq.s   .gp
        move.w  cup_course-state(a6),cup_round-state(a6)
.gp:
        move.w  #3,cup_phase-state(a6)
        bsr     cup_load_track
        rts

cup_load_track:
        bsr     stop_microdrives
        bsr     music_stop
        bsr     cup_disk_load_course
        move.w  cup_round-state(a6),d0
        lsl.w   #4,d0
        lea     cup_track_table-state(a6),a5
        adda.w  d0,a5
        move.w  6(a5),cup_factor-state(a6)
        movea.l a6,a0
        adda.l  #track_buffer-state,a0
        lea     cup_hills(pc),a1
        moveq   #31,d0
.hills:
        move.l  (a0)+,(a1)+
        dbra    d0,.hills
        move.l  (a0)+,cup_city_color-state(a6)
        move.l  (a0)+,cup_sky_color-state(a6)
        movea.l #city_heights,a1
        moveq   #7,d0
.skyline:
        move.l  (a0)+,(a1)+
        dbra    d0,.skyline
        lea     floor_patterns-state(a6),a1
        moveq   #9,d0
.patterns:
        move.l  (a0)+,(a1)+
        dbra    d0,.patterns
        lea     sky_cloud_words(pc),a1
        moveq   #63,d0
.clouds:
        move.l  (a0)+,(a1)+
        dbra    d0,.clouds
        lea     cup_map_pixels(pc),a1
        move.l  a1,cup_map-state(a6)
        moveq   #95,d0
.map:
        move.l  (a0)+,(a1)+
        dbra    d0,.map
        bsr     cup_disk_decode_track
        clr.w   cup_finish_count-state(a6)
        clr.l   cup_places-state(a6)
        clr.w   cup_places+4-state(a6)
        clr.l   cup_npc_laps-state(a6)
        move.l  #$00010001,cup_npc_gates-state(a6)
        clr.w   cup_retired-state(a6)
        clr.w   cup_divider-state(a6)
        bsr     validate_track
        tst.l   d0
        bne     cup_corrupt
        bsr     reset_race
        bsr     cup_grid
        bsr     cup_mode_setup
        clr.w   cup_finishing-state(a6)
        clr.w   cup_finish_ticks-state(a6)
        clr.l   cup_lap_start-state(a6)
        clr.w   cup_lap_saved-state(a6)
        clr.w   cup_lap_top_speed-state(a6)
        clr.l   cup_lap_max_speeds-state(a6)
        clr.w   cup_lap_max_speeds+4-state(a6)
        clr.w   cup_go_until-state(a6)
        clr.l   cup_lap_times-state(a6)
        clr.l   cup_lap_times+4-state(a6)
        clr.l   cup_lap_times+8-state(a6)
        move.l  #$00ff00ff,cup_npc_energy-state(a6)
        clr.l   cup_npc_boost-state(a6)
        clr.l   cup_npc_cooldown-state(a6)
        clr.l   cup_npc_hit_sample-state(a6)
        clr.l   cup_npc_dead-state(a6)
        clr.l   cup_npc_wall_delay-state(a6)
        clr.l   cup_npc_attack-state(a6)
        clr.l   cup_npc_attack_delay-state(a6)
        clr.w   cup_attack_ticks-state(a6)
        clr.w   cup_attack_cooldown-state(a6)
        clr.w   cup_ctrl_latch-state(a6)
        clr.l   cup_race_stars-state(a6)
        clr.w   cup_race_stars+4-state(a6)
        move.l  #-1,cup_sprite_keys-state(a6)
        move.l  #-1,cup_sprite_keys+4-state(a6)
        clr.l   cup_sprite_recent-state(a6)
        clr.w   cup_check_cache-state(a6)
        lea     cup_hud_cache(pc),a0
        moveq   #7,d0
.hud_reset:
        move.l  #-1,(a0)+
        dbra    d0,.hud_reset
        bsr     cup_ghost_load
        bsr     music_init
        move.l  #$28000,s_frame_budget(a6)
        movea.l #frame_profile,a0
        move.w  #2,22(a0)
        clr.w   s_cache0(a6)
        clr.w   s_cache1(a6)
        clr.w   s_sky_horizon0(a6)
        clr.w   s_sky_horizon1(a6)
        move.l  #$20000,s_page(a6)
        move.b  #8,mc_stat
        move.w  #1,cup_dirty-state(a6)
        move.w  s_ticks(a6),s_last_tick(a6)
        rts

; Once per simulation tick. NPC gates are checked at 12.5 Hz; 80ms cannot
; skip a 10-unit gate at these speeds. Finish order locks at line crossing.
cup_tick:
        tst.w   cup_phase-state(a6)
        bne     .done
        movem.l d0-d7/a0-a5,-(sp)
        tst.w   cup_finishing-state(a6)
        beq.s   .race
        subq.w  #1,cup_finish_ticks-state(a6)
        bne     .restore
        clr.w   cup_finishing-state(a6)
        bra     .show_results
.race:
        tst.w   cup_mode-state(a6)
        bne     .player
        addq.w  #1,cup_divider-state(a6)
        move.w  cup_divider-state(a6),d0
        andi.w  #3,d0
        bne     .player
        moveq   #0,d6
.npc:
        move.w  d6,d5
        add.w   d5,d5
        lea     cup_npc_dead(pc),a0
        tst.w   0(a0,d5.w)
        bne     .next_npc
        lea     cup_npc_gates(pc),a1
        move.w  0(a1,d5.w),d0
        lsl.w   #3,d0
        movea.l a6,a0
        adda.l  #track_buffer-state+32,a0
        adda.w  d0,a0
        move.w  d6,d0
        lsl.w   #4,d0
        lea     s_rivals(a6),a4
        adda.w  d0,a4
        move.w  4(a4),d1
        move.w  6(a4),d2
        tst.w   0(a1,d5.w)
        bne.s   .npc_box
        move.w  d6,d7
        addq.w  #1,d7
        bsr     cup_line_cross
        tst.w   d0
        beq     .next_npc
.npc_box:
        cmp.w   (a0),d1
        blo.s   .next_npc
        cmp.w   2(a0),d2
        blo.s   .next_npc
        cmp.w   4(a0),d1
        bhi.s   .next_npc
        cmp.w   6(a0),d2
        bhi.s   .next_npc
        tst.w   0(a1,d5.w)
        bne.s   .advance
        lea     cup_npc_laps(pc),a2
        addq.w  #1,0(a2,d5.w)
        cmpi.w  #3,0(a2,d5.w)
        bne.s   .advance
        move.w  d6,d0
        addq.w  #1,d0
        bsr     cup_award
.advance:
        addq.w  #1,0(a1,d5.w)
        andi.w  #3,0(a1,d5.w)
.next_npc:
        addq.w  #1,d6
        cmpi.w  #2,d6
        blo     .npc
.player:
        cmpi.w  #2,cup_mode-state(a6)
        bne.s   .competitive
        cmpi.w  #3,s_laps(a6)
        blo     .restore
        clr.w   s_laps(a6)
        bra     .restore
.competitive:
        tst.w   s_dead(a6)
        bne.s   .retire
        cmpi.w  #3,cup_mode-state(a6)
        bne.s   .laps
        tst.w   cup_npc_dead-state(a6)
        beq     .restore
        tst.w   cup_npc_dead+2-state(a6)
        beq     .restore
        clr.w   cup_attack_ticks-state(a6)
        ; Last opponent destroyed: freeze the score and enter the same
        ; initialized centerline/orbit sequence as a normal race finish.
        bra.s   .solo_finish
.laps:
        cmpi.w  #3,s_laps(a6)
        blo     .restore
        tst.w   cup_mode-state(a6)
        bne.s   .solo_finish
        moveq   #0,d0
        bsr     cup_award
        bsr     cup_complete_order
        bsr     cup_repair_places
        bsr     cup_score
.solo_finish:
        clr.w   s_started(a6)  ; freeze race time and standings at the line
        move.w  #1,cup_finishing-state(a6)
        move.w  #275,cup_finish_ticks-state(a6)
        bsr     cup_finish_init
        clr.w   s_boosting(a6)
        clr.w   s_boost_ticks(a6)
        bra     .restore
.retire:
        cmpi.w  #448,s_death_ticks(a6)
        blo     .restore
        move.w  #1,cup_retired-state(a6)
        clr.w   s_started(a6)
        bsr     music_stop
        tst.w   cup_mode-state(a6)
        bne.s   .solo_retire
        bsr     cup_complete_order
        bsr     cup_repair_places
        bsr     cup_score       ; retired player receives zero; NPC order retained
        bra.s   .show_results
.solo_retire:
        move.w  #4,cup_phase-state(a6)
        move.w  #1,cup_dirty-state(a6)
        bra.s   .restore
.show_results:
        clr.w   s_started(a6)
        bsr     music_stop
        move.w  #1,cup_phase-state(a6)
        tst.w   cup_mode-state(a6)
        beq.s   .results_ready
        move.w  #6,cup_phase-state(a6)
.results_ready:
        move.w  #1,cup_dirty-state(a6)
.restore:
        movem.l (sp)+,d0-d7/a0-a5
.done:
        rts

; D0 pilot 0/1/2; preserve checkpoint-loop registers.
cup_award:
        movem.l d0-d1/a0,-(sp)
        add.w   d0,d0
        lea     cup_places(pc),a0
        tst.w   0(a0,d0.w)
        bne.s   .done
        addq.w  #1,cup_finish_count-state(a6)
        move.w  cup_finish_count-state(a6),0(a0,d0.w)
.done:
        movem.l (sp)+,d0-d1/a0
        rts

; Remaining finishers rank by their real checkpoint lap and target progress.
; A retired player is behind every running craft and receives zero points.
cup_complete_order:
        move.l  d7,-(sp)
        moveq   #1,d7
        bsr     cup_progress
        move.l  d0,d2
        moveq   #2,d7
        bsr     cup_progress
        move.l  d0,d3
        move.l  (sp)+,d7
        moveq   #1,d0
        moveq   #2,d1
.compare:
        cmp.l   d3,d2
        bhs.s   .ordered
        exg     d0,d1
.ordered:
        bsr     cup_award
        move.w  d1,d0
        bsr     cup_award
        moveq   #0,d0
        bsr     cup_award
        rts

cup_score:
        lea     cup_places(pc),a0
        lea     cup_scores(pc),a1
        lea     cup_wins(pc),a2
        lea     cup_last_points(pc),a3
        moveq   #0,d7
.pilot:
        move.w  (a0),d0
        move.w  d0,cup_last_places-cup_places(a0)
        cmpi.w  #1,d0
        bne.s   .points
        addq.w  #1,(a2)
.points:
        subq.w  #1,d0
        add.w   d0,d0
        lea     cup_point_table(pc),a4
        move.w  0(a4,d0.w),d1
        tst.w   d7
        bne.s   .add
        tst.w   cup_retired-state(a6)
        beq.s   .add
        moveq   #0,d1
.add:
        tst.w   d7
        beq.s   .score_alive
        move.w  d7,d0
        subq.w  #1,d0
        add.w   d0,d0
        lea     cup_npc_dead(pc),a4
        tst.w   0(a4,d0.w)
        beq.s   .score_alive
        moveq   #0,d1
.score_alive:
        add.w   d1,(a1)+
        move.w  d1,(a3)+
        addq.l  #2,a0
        addq.l  #2,a2
        addq.w  #1,d7
        cmpi.w  #3,d7
        blo.s   .pilot
        bsr     cup_standings
        rts

; Stable three-pilot sort: total points, wins, last-race finish position.
cup_standings:
        lea     cup_order(pc),a0
        move.l  #$00000001,(a0)
        move.w  #2,4(a0)
        moveq   #2,d7
.pass:
        lea     cup_order(pc),a0
        moveq   #1,d6
.pair:
        move.w  (a0),d0
        move.w  2(a0),d1
        add.w   d0,d0
        add.w   d1,d1
        lea     cup_scores(pc),a1
        move.w  0(a1,d0.w),d2
        cmp.w   0(a1,d1.w),d2
        bhi.s   .next
        blo.s   .swap
        lea     cup_wins(pc),a1
        move.w  0(a1,d0.w),d2
        cmp.w   0(a1,d1.w),d2
        bhi.s   .next
        blo.s   .swap
        lea     cup_last_places(pc),a1
        move.w  0(a1,d0.w),d2
        cmp.w   0(a1,d1.w),d2
        bls.s   .next
.swap:
        move.w  (a0),d0
        move.w  2(a0),(a0)
        move.w  d0,2(a0)
.next:
        addq.l  #2,a0
        dbra    d6,.pair
        dbra    d7,.pass
        rts

; Main loop uses D0=1 to skip race physics/drawing while a menu is visible.
cup_menu_frame:
        move.w  s_controls(a6),d0
        move.w  cup_enter-state(a6),d1
        move.w  d0,cup_enter-state(a6)
        not.w   d1
        and.w   d1,d0
        cmpi.w  #9,cup_phase-state(a6)
        beq     cup_podium_frame
        btst    #3,d0
        beq.s   .no_escape
        tst.w   cup_phase-state(a6)
        beq     cup_pause_enter
        cmpi.w  #11,cup_phase-state(a6)
        beq     cup_pause_resume
        bsr     cup_leave_race
.no_escape:
        cmpi.w  #11,cup_phase-state(a6)
        beq     cup_pause_frame
        cmpi.w  #10,cup_phase-state(a6)
        beq     cup_intro_frame
        cmpi.w  #8,cup_phase-state(a6)
        beq     cup_records_frame
        cmpi.w  #7,cup_phase-state(a6)
        beq     cup_countdown_frame
        cmpi.w  #5,cup_phase-state(a6)
        beq     cup_select_frame
        btst    #0,d0
        beq.s   .no_enter
        moveq   #1,d0
        bra.s   .edge_ready
.no_enter:
        moveq   #0,d0
.edge_ready:
        moveq   #0,d1
        tst.w   cup_phase-state(a6)
        beq     .racing
        tst.w   d0
        beq.s   .draw
        tst.w   d1
        bne.s   .draw
        cmpi.w  #3,cup_phase-state(a6)
        beq.s   .start
        cmpi.w  #2,cup_phase-state(a6)
        beq.s   .restart
        cmpi.w  #4,cup_phase-state(a6)
        beq.s   .restart
        cmpi.w  #6,cup_phase-state(a6)
        beq.s   .repeat
        cmpi.w  #mode_menu_course_count-1,cup_round-state(a6)
        beq.s   .final
        addq.w  #1,cup_round-state(a6)
        bsr     cup_load_track
.start:
        bsr     stop_microdrives
        bra     cup_begin_countdown
.final:
        move.w  #cup_results_music_bank,s_music_bank(a6)
        bsr     music_init
        tst.w   cup_order-state(a6)
        bne.s   .ordinary_final
        bra     cup_start_podium
.ordinary_final:
        move.w  #2,cup_phase-state(a6)
        move.w  #1,cup_dirty-state(a6)
        bra.s   .draw
.restart:
        move.w  #5,cup_phase-state(a6)
        move.w  #1,cup_dirty-state(a6)
        move.w  #1,cup_enter-state(a6)
        bra.s   .draw
.repeat:
        bsr     cup_init
        bra     .start
.draw:
        tst.w   cup_dirty-state(a6)
        beq.s   .menu
        bsr     cup_draw_menu
        clr.w   cup_dirty-state(a6)
.menu:
        moveq   #1,d0
        rts
.racing:
        moveq   #0,d0
        rts

cup_draw_menu:
        cmpi.w  #8,cup_phase-state(a6)
        beq     cup_draw_records
        bsr     cup_draw_menu_core
        movem.l d0-d7/a0-a5,-(sp)
        bsr     cup_ghost_flush
        move.w  d0,-(sp)
        bsr     cup_records_flush
        or.w    (sp)+,d0
        tst.l   d0
        beq.s   .unchanged
        bsr     cup_draw_menu_core ; remove the temporary saving indicator
.unchanged:
        movem.l (sp)+,d0-d7/a0-a5
        rts
cup_draw_menu_core:
        cmpi.w  #5,cup_phase-state(a6)
        beq     cup_draw_selector
        bsr     menu_reset
        move.l  #$20000,s_page(a6)
        move.b  #8,mc_stat
        movea.l #$20000,a0
        moveq   #0,d0
        moveq   #127,d7
        bsr     fill_256bytes
        cmpi.w  #6,cup_phase-state(a6)
        beq     cup_draw_solo_results
        lea     cup_title(pc),a1
        tst.w   cup_mode-state(a6)
        beq.s   .heading
        lea     cup_mode_names(pc),a1
        move.w  cup_mode-state(a6),d0
        mulu.w  #12,d0
        adda.w  d0,a1
.heading:
        moveq   #20,d2
        bsr     cup_center
        cmpi.w  #2,cup_phase-state(a6)
        beq     .champion
        cmpi.w  #4,cup_phase-state(a6)
        beq     .game_over
        tst.w   cup_mode-state(a6)
        bne.s   .course_name
        lea     cup_round_line(pc),a1
        move.w  cup_round-state(a6),d0
        addi.b  #'1',d0
        move.b  d0,cup_round_line+6-state(a6)
        moveq   #44,d2
        bsr     cup_center
.course_name:
        movea.l a6,a1
        adda.l  #track_buffer-state+16,a1
        moveq   #60,d2
        bsr     cup_center
        cmpi.w  #3,cup_phase-state(a6)
        beq     .intro
        lea     cup_result_title(pc),a1
        tst.w   cup_retired-state(a6)
        beq.s   .result_label
        lea     cup_retire_title(pc),a1
.result_label:
        moveq   #84,d2
        moveq   #12,d1         ; same PTS/TOTAL columns as the three rows
        moveq   #28,d4
        bsr     draw_text
        moveq   #0,d6
.race_row:
        lea     cup_places(pc),a0
        moveq   #0,d7
.find:
        move.w  d7,d0
        add.w   d0,d0
        move.w  0(a0,d0.w),d1
        subq.w  #1,d1
        cmp.w   d6,d1
        beq.s   .found
        addq.w  #1,d7
        cmpi.w  #3,d7
        blo.s   .find
        ; Never scan unrelated memory if an invalid result reaches the UI.
        lea     cup_invalid_text(pc),a1
        move.w  #116,d2
        bsr     cup_center
        bra     .menu_footer
.found:
        move.w  d6,d2
        mulu.w  #12,d2
        addi.w  #100,d2
        bsr     cup_row
        addq.w  #1,d6
        cmpi.w  #3,d6
        blo.s   .race_row
        lea     cup_standing_title(pc),a1
        move.w  #140,d2
        bsr     cup_center
        bsr     cup_draw_standings
        bsr     cup_draw_lap_times
.menu_footer:
        rts
.champion:
        lea     cup_champion_text(pc),a1
        tst.w   cup_order-state(a6)
        beq.s   .winner_text
        lea     cup_lost_text(pc),a1
.winner_text:
        moveq   #68,d2
        bsr     cup_center
        lea     cup_standing_title(pc),a1
        move.w  #140,d2
        bsr     cup_center
        bsr     cup_draw_standings
        rts
.intro:
        tst.w   cup_mode-state(a6)
        bne     cup_draw_solo_intro
        lea     cup_rules_text(pc),a1
        moveq   #96,d2
        bsr     cup_center
        lea     cup_points_text(pc),a1
        move.w  #116,d2
        bsr     cup_center
        lea     cup_boost_text(pc),a1
        move.w  #144,d2
        bsr     cup_center
        lea     cup_start_text(pc),a1
        move.w  #216,d2
        bsr     cup_center
        rts
.game_over:
        lea     cup_game_over_text(pc),a1
        moveq   #112,d2
        bsr     cup_center
        rts

cup_draw_standings:
        moveq   #0,d6
.row:
        move.w  d6,d0
        add.w   d0,d0
        lea     cup_order(pc),a0
        move.w  0(a0,d0.w),d7
        move.w  d6,d2
        mulu.w  #12,d2
        addi.w  #154,d2
        bsr     cup_row
        addq.w  #1,d6
        cmpi.w  #3,d6
        blo.s   .row
        rts

; Display rank, machine, points this round, total points. D6 rank, D7 pilot.
cup_row:
        movem.l d2/d6-d7,-(sp)
        lea     cup_line(pc),a1
        move.w  d6,d0
        addi.b  #'1',d0
        move.b  d0,(a1)
        move.w  d7,d0
        mulu.w  #8,d0
        lea     cup_names(pc),a0
        adda.w  d0,a0
        move.l  (a0)+,2(a1)
        move.l  (a0),6(a1)
        move.w  d7,d0
        add.w   d0,d0
        lea     cup_last_points(pc),a0
        move.w  0(a0,d0.w),d0
        lea     cup_line+12(pc),a1
        bsr     format_three
        move.w  d7,d0
        add.w   d0,d0
        lea     cup_scores(pc),a0
        move.w  0(a0,d0.w),d0
        lea     cup_line+18(pc),a1
        bsr     format_three
        lea     cup_line(pc),a1
        movem.l (sp)+,d2/d6-d7
        moveq   #12,d1
        moveq   #26,d4
        bsr     draw_text
        move.w  d7,d0
        add.w   d0,d0
        lea     cup_stars(pc),a0
        cmpi.w  #140,d2        ; first table: this race; standings: whole cup
        bhs.s   .star_total
        lea     cup_race_stars(pc),a0
.star_total:
        move.w  0(a0,d0.w),d0
        lea     cup_star_number(pc),a1
        bsr     cup_format_stars
        lea     cup_star_number(pc),a1
        moveq   #114,d1
        moveq   #3,d4
        bsr     draw_text
        rts

; D0 0..12, A1 buffer of four bytes. Never pad a single count with zeroes.
cup_format_stars:
        move.b  #'*',(a1)+
        cmpi.w  #10,d0
        blo.s   .single
        move.b  #'1',(a1)+
        subi.w  #10,d0
.single:
        addi.b  #'0',d0
        move.b  d0,(a1)+
        clr.b   (a1)
        rts

cup_center:
        movea.l a1,a0
        moveq   #0,d0
.length:
        tst.b   (a0)+
        beq.s   .draw
        addq.w  #2,d0
        bra.s   .length
.draw:
        moveq   #64,d1
        sub.w   d0,d1
        moveq   #31,d4
        bra     draw_text

cup_corrupt:
        move.b  #8,mc_stat
        stop    #$2700
        bra.s   cup_corrupt

        include "cup_lz.asm"
        include "cup_ai.asm"
        include "cup_finish.asm"
        include "cup_timing.asm"
        include "cup_modes.asm"
        include "cup_countdown.asm"
        include "cup_pause.asm"
        include "cup_storage.asm"
        include "cup_records.asm"
        include "cup_combat.asm"
        include "cup_ghost.asm"
        include "cup_offense.asm"
        include "cup_podium.asm"
        include "cup_sprite.asm"
        even
cup_title: dc.b 'QL-ZERO : CLASSIC CUP',0
cup_round_line: dc.b 'ROUND 1 / 6',0
cup_result_title: dc.b 'RACE        PTS   TOTAL   KO',0
cup_retire_title: dc.b 'RETIRED - 0 POINTS',0
cup_standing_title: dc.b 'CUP STANDINGS',0
cup_champion_text: dc.b 'YOU WON THE CUP!',0
cup_lost_text: dc.b 'CUP COMPLETE - TRY AGAIN!',0
cup_rules_text: dc.b '6 RACES - 3 LAPS - 2 RIVALS',0
cup_points_text: dc.b 'POINTS: 10 / 7 / 5',0
cup_boost_text: dc.b 'BOOST FROM LAP 2',0
cup_start_text: dc.b 'ARROWS: DRIVE',0
cup_game_over_text: dc.b 'GAME OVER',0
cup_invalid_text: dc.b 'RESULT UNAVAILABLE',0
        even
cup_names: dc.b 'YOU     BLUE    YELLOW  '
        even
cup_line: dc.b '1 YOU       000   000 PTS',0
cup_star_number: dc.b '000',0
        even
cup_point_table: dc.w 10,7,5
cup_state:
cup_phase: dc.w 0              ; 0 race, 1 results, 2 final, 3 intro, 4 game over
cup_round: dc.w 0
cup_enter: dc.w 0
cup_dirty: dc.w 0
cup_finish_count: dc.w 0
cup_retired: dc.w 0
cup_divider: dc.w 0
cup_factor: dc.w 26
cup_scores: dcb.w 3,0
cup_wins: dcb.w 3,0
cup_places: dcb.w 3,0
cup_last_places: dcb.w 3,0
cup_last_points: dcb.w 3,0
cup_order: dcb.w 3,0
cup_npc_laps: dcb.w 2,0
cup_npc_gates: dcb.w 2,0
cup_visibility: dc.l -1
cup_city_color: dc.l $00ff00ff
cup_sky_color: dc.l 0
cup_map: dc.l 0
cup_grid_slots: dcb.w 3,0
cup_npc_energy: dcb.w 2,255
cup_npc_boost: dcb.w 2,0
cup_npc_cooldown: dcb.w 2,0
cup_npc_hit_sample: dcb.w 2,0
cup_npc_dead: dcb.w 2,0
cup_npc_wall_delay: dcb.w 2,0
cup_attack_ticks: dc.w 0
cup_attack_cooldown: dc.w 0
cup_ctrl_latch: dc.w 0
cup_stars: dcb.w 3,0
cup_race_stars: dcb.w 3,0
cup_progress_node: dc.w 0
cup_finishing: dc.w 0
cup_finish_ticks: dc.w 0
cup_finish_path: dc.w 0
cup_finish_heading: dc.w 0
cup_line_dx: dc.w 0
cup_line_dy: dc.w 0
cup_line_sides: dcb.l 3,0
cup_lap_start: dc.l 0
cup_lap_times: dcb.l 3,0
cup_lap_saved: dc.w 0
cup_lap_top_speed: dc.w 0
cup_lap_max_speeds: dcb.w 3,0
cup_countdown_start: dc.w 0
cup_countdown_stage: dc.w 0
cup_go_until: dc.w 0
cup_hud_cache: dcb.w 16,-1
cup_hills: dcb.w 64,0
        cnop 0,4
cup_state_end:
; Preserve personal bests across cups while this game remains resident.
cup_best_laps: dcb.l 4*mode_menu_course_count,0
cup_map_pixels: dcb.b 384,0
