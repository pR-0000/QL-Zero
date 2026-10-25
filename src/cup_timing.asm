; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Called once after a validated player lap. Units are real 50 Hz race ticks.
cup_capture_lap:
        movem.l d0-d4/a0,-(sp)
        bsr     cup_record_speed
        move.w  s_laps(a6),d0
        subq.w  #1,d0
        cmpi.w  #2,d0
        bhi.s   .done
        move.w  s_laps(a6),cup_lap_saved-state(a6)
        add.w   d0,d0
        lea     cup_lap_max_speeds(pc),a0
        move.w  cup_lap_top_speed-state(a6),0(a0,d0.w)
        clr.w   cup_lap_top_speed-state(a6)
        lsr.w   #1,d0
        lsl.w   #2,d0
        lea     cup_lap_times(pc),a0
        move.l  s_race_ticks(a6),d1
        move.l  d1,d2
        sub.l   cup_lap_start-state(a6),d1
        move.l  d1,0(a0,d0.w)
        bsr     cup_ghost_lap
        move.l  d2,cup_lap_start-state(a6)
        tst.l   d1
        beq.s   .done
        move.w  cup_round-state(a6),d0
        move.w  cup_mode-state(a6),d4
        mulu.w  #mode_menu_course_count,d4
        add.w   d4,d0
        lsl.w   #2,d0
        lea     cup_best_laps(pc),a0
        tst.l   0(a0,d0.w)
        beq.s   .record
        cmp.l   0(a0,d0.w),d1
        bhs.s   .done
.record:
        move.l  d1,0(a0,d0.w)
.done:
        movem.l (sp)+,d0-d4/a0
        rts

; Test a new maximum with squared integers. The HUD's exact square root is
; needed only when this threshold can be exceeded, not on every 50 Hz tick.
cup_record_speed:
        tst.w   cup_phase-state(a6)
        bne     .done
        tst.w   cup_finishing-state(a6)
        bne     .done
        tst.w   s_dead(a6)
        bne     .done
        cmpi.w  #1490,cup_lap_top_speed-state(a6)
        bhs     .done
        movem.l d0-d4,-(sp)
        move.w  s_vx(a6),d0
        muls.w  d0,d0
        move.w  s_vy(a6),d1
        muls.w  d1,d1
        add.l   d1,d0
        beq.s   .restore
        cmpi.l  #15418,d0
        bhs.s   .measure
        move.l  d0,d1
        lsl.l   #3,d1
        add.l   d1,d0
        lsl.l   #4,d0
        move.w  cup_lap_top_speed-state(a6),d1
        addq.w  #1,d1
        tst.w   s_boosting(a6)
        beq.s   .threshold
        tst.w   s_hills(a6)
        beq.s   .threshold
        moveq   #96,d2
        sub.w   s_goal_horizon(a6),d2
        ble.s   .threshold
        cmpi.w  #32,d2
        bls.s   .slope
        moveq   #32,d2
.slope:
        lsl.w   #2,d2
        sub.w   d2,d1
        ble.s   .measure
.threshold:
        mulu.w  d1,d1
        cmp.l   d1,d0
        blo.s   .restore
.measure:
        bsr     cup_display_speed
        cmp.w   cup_lap_top_speed-state(a6),d0
        bls.s   .restore
        move.w  d0,cup_lap_top_speed-state(a6)
.restore:
        movem.l (sp)+,d0-d4
.done:
        rts

; D0 ticks -> A1 eight-character MM:SS.CC, same 1/50-second precision as HUD.
cup_format_time:
        movem.l d0-d5/a1,-(sp)
        divu.w  #50,d0
        move.w  d0,d5
        swap    d0
        add.w   d0,d0
        adda.w  #6,a1
        bsr     cup_two
        suba.w  #6,a1
        moveq   #0,d0
        move.w  d5,d0
        divu.w  #60,d0
        move.l  d0,d5
        bsr     cup_two
        move.l  d5,d0
        swap    d0
        adda.w  #3,a1
        bsr     cup_two
        movem.l (sp)+,d0-d5/a1
        rts

cup_draw_lap_times:
        movem.l d0-d7/a0-a2,-(sp)
        lea     cup_best_line+5(pc),a1
        move.w  cup_round-state(a6),d0
        move.w  cup_mode-state(a6),d4
        mulu.w  #mode_menu_course_count,d4
        add.w   d4,d0
        lsl.w   #2,d0
        lea     cup_best_laps(pc),a0
        move.l  0(a0,d0.w),d0
        bsr     cup_blank_time
        tst.l   d0
        beq.s   .best_ready
        bsr     cup_format_time
.best_ready:
        lea     cup_best_line(pc),a1
        move.w  #196,d2
        bsr     cup_center
        moveq   #0,d6
.lap:
        lea     cup_lap_line(pc),a1
        move.b  #'-',17(a1)
        move.b  #'-',18(a1)
        move.b  #'-',19(a1)
        move.b  #'-',20(a1)
        move.w  d6,d0
        addi.b  #'1',d0
        move.b  d0,4(a1)
        move.b  #' ',5(a1)
        adda.w  #8,a1
        bsr     cup_blank_time
        suba.w  #8,a1
        cmp.w   cup_lap_saved-state(a6),d6
        bhs.s   .draw
        move.w  d6,d0
        lsl.w   #2,d0
        lea     cup_lap_times(pc),a0
        move.l  0(a0,d0.w),d3
        move.w  cup_round-state(a6),d0
        move.w  cup_mode-state(a6),d4
        mulu.w  #mode_menu_course_count,d4
        add.w   d4,d0
        lsl.w   #2,d0
        lea     cup_best_laps(pc),a0
        cmp.l   0(a0,d0.w),d3
        bne.s   .format
        tst.l   d3
        beq.s   .format
        move.b  #'!',5(a1)      ; supported native font: session personal best
.format:
        move.l  d3,d0
        adda.w  #8,a1
        bsr     cup_format_time
        lea     cup_lap_max_speeds(pc),a0
        move.w  d6,d0
        add.w   d0,d0
        move.w  0(a0,d0.w),d0
        lea     cup_lap_line+17(pc),a1
        bsr     cup_format_speed
.draw:
        lea     cup_lap_line(pc),a1
        move.w  d6,d2
        mulu.w  #12,d2
        addi.w  #208,d2
        bsr     cup_center
        addq.w  #1,d6
        cmpi.w  #3,d6
        blo     .lap
        movem.l (sp)+,d0-d7/a0-a2
        rts

; Text fields may start at odd addresses (BEST's digits begin at byte 5).
; Original 68000/68008 word/longword transfers require an even address.
cup_blank_time:
        movem.l d0/a0-a1,-(sp)
        lea     cup_empty_time(pc),a0
        moveq   #7,d0
.copy:
        move.b  (a0)+,(a1)+
        dbra    d0,.copy
        movem.l (sp)+,d0/a0-a1
        rts

cup_empty_time: dc.b '--:--.--'
cup_best_line: dc.b 'BEST 00:00.00',0
cup_lap_line: dc.b 'LAP 1   00:00.00 0000 KM/H',0
        even
