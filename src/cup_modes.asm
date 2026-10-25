; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Resident illustrated selector, using the same pixels as the QDOS menu.
; Modes: 0 GP, 1 Time Attack, 2 Practice, 3 Death. Settings survive resets.
cup_boot_config:
        clr.w   qzr_requested-state(a6)
        cmpi.w  #-2,d7
        bne.s   .ordinary_boot
        move.w  #1,qzr_requested-state(a6)
.ordinary_boot:
        move.w  d6,d0
        andi.w  #255,d0
        cmpi.w  #3,d0
        bls.s   .mode
        moveq   #0,d0
.mode:
        move.w  d0,cup_mode-state(a6)
        lsr.w   #8,d6
        andi.w  #3,d6
        move.w  d6,cup_difficulty-state(a6)
        clr.w   cup_from_loader-state(a6)
        clr.w   cup_course-state(a6)
        cmpi.w  #mode_menu_course_count-1,d7
        bhi.s   .done
        move.w  d7,cup_course-state(a6)
        move.w  #1,cup_from_loader-state(a6)
.done:
        rts
cup_initial_menu:
        bsr     menu_reset
        tst.w   qzr_requested-state(a6)
        beq.s   .ordinary
        move.w  #8,cup_phase-state(a6)
        clr.w   qzr_requested-state(a6)
        bra.s   .done
.ordinary:
        tst.w   cup_from_loader-state(a6)
        bne.s   .done
        move.w  #5,cup_phase-state(a6)
.done:
        move.w  #1,cup_dirty-state(a6)
        move.w  #1,cup_enter-state(a6)
        rts

cup_mode_setup:
        clr.w   s_opponents(a6)
        tst.w   cup_mode-state(a6)
        beq.s   .rivals
        cmpi.w  #3,cup_mode-state(a6)
        bne.s   .done
.rivals:
        move.w  #1,s_opponents(a6)
        move.w  cup_difficulty-state(a6),d0
        cmpi.w  #3,cup_mode-state(a6)
        bne.s   .level
        moveq   #1,d0          ; fixed Standard AI makes Death records comparable
.level:
        lsl.w   #2,d0
        lea     cup_difficulty_speed(pc),a0
        move.w  0(a0,d0.w),s_rivals+2(a6)
        move.w  2(a0,d0.w),s_rivals+18(a6)
.done:
        rts

cup_select_frame:
        btst    #8,d0
        bne     cup_records_enter
        move.w  cup_mode-state(a6),d2
        btst    #1,d0            ; same physical KEYROW mapping as intro
        beq.s   .right
        subq.w  #1,d2
.right:
        btst    #4,d0
        beq.s   .wrap
        addq.w  #1,d2
.wrap:
        bpl.s   .high
        moveq   #3,d2
.high:
        cmpi.w  #4,d2
        blo.s   .mode
        moveq   #0,d2
.mode:
        cmp.w   cup_mode-state(a6),d2
        beq.s   .setting
        move.w  d2,cup_mode-state(a6)
        move.w  #1,cup_dirty-state(a6)
.setting:
        lea     cup_course(pc),a0
        moveq   #mode_menu_course_count,d3
        tst.w   d2
        bne.s   .option
        lea     cup_difficulty(pc),a0
        moveq   #4,d3
.option:
        move.w  (a0),d2
        btst    #2,d0
        beq.s   .down
        subq.w  #1,d2
.down:
        btst    #7,d0
        bne.s   .increment
        btst    #6,d0
        beq.s   .bound
.increment:
        addq.w  #1,d2
.bound:
        bpl.s   .limit
        move.w  d3,d2
        subq.w  #1,d2
.limit:
        cmp.w   d3,d2
        blo.s   .store
        moveq   #0,d2
.store:
        cmp.w   (a0),d2
        beq.s   .enter
        move.w  d2,(a0)
        move.w  #1,cup_dirty-state(a6)
.enter:
        btst    #0,d0
        beq.s   .draw
        bsr     cup_init
        move.w  #1,cup_enter-state(a6)
.draw:
        tst.w   cup_dirty-state(a6)
        beq.s   .done
        bsr     cup_draw_menu
        clr.w   cup_dirty-state(a6)
.done:
        moveq   #1,d0
        rts

cup_draw_selector:
        cmpi.w  #4,s_music_bank(a6)
        beq.s   .music_ready
        bsr     music_stop
        move.w  #4,s_music_bank(a6)
        bsr     music_init
.music_ready:
        move.l  #$20000,s_page(a6)
        move.b  #8,mc_stat
        move.w  cup_mode-state(a6),d0
        move.w  cup_course-state(a6),d1
        tst.w   d0
        bne.s   .option
        move.w  cup_difficulty-state(a6),d1
.option:
        movea.l a6,a0
        adda.l  #mode_menu_data-state,a0
        bsr     menu_draw
        lea     qzr_records_hint(pc),a1
        move.w  #mode_menu_records_y,d2
        bra     cup_center
        include "menu_draw.asm"

cup_draw_solo_intro:
        lea     cup_solo_rules(pc),a1
        cmpi.w  #3,cup_mode-state(a6)
        bne.s   .solo
        lea     cup_death_rules(pc),a1
        bra.s   .text
.solo:
        cmpi.w  #2,cup_mode-state(a6)
        bne.s   .text
        lea     cup_practice_rules(pc),a1
.text:
        move.w  #108,d2
        bsr     cup_center
        cmpi.w  #1,cup_mode-state(a6)
        bne.s   .start_hint
        lea     ghost_hint(pc),a1
        move.w  #196,d2
        bsr     cup_center
.start_hint:
        lea     cup_start_text(pc),a1
        move.w  #216,d2
        bra     cup_center

cup_draw_solo_results:
        cmpi.w  #3,cup_mode-state(a6)
        beq     cup_death_results
        lea     cup_time_title(pc),a1
        moveq   #40,d2
        bsr     cup_center
        movea.l a6,a1
        adda.l  #track_buffer-state+16,a1
        moveq   #64,d2
        bsr     cup_center
        move.l  s_race_ticks(a6),d0
        move.w  cup_round-state(a6),d1
        lsl.w   #2,d1
        lea     cup_best_races(pc),a0
        tst.l   0(a0,d1.w)
        beq.s   .record
        cmp.l   0(a0,d1.w),d0
        bhs.s   .format
.record:
        move.l  d0,0(a0,d1.w)
.format:
        lea     cup_total_line+6(pc),a1
        bsr     cup_format_time
        lea     cup_total_line(pc),a1
        moveq   #96,d2
        bsr     cup_center
        move.w  cup_round-state(a6),d0
        lsl.w   #2,d0
        lea     cup_best_races(pc),a0
        move.l  0(a0,d0.w),d0
        lea     cup_race_best_line+6(pc),a1
        bsr     cup_format_time
        lea     cup_race_best_line(pc),a1
        move.w  #120,d2
        bsr     cup_center
        bsr     cup_draw_lap_times
        rts

cup_mode: dc.w 0
cup_difficulty: dc.w 1
cup_course: dc.w 0
cup_from_loader: dc.w 0
cup_difficulty_speed: dc.w 68,68,84,80,88,86,92,90
cup_difficulty_boost: dc.w 250,150,100,65
cup_best_races: dcb.l mode_menu_course_count,0
cup_mode_names: dc.b 'GP RACE',0,0,0,0,0,'TIME ATTACK',0,'PRACTICE',0,0,0,0,'DEATH RACE',0,0,0
cup_solo_rules: dc.b '3 LAPS - NO RIVALS',0
cup_practice_rules: dc.b 'FREE LAPS - UNLIMITED ENERGY',0
cup_time_title: dc.b 'TIME ATTACK RESULTS',0
cup_total_line: dc.b 'TOTAL 00:00.00',0
cup_race_best_line: dc.b 'BEST  00:00.00',0
        even
