; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Pause overlays the current framebuffer. No screen copy or disk I/O.
; Physics, race time, ghost, camera and damage timers are skipped by phase 11.
; Music keeps its independent foreground clock. Resume repaints cached sky.
cup_pause_enter:
        move.w  #11,cup_phase-state(a6)
        clr.w   cup_pause_choice-state(a6)
        move.w  s_ticks(a6),cup_pause_start-state(a6)
        movea.l #$20000+88*128,a0
        moveq   #0,d0
        moveq   #35,d7          ; 72 rows, 256 bytes per iteration
        bsr     fill_256bytes
        lea     cup_pause_title(pc),a1
        moveq   #96,d2
        bsr     cup_center
        bra.s   cup_pause_draw

cup_pause_frame:
        btst    #0,d0
        beq.s   .select
        tst.w   cup_pause_choice-state(a6)
        beq.s   cup_pause_resume
        bsr     cup_leave_race
        bsr     cup_draw_menu
        clr.w   cup_dirty-state(a6)
        bra.s   cup_pause_wait
.select:
        andi.w  #$d6,d0        ; arrows: either axis changes the two choices
        beq.s   cup_pause_wait
        eori.w  #1,cup_pause_choice-state(a6)
cup_pause_draw:
        lea     cup_pause_options(pc),a1
        tst.w   cup_pause_choice-state(a6)
        beq.s   .selected
        lea     22(a1),a1
.selected:
        moveq   #120,d2
        bsr     cup_center
        lea     11(a1),a1
        move.w  #140,d2
        bsr     cup_center
cup_pause_wait:
        moveq   #1,d0
        rts

cup_pause_resume:
        ; Preserve the remaining GO banner time, even across clock wrap.
        tst.w   cup_go_until-state(a6)
        beq.s   .repaint
        move.w  s_ticks(a6),d0
        sub.w   cup_pause_start-state(a6),d0
        add.w   d0,cup_go_until-state(a6)
.repaint:
        clr.w   cup_phase-state(a6)
        clr.w   s_sky_horizon0(a6)
        bsr     render_frame
        bsr     cup_draw_go
        move.w  s_ticks(a6),s_last_tick(a6)
        move.w  s_ticks(a6),s_fps_tick(a6)
        clr.w   s_frames(a6)
        bra.s   cup_pause_wait

cup_leave_race:
        bsr     menu_reset
        bsr     music_stop
        clr.w   cup_finishing-state(a6)
        move.w  #5,cup_phase-state(a6)
        move.w  #1,cup_dirty-state(a6)
        rts

cup_pause_title: dc.b 'PAUSE',0
cup_pause_options:
        dc.b '* RESUME *',0,'   QUIT   ',0
        dc.b '  RESUME  ',0,'*  QUIT  *',0
        even
cup_pause_choice: dc.w 0
cup_pause_start: dc.w 0
