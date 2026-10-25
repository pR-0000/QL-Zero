; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Persistent personal bests. Two CRC-protected, fixed-size QDOS files act as
; a journal: write only the inactive slot, verify, then commit its generation.
; The older valid slot survives removal/power loss during a write.
qzr_restore_records:
        clr.w   qzr_have_records-state(a6)
        bsr     qzr_motor_on
        bsr     qzr_map_read
        tst.l   d0
        bne     .end
        clr.w   qzr_slot-state(a6)
.slot:
        lea     qzr_slot_names(pc),a0
        move.w  qzr_slot-state(a6),d0
        lsl.w   #3,d0
        adda.w  d0,a0
        bsr     qzr_find
        tst.l   d0
        bne     .next
        cmpi.l  #512,qzr_file_size-state(a6)
        bne     .next
        move.w  qzr_file-state(a6),d0
        lsl.w   #8,d0
        move.w  d0,qzr_target-state(a6)
        bsr     qzr_sector
        tst.l   d0
        bne     .next
        bsr     qzr_check_record
        tst.l   d0
        bne     .next
        tst.w   qzr_have_records-state(a6)
        beq.s   .apply
        move.l  qzr_sector_buffer+64+12-state(a6),d0
        sub.l   qzr_generation-state(a6),d0
        ble     .next
.apply:
        move.w  #1,qzr_have_records-state(a6)
        move.w  qzr_slot-state(a6),qzr_active_slot-state(a6)
        move.l  qzr_sector_buffer+64+12-state(a6),qzr_generation-state(a6)
        move.l  qzr_sector_buffer+64+16-state(a6),qzr_saved_crc-state(a6)
        lea     qzr_sector_buffer+84(pc),a0
        lea     cup_best_laps(pc),a1
        moveq   #4*mode_menu_course_count-1,d0
.laps:
        move.l  (a0)+,(a1)+
        dbra    d0,.laps
        lea     cup_best_races(pc),a1
        moveq   #mode_menu_course_count-1,d0
.races:
        move.l  (a0)+,(a1)+
        dbra    d0,.races
        lea     cup_best_deaths(pc),a1
        moveq   #mode_menu_course_count-1,d0
.death:
        move.l  (a0)+,(a1)+
        dbra    d0,.death
        lea     qzr_gp_bests(pc),a1
        moveq   #7,d0
.gp:
        move.l  (a0)+,d1
        cmpi.w  #3,qzr_sector_buffer+72-state(a6)
        beq.s   .gp_current
        moveq   #0,d1         ; old points cannot compete with the new scale
.gp_current:
        move.l  d1,(a1)+
        dbra    d0,.gp
        lea     qzr_header+2(pc),a0
        lea     qzr_medium(pc),a1
        moveq   #2,d0
.medium:
        move.l  (a0)+,(a1)+
        dbra    d0,.medium
        move.w  #1,qzr_medium_valid-state(a6)
.next:
        addq.w  #1,qzr_slot-state(a6)
        cmpi.w  #2,qzr_slot-state(a6)
        blo     .slot
.end:
        tst.w   qzr_have_records-state(a6)
        bne.s   .valid
        move.w  #2,qzr_save_status-state(a6) ; missing/corrupt: session still works
.valid:
        bra     qzr_motor_off

qzr_check_record:
        lea     qzr_sector_buffer+64(pc),a0
        cmpi.l  #$515a5232,(a0)
        bne.s   .bad
        cmpi.l  #qzr_game_id,4(a0)
        bne.s   .bad
        cmpi.w  #2,8(a0)
        blo.s   .bad
        cmpi.w  #3,8(a0)
        bhi.s   .bad
        cmpi.w  #mode_menu_course_count,10(a0)
        bne.s   .bad
        lea     20(a0),a0
        move.l  #qzr_record_bytes,d0
        bsr     qzr_crc32
        cmp.l   qzr_sector_buffer+80-state(a6),d0
        bne.s   .bad
        moveq   #0,d0
        rts
.bad:
        moveq   #-7,d0
        rts

qzr_make_record:
        lea     qzr_record(pc),a0
        move.l  #$515a5232,(a0)+
        move.l  #qzr_game_id,(a0)+
        move.w  #3,(a0)+
        move.w  #mode_menu_course_count,(a0)+
        move.l  qzr_generation-state(a6),d0
        addq.l  #1,d0
        move.l  d0,(a0)+
        addq.l  #4,a0
        lea     cup_best_laps(pc),a1
        moveq   #4*mode_menu_course_count-1,d0
.laps:
        move.l  (a1)+,(a0)+
        dbra    d0,.laps
        lea     cup_best_races(pc),a1
        moveq   #mode_menu_course_count-1,d0
.races:
        move.l  (a1)+,(a0)+
        dbra    d0,.races
        lea     cup_best_deaths(pc),a1
        moveq   #mode_menu_course_count-1,d0
.death:
        move.l  (a1)+,(a0)+
        dbra    d0,.death
        lea     qzr_gp_bests(pc),a1
        moveq   #7,d0
.gp:
        move.l  (a1)+,(a0)+
        dbra    d0,.gp
        lea     qzr_record+20(pc),a0
        move.l  #qzr_record_bytes,d0
        bsr     qzr_crc32
        move.l  d0,qzr_record+16-state(a6)
        rts

cup_records_flush:
        tst.w   cup_phase-state(a6)
        beq     .done          ; strict: NEVER any I/O during racing
        cmpi.w  #11,cup_phase-state(a6)
        beq     .done          ; pause keeps the current race resident
        cmpi.w  #7,cup_phase-state(a6)
        beq     .done          ; nor during countdown
        cmpi.w  #10,cup_phase-state(a6)
        beq     .done          ; nor during the grid camera orbit
        cmpi.w  #3,cup_phase-state(a6)
        beq     .done
        bsr     qzr_update_gp
        bsr     qzr_make_record
        cmp.l   qzr_saved_crc-state(a6),d0
        beq     .done
        ; Eight opaque bottom rows, so a former menu cannot show through.
        movea.l #$27c00,a0
        moveq   #0,d0
        moveq   #3,d7
        bsr     fill_256bytes
        lea     qzr_saving_text(pc),a1
        move.w  #248,d2
        bsr     cup_center
        bsr     qzr_motor_on
        bsr     qzr_map_read
        tst.l   d0
        bne     .failed
        move.w  qzr_active_slot-state(a6),d0
        eori.w  #1,d0
        move.w  d0,qzr_slot-state(a6)
        lsl.w   #3,d0
        lea     qzr_slot_names(pc),a0
        adda.w  d0,a0
        bsr     qzr_find
        tst.l   d0
        bne     .failed
        cmpi.l  #512,qzr_file_size-state(a6)
        bne     .failed
        move.w  qzr_file-state(a6),d0
        lsl.w   #8,d0
        move.w  d0,qzr_target-state(a6)
        bsr     qzr_sector
        tst.l   d0
        bne     .failed
        ; Retain the complete 64-byte QDOS header. Only replace user data.
        lea     qzr_record(pc),a0
        lea     qzr_sector_buffer+64(pc),a1
        move.w  #(20+qzr_record_bytes)/4-1,d0
.record:
        move.l  (a0)+,(a1)+
        dbra    d0,.record
        move.w  qzr_sector_number-state(a6),qzr_write_sector-state(a6)
        move.w  #1024,qzr_attempts-state(a6)
        bsr     qzr_seek_write
        tst.l   d0
        bne     .failed
        ; MD.WRITE takes the file/block WORD at 4(SP), before the JSR.
        ; No formatting/allocation calls; the inactive fixed sector only.
        move.w  qzr_target-state(a6),-(sp)
        lea     qzr_sector_buffer(pc),a1
        lea     pc_ipcrd,a3
        movea.w $126,a4
        jsr     $4000(a4)
        addq.l  #2,sp
        move.w  #1024,qzr_attempts-state(a6)
        bsr     qzr_seek_write
        tst.l   d0
        bne.s   .failed
        lea     qzr_sector_buffer(pc),a1
        lea     pc_ipcrd,a3
        movea.w $128,a4
        jsr     $4000(a4)
        bra.s   .failed        ; +0: readonly, removed, bad write/checksum
        move.w  qzr_target-state(a6),d0
        tst.b   d2
        bne.s   .failed
        lsr.w   #8,d0
        cmp.b   d1,d0
        bne.s   .failed
        move.w  qzr_slot-state(a6),qzr_active_slot-state(a6)
        move.l  qzr_record+12-state(a6),qzr_generation-state(a6)
        move.l  qzr_record+16-state(a6),qzr_saved_crc-state(a6)
        move.w  #1,qzr_save_status-state(a6)
        bra.s   .off
.failed:
        move.w  #2,qzr_save_status-state(a6)
.off:
        bsr     qzr_motor_off
        bsr     qzr_clear_status
        clr.w   s_sky_horizon0(a6)
        clr.w   s_cache0(a6)
        cmpi.w  #5,cup_phase-state(a6)
        bne.s   .changed
        bsr     music_init
.changed:
        moveq   #1,d0
        rts
.done:
        moveq   #0,d0
        rts

; The illustrated selector has a persistent background. Clear only its
; reserved I/O footer when a save finishes, including a failed attempt.
qzr_clear_status:
        movea.l #$27c00,a0
        moveq   #0,d0
        moveq   #3,d7
        bra     fill_256bytes

; Search header only. No data read: preserve the prepared sector buffer.
; Identity checked again immediately before writing/verifying the exact slot.
qzr_seek_write:
.scan:
        subq.w  #1,qzr_attempts-state(a6)
        bmi.s   .bad
        lea     qzr_header(pc),a1
        lea     pc_ipcrd,a3
        movea.w $12a,a4
        jsr     $4000(a4)
        bra.s   .bad
        bra.s   .scan
        lea     qzr_header+2(pc),a0
        lea     qzr_medium(pc),a1
        moveq   #11,d0
.identity:
        cmpm.b  (a0)+,(a1)+
        bne.s   .bad
        dbra    d0,.identity
        cmp.w   qzr_write_sector-state(a6),d7
        bne.s   .scan
        moveq   #0,d0
        rts
.bad:
        moveq   #-7,d0
        rts

; Best COMPLETED GP per difficulty: points, rank, stars, wins (4 WORDs).
qzr_update_gp:
        cmpi.w  #2,cup_phase-state(a6)
        bne.s   .done
        tst.w   cup_mode-state(a6)
        bne.s   .done
        move.w  cup_difficulty-state(a6),d0
        lsl.w   #3,d0
        lea     qzr_gp_bests(pc),a0
        adda.w  d0,a0
        move.w  cup_scores-state(a6),d0
        cmp.w   (a0),d0
        blo.s   .done
        bhi.s   .record
        tst.w   2(a0)
        beq.s   .record
        move.w  cup_places-state(a6),d1
        ; Overall rank comes from cup_order, not the final race position.
        bsr.s   qzr_gp_rank
        cmp.w   2(a0),d1
        bhi.s   .done
        blo.s   .record
        move.w  cup_stars-state(a6),d1
        cmp.w   4(a0),d1
        bls.s   .done
.record:
        move.w  d0,(a0)
        bsr.s   qzr_gp_rank
        move.w  d1,2(a0)
        move.w  cup_stars-state(a6),4(a0)
        move.w  cup_wins-state(a6),6(a0)
.done:
        rts
qzr_gp_rank:
        moveq   #1,d1
        tst.w   cup_order-state(a6)
        beq.s   .done
        addq.w  #1,d1
        tst.w   cup_order+2-state(a6)
        beq.s   .done
        addq.w  #1,d1
.done:
        rts

cup_records_enter:
        move.w  cup_course-state(a6),qzr_view_course-state(a6)
        move.w  #8,cup_phase-state(a6)
        move.w  #1,cup_dirty-state(a6)
        bsr     cup_draw_records
        clr.w   cup_dirty-state(a6)
        moveq   #1,d0
        rts
cup_records_frame:
        btst    #0,d0
        bne.s   .exit
        move.w  qzr_view_course-state(a6),d1
        btst    #2,d0
        beq.s   .down
        subq.w  #1,d1
.down:
        btst    #7,d0
        beq.s   .wrap
        addq.w  #1,d1
.wrap:
        tst.w   d1
        bpl.s   .limit
        moveq   #mode_menu_course_count-1,d1
.limit:
        cmpi.w  #mode_menu_course_count,d1
        blo.s   .changed
        moveq   #0,d1
.changed:
        cmp.w   qzr_view_course-state(a6),d1
        beq.s   .draw
        move.w  d1,qzr_view_course-state(a6)
        move.w  #1,cup_dirty-state(a6)
.draw:
        tst.w   cup_dirty-state(a6)
        beq.s   .done
        bsr     cup_draw_records
        clr.w   cup_dirty-state(a6)
.done:
        moveq   #1,d0
        rts
.exit:
        move.w  #5,cup_phase-state(a6)
        move.w  #1,cup_dirty-state(a6)
        bsr     cup_draw_menu
        clr.w   cup_dirty-state(a6)
        bra.s   .done

cup_draw_records:
        bsr     menu_reset
        cmpi.w  #4,s_music_bank(a6)
        beq.s   .music_ready
        bsr     music_stop
        move.w  #4,s_music_bank(a6)
        bsr     music_init
.music_ready:
        move.l  #$20000,s_page(a6)
        move.b  #8,mc_stat
        movea.l #$20000,a0
        moveq   #0,d0
        moveq   #127,d7
        bsr     fill_256bytes
        lea     qzr_records_title(pc),a1
        moveq   #12,d2
        bsr     cup_center
        move.w  qzr_view_course-state(a6),d0
        mulu.w  #24,d0
        lea     qzr_course_names(pc),a1
        adda.w  d0,a1
        moveq   #36,d2
        bsr     cup_center
        lea     qzr_time_columns(pc),a1
        moveq   #56,d2
        bsr     cup_center
        moveq   #0,d6
.times:
        lea     qzr_mode_labels(pc),a0
        move.w  d6,d0
        lsl.w   #3,d0
        adda.w  d0,a0
        lea     qzr_time_line(pc),a1
        move.l  (a0)+,(a1)+
        move.l  (a0),(a1)
        lea     qzr_time_line+9(pc),a1
        moveq   #0,d0
        move.w  qzr_view_course-state(a6),d1
        lsl.w   #2,d1
        cmpi.w  #1,d6
        bne.s   .death_time
        lea     cup_best_races(pc),a0
        move.l  0(a0,d1.w),d0
.death_time:
        cmpi.w  #3,d6
        bne.s   .format_total
        lea     cup_best_deaths(pc),a0
        move.l  0(a0,d1.w),d0
.format_total:
        bsr     qzr_time
        lea     qzr_time_line+19(pc),a1
        moveq   #0,d0
        cmpi.w  #3,d6
        beq.s   .format_lap
        move.w  d6,d1
        mulu.w  #mode_menu_course_count,d1
        add.w   qzr_view_course-state(a6),d1
        lsl.w   #2,d1
        lea     cup_best_laps(pc),a0
        move.l  0(a0,d1.w),d0
.format_lap:
        bsr     qzr_time
        lea     qzr_time_line(pc),a1
        move.w  d6,d2
        mulu.w  #16,d2
        addi.w  #72,d2
        bsr     cup_center
        addq.w  #1,d6
        cmpi.w  #4,d6
        blo     .times
        lea     qzr_gp_title(pc),a1
        move.w  #144,d2
        bsr     cup_center
        moveq   #0,d6
.gp:
        move.w  d6,d0
        lsl.w   #3,d0
        lea     qzr_level_labels(pc),a0
        adda.w  d0,a0
        lea     qzr_gp_line(pc),a1
        move.l  (a0)+,(a1)+
        move.l  (a0),(a1)
        move.w  d6,d0
        lsl.w   #3,d0
        lea     qzr_gp_bests(pc),a0
        adda.w  d0,a0
        tst.w   2(a0)
        bne.s   .has_gp
        move.b  #'-',qzr_gp_line+10-state(a6)
        move.b  #'-',qzr_gp_line+11-state(a6)
        move.b  #'-',qzr_gp_line+12-state(a6)
        move.b  #'-',qzr_gp_line+21-state(a6)
        move.b  #'-',qzr_gp_line+26-state(a6)
        clr.b   qzr_gp_line+27-state(a6)
        bra.s   .gp_line_ready
.has_gp:
        move.w  (a0),d0
        lea     qzr_gp_line+10(pc),a1
        bsr     format_three
        move.w  2(a0),d0
        addi.b  #'0',d0
        move.b  d0,qzr_gp_line+21-state(a6)
        move.w  4(a0),d0
        lea     qzr_gp_line+25(pc),a1
        bsr     cup_format_stars
.gp_line_ready:
        lea     qzr_gp_line(pc),a1
        move.w  d6,d2
        mulu.w  #16,d2
        addi.w  #160,d2
        bsr     cup_center
        addq.w  #1,d6
        cmpi.w  #4,d6
        blo     .gp
        lea     qzr_status_session(pc),a1
        tst.w   qzr_save_status-state(a6)
        beq.s   .status
        lea     qzr_status_saved(pc),a1
        cmpi.w  #1,qzr_save_status-state(a6)
        beq.s   .status
        lea     qzr_status_failed(pc),a1
.status:
        move.w  #228,d2
        bsr     cup_center
        lea     qzr_records_footer(pc),a1
        move.w  #240,d2
        bra     cup_center

qzr_time:
        bsr     cup_blank_time
        tst.l   d0
        beq.s   .done
        bsr     cup_format_time
.done:
        rts

        even
qzr_records_hint: dc.b 'CTRL: RECORDS',0
qzr_records_title: dc.b 'PLAYER RECORDS',0
qzr_time_columns: dc.b 'MODE       TOTAL    BEST LAP',0
qzr_mode_labels: dc.b 'GP      ','TIME    ','PRACTICE','DEATH   '
qzr_level_labels: dc.b 'NOVICE  ','STANDARD','EXPERT  ','MASTER  '
        even
qzr_time_line: dc.b '         --:--.--  --:--.--',0
qzr_gp_title: dc.b 'BEST CUP: POINTS / RANK / STARS',0
        even
qzr_gp_line: dc.b '          000 PTS  P 0   * 0',0
qzr_records_footer: dc.b 'UP/DOWN: COURSE',0
qzr_status_session: dc.b 'MDV1 RECORDS LOADED',0
qzr_status_saved: dc.b 'RECORDS SAVED ON MDV1',0
qzr_status_failed: dc.b 'SAVE FAILED - SESSION ONLY',0
qzr_saving_text: dc.b 'SAVING RECORDS...',0
        even
qzr_slot_names: dc.b 'score_a',0,'score_b',0
qzr_active_slot: dc.w 0
qzr_slot: dc.w 0
qzr_have_records: dc.w 0
qzr_save_status: dc.w 0
qzr_view_course: dc.w 0
qzr_write_sector: dc.w 0
qzr_generation: dc.l 0
qzr_saved_crc: dc.l 0
qzr_gp_bests: dcb.w 16,0
qzr_record: dcb.b 20+qzr_record_bytes,0
