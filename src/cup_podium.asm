; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Winner-only celebration: Mute City parade, then three rising podiums.
; Phase 9 never runs racing physics, AI, damage, or the race timer.
podium_parade_ticks equ 1000
podium_rise_ticks equ 400
podium_hold_ticks equ 300
podium_total_ticks equ podium_parade_ticks+podium_rise_ticks+podium_hold_ticks
; At this stage no circuit rendering occurs again. Reuse the adjacent scene
; and active-track workspaces for rows 96..215 (15360 bytes), below the image.
podium_panel equ $28000
podium_page equ podium_panel-96*128
cup_start_podium:
        movem.l d0-d7/a0-a5,-(sp)
        move.w  #2,cup_phase-state(a6)
        bsr     cup_records_flush
        move.w  cup_round-state(a6),podium_round-state(a6)
        clr.w   cup_round-state(a6)
        bsr     cup_load_track
        move.w  #cup_results_music_bank,s_music_bank(a6)
        bsr     music_init
        move.w  #9,cup_phase-state(a6)
        move.w  #1,cup_finishing-state(a6)
        move.w  #1,s_opponents(a6)
        clr.w   s_started(a6)
        clr.w   podium_stage-state(a6)
        move.w  #-1,podium_raise-state(a6)
        move.w  s_ticks(a6),podium_start-state(a6)
        movem.l (sp)+,d0-d7/a0-a5
        moveq   #1,d0
        rts

; All input is ignored here. Only the 50 Hz clock ends the full ceremony.
; The menu dispatcher still consumes key edges, including during the hold.
cup_podium_frame:
        movem.l d0-d7/a0-a5,-(sp)
        move.w  s_ticks(a6),d6
        sub.w   podium_start-state(a6),d6
        cmpi.w  #podium_total_ticks,d6
        bhs     .finished
        cmpi.w  #podium_parade_ticks,d6
        bhs     .podium
        move.w  d6,d0
        cmpi.w  #900,d0
        blo.s   .cruise
        subi.w  #900,d0
        move.w  d0,d1
        lsl.w   #2,d0
        mulu.w  d1,d1
        divu.w  #50,d1
        sub.w   d1,d0
        addi.w  #3600,d0
        bra.s   .path
.cruise:
        lsl.w   #2,d0
.path:
        addi.w  #$300,d0
        andi.w  #$3fff,d0
        move.w  d0,podium_path-state(a6)
        move.w  d0,d3
        lsr.w   #8,d3
        move.w  d3,s_player_section(a6)
        bsr     podium_path_point
        move.w  d1,s_x(a6)
        move.w  d2,s_y(a6)
        move.w  d0,cup_finish_heading-state(a6)
        moveq   #0,d1
        move.w  d6,d1
        lsl.l   #8,d1
        divu.w  #podium_parade_ticks,d1
        add.w   d1,d0
        andi.w  #255,d0
        move.w  d0,s_angle(a6)
        moveq   #1,d7
.pilot:
        move.w  podium_path-state(a6),d0
        move.w  d7,d1
        lsl.w   #5,d1
        sub.w   d1,d0
        andi.w  #$3fff,d0
        bsr     podium_path_point
        ; Rank 2 right, rank 3 left; 1.5 units perpendicular to the path.
        move.w  #384,d3
        cmpi.w  #1,d7
        beq.s   .lane
        neg.w   d3
.lane:
        move.w  d0,d4
        add.w   d4,d4
        lea     direction_y-state(a6),a0
        move.w  0(a0,d4.w),d5
        muls.w  d3,d5
        asr.l   #8,d5
        sub.w   d5,d1
        lea     direction_x-state(a6),a0
        move.w  0(a0,d4.w),d5
        muls.w  d3,d5
        asr.l   #8,d5
        add.w   d5,d2
        move.w  d7,d3
        add.w   d3,d3
        lea     cup_order(pc),a0
        move.w  0(a0,d3.w),d3
        subq.w  #1,d3
        lsl.w   #4,d3
        lea     s_rivals(a6),a0
        move.w  d1,4(a0,d3.w)
        move.w  d2,6(a0,d3.w)
        move.w  d0,14(a0,d3.w)
        addq.w  #1,d7
        cmpi.w  #3,d7
        blo     .pilot
        move.w  #96,s_horizon(a6)
        move.w  #96,s_goal_horizon(a6)
        bsr     render_frame
        movea.l #$27000,a0
        moveq   #0,d0
        moveq   #15,d7
        bsr     fill_256bytes
        bsr     podium_caption
        bra     .restore
.podium:
        move.w  d6,podium_elapsed-state(a6)
        tst.w   podium_stage-state(a6)
        bne.s   .paint
        move.w  #1,podium_stage-state(a6)
        bsr     render_frame    ; one clean backdrop, then no GEOM work
        movea.l #$26c00,a0     ; rows 216..255: remove the old race HUD/road
        moveq   #0,d0
        moveq   #19,d7
        bsr     fill_256bytes
        bsr     podium_caption
        lea     podium_congrats(pc),a1
        move.w  #232,d2
        bsr     cup_center
.paint:
        move.w  podium_elapsed-state(a6),d0
        subi.w  #podium_parade_ticks,d0
        cmpi.w  #podium_rise_ticks,d0
        bls.s   .height_changed
        move.w  #podium_rise_ticks,d0
.height_changed:
        mulu.w  #56,d0
        divu.w  #podium_rise_ticks,d0
        cmp.w   podium_raise-state(a6),d0
        beq.s   .restore        ; retain the completed podium without flicker
        move.w  d0,podium_raise-state(a6)
        bsr     podium_draw
        bra.s   .restore
.finished:
        movem.l (sp)+,d0-d7/a0-a5
        bra.s   .finish
.restore:
        movem.l (sp)+,d0-d7/a0-a5
        moveq   #1,d0
        rts
.finish:
        move.w  podium_round-state(a6),cup_round-state(a6)
        clr.w   cup_finishing-state(a6)
        move.w  #2,cup_phase-state(a6)
        move.w  #1,cup_dirty-state(a6)
        bsr     cup_draw_menu
        clr.w   cup_dirty-state(a6)
        moveq   #1,d0
        rts

; D0 64-node 8.8 progress -> D1/D2 position, D0 heading. Preserve caller.
podium_path_point:
        movem.l d3-d6/a0-a1,-(sp)
        move.w  d0,d6
        lsr.w   #8,d0
        lsl.w   #2,d0
        movea.l #track_buffer+track_path_offset,a0
        lea     0(a0,d0.w),a1
        addq.w  #4,d0
        andi.w  #255,d0
        move.w  0(a0,d0.w),d4
        sub.w   (a1),d4
        move.w  2(a0,d0.w),d5
        sub.w   2(a1),d5
        andi.w  #255,d6
        move.w  d4,d1
        muls.w  d6,d1
        asr.l   #8,d1
        add.w   (a1),d1
        move.w  d5,d2
        muls.w  d6,d2
        asr.l   #8,d2
        add.w   2(a1),d2
        movem.w d1-d2,-(sp)
        move.w  d4,d0
        move.w  d5,d1
        bsr     vector_angle
        movem.w (sp)+,d1-d2
        movem.l (sp)+,d3-d6/a0-a1
        rts

podium_caption:
        movea.l #$20000,a0
        moveq   #0,d0
        moveq   #11,d7
        bsr     fill_256bytes
        lea     podium_title(pc),a1
        moveq   #8,d2
        bra     cup_center

podium_draw:
        ; A cache miss invalidates compositor records in the same workspace.
        ; Warm both front views BEFORE constructing the off-screen panel.
        moveq   #0,d7
        moveq   #22,d0
        bsr     cup_sprite_select
        moveq   #4,d7
        moveq   #22,d0
        bsr     cup_sprite_select
        move.l  #podium_page,s_page(a6)
        movea.l #podium_panel,a0
        moveq   #0,d0
        moveq   #59,d7         ; complete 120-row panel, entirely off-screen
        bsr     fill_256bytes
        moveq   #0,d7
.rank:
        move.w  d7,d0
        add.w   d0,d0
        lea     podium_centers(pc),a0
        move.w  0(a0,d0.w),d4
        lea     podium_heights(pc),a0
        move.w  0(a0,d0.w),d5
        move.w  podium_raise-state(a6),d1
        mulu.w  d1,d5
        divu.w  #56,d5
        move.w  #188,d2
        sub.w   d5,d2
        move.w  d2,podium_top-state(a6)
        lea     podium_colors(pc),a0
        move.w  0(a0,d0.w),d3
        move.w  d4,d1
        subi.w  #28,d1
        lsr.w   #1,d1
        movea.l s_page(a6),a1
        move.w  d2,d0
        lsl.w   #7,d0
        adda.w  d0,a1
        adda.w  d1,a1
        move.w  #211,d6
        sub.w   d2,d6
.row:
        movea.l a1,a0
        moveq   #13,d0
.word:
        move.w  d3,(a0)+
        dbra    d0,.word
        adda.w  #128,a1
        dbra    d6,.row
        movem.l d4/d7,-(sp)
        move.w  d7,d0
        addi.b  #'1',d0
        move.b  d0,podium_number-state(a6)
        lea     podium_number(pc),a1
        move.w  d4,d1
        lsr.w   #1,d1
        subq.w  #2,d1
        move.w  podium_top-state(a6),d2
        addq.w  #8,d2
        moveq   #7,d4
        bsr     draw_text
        movem.l (sp)+,d4/d7
        move.w  d7,d0
        add.w   d0,d0
        lea     cup_order(pc),a0
        move.w  0(a0,d0.w),d0
        move.w  podium_top-state(a6),d5
        subi.w  #30,d5
        movem.l d7,-(sp)
        bsr     podium_ship
        movem.l (sp)+,d7
        addq.w  #1,d7
        cmpi.w  #3,d7
        blo     .rank
        move.l  #$20000,s_page(a6)
        movea.l #podium_panel,a1
        movea.l #$23000,a0
        move.w  #479,d7
.publish:
        movem.l (a1)+,d0-d5/a2-a3
        movem.l d0-d5/a2-a3,(a0)
        adda.w  #32,a0
        dbra    d7,.publish
        rts

; D0 pilot, D4 center pixel, D5 top row. All source shadows remain intact.
podium_ship:
        movem.l d4-d5,-(sp)
        tst.w   d0
        bne.s   .rival
        lea     cup_player_view2(pc),a1
        moveq   #48,d3
        moveq   #30,d2
        bra.s   .position
.rival:
        subq.w  #1,d0
        lsl.w   #2,d0
        move.w  d0,d7
        moveq   #22,d0
        bsr     cup_sprite_select
        move.w  (a1)+,d3
        move.w  (a1)+,d2
.position:
        movem.l (sp)+,d4-d5
        lsr.w   #1,d3
        sub.w   d3,d4
        lsr.w   #1,d4
        andi.w  #$fffe,d4
        movea.l s_page(a6),a0
        lsl.w   #7,d5
        adda.w  d5,a0
        adda.w  d4,a0
        subq.w  #1,d2
        bra     blit_player

podium_start: dc.w 0
podium_round: dc.w 0
podium_stage: dc.w 0
podium_raise: dc.w -1
podium_path: dc.w 0
podium_elapsed: dc.w 0
podium_top: dc.w 0
podium_centers: dc.w 128,60,196
podium_heights: dc.w 56,40,24
podium_colors: dc.w $aaaa,$aa55,$00ff
podium_number: dc.b '1',0
podium_title: dc.b 'CLASSIC CUP CHAMPION',0
podium_congrats: dc.b 'CONGRATULATIONS!',0
        even
