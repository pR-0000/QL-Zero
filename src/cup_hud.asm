; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Compact F-Zero-style HUD. Native MODE8 bytes for X, pixel rows for Y.
cup_hud_static:
        move.w  #-1,cup_hud_cache+14-state(a6)
        lea     cup_lap_text(pc),a1
        moveq   #2,d1
        moveq   #2,d2
        moveq   #7,d4
        bsr     draw_text
        lea     cup_rank_text(pc),a1
        moveq   #56,d1
        bsr     draw_text
        lea     cup_energy_text(pc),a1
        moveq   #92,d1
        moveq   #6,d4
        bsr     draw_text
        rts

cup_update_hud:
        cmpi.w  #-1,cup_hud_cache-state(a6)
        beq.s   .draw
        move.w  s_ticks(a6),d0
        sub.w   cup_hud_cache-state(a6),d0
        cmpi.w  #5,d0
        blo     .done
.draw:
        move.w  s_ticks(a6),cup_hud_cache-state(a6)
        bsr     cup_hud_draw
.done:
        rts

cup_hud_draw:
        cmpi.w  #3,cup_mode-state(a6)
        bne.s   .lap_count
        moveq   #0,d0
        tst.w   cup_npc_dead-state(a6)
        beq.s   .second
        addq.w  #1,d0
.second:
        tst.w   cup_npc_dead+2-state(a6)
        beq.s   .kills
        addq.w  #1,d0
.kills:
        addi.b  #'0',d0
        move.b  d0,cup_ko_text+4-state(a6)
        lea     cup_ko_text(pc),a1
        moveq   #2,d1
        moveq   #2,d2
        moveq   #7,d4
        bsr     draw_text
        bra     .position
.lap_count:
        move.w  s_laps(a6),d0
        addq.w  #1,d0
        cmpi.w  #3,d0
        bls.s   .lap
        moveq   #3,d0
.lap:
        cmpi.w  #2,cup_mode-state(a6)
        bne.s   .numbered
        lea     cup_free_text(pc),a1
        moveq   #2,d1
        moveq   #2,d2
        moveq   #7,d4
        bsr     draw_text
        bra.s   .position
.numbered:
        cmp.w   cup_hud_cache+2-state(a6),d0
        beq.s   .position
        move.w  d0,cup_hud_cache+2-state(a6)
        addi.b  #'0',d0
        move.b  d0,cup_lap_text+4-state(a6)
        lea     cup_lap_text(pc),a1
        moveq   #2,d1
        moveq   #2,d2
        moveq   #7,d4
        bsr     draw_text
.position:
        tst.w   cup_mode-state(a6)
        beq.s   .gp_position
        move.b  #'1',cup_rank_text+2-state(a6)
        moveq   #1,d6
        bra     .live
.gp_position:
        move.b  #'3',cup_rank_text+2-state(a6)
        moveq   #0,d7
        bsr     cup_progress
        move.l  d0,d5
        moveq   #1,d6
        moveq   #1,d7
.rival:
        bsr     cup_progress
        cmp.l   d5,d0
        ble.s   .next
        addq.w  #1,d6
.next:
        addq.w  #1,d7
        cmpi.w  #3,d7
        blo.s   .rival
        tst.w   cup_places-state(a6)
        beq.s   .live
        move.w  cup_places-state(a6),d6
.live:
        cmp.w   cup_hud_cache+4-state(a6),d6
        beq.s   .energy
        move.w  d6,cup_hud_cache+4-state(a6)
        addi.b  #'0',d6
        move.b  d6,cup_rank_text-state(a6)
        lea     cup_rank_text(pc),a1
        moveq   #56,d1
        moveq   #2,d2
        moveq   #3,d4
        bsr     draw_text
.energy:
        move.w  s_energy(a6),d0
        moveq   #0,d1
        cmpi.w  #32,d0
        bhi.s   .energy_key
        move.w  s_ticks(a6),d1
        andi.w  #16,d1
.energy_key:
        cmp.w   cup_hud_cache+6-state(a6),d0
        bne.s   .draw_energy
        cmp.w   cup_hud_cache+8-state(a6),d1
        beq.s   .timer
.draw_energy:
        move.w  d0,cup_hud_cache+6-state(a6)
        move.w  d1,cup_hud_cache+8-state(a6)
        lea     cup_energy_text(pc),a1
        tst.w   d1
        beq.s   .label
        lea     cup_blank_energy(pc),a1
.label:
        moveq   #92,d1
        moveq   #2,d2
        moveq   #6,d4
        bsr     draw_text
        movea.l s_page(a6),a0
        adda.w  #11*128+88,a0  ; 2 empty rows above/below the three-row gauge
        moveq   #15,d2
        move.w  s_energy(a6),d3
        addi.w  #15,d3
        lsr.w   #4,d3
        move.w  #$aa00,d1
        cmpi.w  #128,s_energy(a6)
        bhi.s   .bar
        move.w  #$aaaa,d1
        cmpi.w  #64,s_energy(a6)
        bhi.s   .bar
        move.w  #$00aa,d1
.bar:
        moveq   #0,d0
        subq.w  #1,d3
        bmi.s   .empty
        move.w  d1,d0
.empty:
        move.w  d0,(a0)
        move.w  d0,128(a0)
        move.w  d0,256(a0)
        addq.w  #2,a0
        dbra    d2,.bar
.timer:
        move.l  s_race_ticks(a6),d0
        divu.w  #50,d0
        move.w  d0,d5
        swap    d0
        add.w   d0,d0
        lea     cup_time_text+6(pc),a1
        bsr     cup_two
        moveq   #0,d0
        move.w  d5,d0
        divu.w  #60,d0
        move.l  d0,d5
        lea     cup_time_text(pc),a1
        bsr     cup_two
        move.l  d5,d0
        swap    d0
        lea     cup_time_text+3(pc),a1
        bsr     cup_two
        lea     cup_time_text(pc),a1
        moveq   #92,d1
        moveq   #16,d2
        moveq   #8,d4
        bsr     draw_text
        move.w  s_message(a6),d6
        tst.w   s_dead(a6)
        beq.s   .message
        moveq   #5,d6
.message:
        cmp.w   cup_hud_cache+10-state(a6),d6
        beq.s   .map
        move.w  d6,cup_hud_cache+10-state(a6)
        movea.l s_page(a6),a0
        adda.w  #224*128,a0
        moveq   #0,d0
        moveq   #11,d7
        bsr     fill_256bytes
        tst.w   cup_hud_cache+10-state(a6)
        beq.s   .map
        bsr     draw_race_message
.map:
        tst.w   cup_hud_cache+10-state(a6)
        bne.s   .speed
        bsr     cup_draw_map
.speed:
        bsr     cup_display_speed
        cmp.w   cup_hud_cache+12-state(a6),d0
        beq.s   .done
        move.w  d0,cup_hud_cache+12-state(a6)
        lea     cup_speed_text(pc),a1
        bsr     cup_format_speed
        lea     cup_speed_text(pc),a1
        moveq   #90,d1
        move.w  #248,d2
        moveq   #9,d4
        bsr     draw_text
.done:
        bsr     cup_ghost_status
        bra     cup_rear_warning

; D0 km/h, A1 four digits. Byte writes also support odd text addresses.
cup_format_speed:
        andi.l  #$ffff,d0
        divu.w  #1000,d0
        addi.b  #'0',d0
        move.b  d0,(a1)+
        swap    d0
        bra     format_three

; Actual ground velocity, independent of heading: floor(12*sqrt(vx^2+vy^2)).
; Eleven bounded integer steps, only during the HUD's 10 Hz refresh. No table,
; floating point, randomness or per-physics-tick cost. D0 result; D1-D4 scratch.
cup_display_speed:
        move.w  s_vx(a6),d0
        muls.w  d0,d0
        move.w  s_vy(a6),d1
        muls.w  d1,d1
        add.l   d1,d0
        cmpi.l  #15418,d0       ; saturate large collision impulses before scaling
        bhs.s   .maximum
        move.l  d0,d1
        lsl.l   #3,d1
        add.l   d1,d0
        lsl.l   #4,d0           ; squared km/h = squared velocity * 144
        moveq   #0,d2
        move.l  #$100000,d3
.sqrt:
        move.l  d2,d4
        add.l   d3,d4
        cmp.l   d4,d0
        blo.s   .skip
        sub.l   d4,d0
        lsr.l   #1,d2
        add.l   d3,d2
        bra.s   .next
.skip:
        lsr.l   #1,d2
.next:
        lsr.l   #2,d3
        bne.s   .sqrt
        move.w  d2,d0
        beq.s   .bounded        ; no downhill bonus on a stationary craft
        tst.w   s_boosting(a6)
        beq.s   .speed_limit
        tst.w   s_hills(a6)
        beq.s   .speed_limit
        moveq   #96,d1
        sub.w   s_goal_horizon(a6),d1
        ble.s   .speed_limit
        cmpi.w  #32,d1
        bls.s   .slope
        moveq   #32,d1
.slope:
        lsl.w   #2,d1
        add.w   d1,d0           ; strongest downhill boost displays 1472
.speed_limit:
        cmpi.w  #1490,d0
        bls.s   .bounded
.maximum:
        move.w  #1490,d0
.bounded:
        andi.l  #$ffff,d0
        rts

cup_two:
        andi.l  #$ffff,d0
        divu.w  #10,d0
        addi.b  #'0',d0
        move.b  d0,(a1)
        swap    d0
        addi.b  #'0',d0
        move.b  d0,1(a1)
        rts

cup_draw_map:
        movea.l cup_map-state(a6),a1
        movea.l s_page(a6),a0
        adda.w  #224*128+2,a0
        moveq   #23,d7
.row:
        move.l  (a1)+,(a0)
        move.l  (a1)+,4(a0)
        move.l  (a1)+,8(a0)
        move.l  (a1)+,12(a0)
        adda.w  #128,a0
        dbra    d7,.row
        cmpi.w  #1,cup_mode-state(a6)
        bne.s   .npc_dots
        cmpi.w  #1,ghost_active-state(a6)
        bne.s   .player_dot
        move.w  s_rivals+4(a6),d1
        move.w  s_rivals+6(a6),d2
        move.w  #$a050,d0       ; cyan ghost; magenta player remains on top
        bsr.s   cup_map_dot
        bra.s   .player_dot
.npc_dots:
        tst.w   s_opponents(a6)
        beq.s   .player_dot
        move.w  s_rivals+4(a6),d1
        move.w  s_rivals+6(a6),d2
        move.w  #$a050,d0       ; two cyan pixels, followed by transparent pair
        bsr.s   cup_map_dot
        move.w  s_rivals+20(a6),d1
        move.w  s_rivals+22(a6),d2
        move.w  #$a0a0,d0       ; yellow
        bsr.s   cup_map_dot
.player_dot:
        move.w  s_x(a6),d1
        move.w  s_y(a6),d2
        move.w  #$00f0,d0       ; player magenta, last so overlap stays readable
cup_map_dot:
        lsr.w   #8,d2
        move.w  d2,d3
        add.w   d2,d2
        add.w   d3,d2
        lsr.w   #4,d2
        cmpi.w  #22,d2
        bls.s   .y
        moveq   #22,d2
.y:
        addi.w  #224,d2
        lsl.w   #7,d2
        movea.l s_page(a6),a0
        adda.w  d2,a0
        lsr.w   #8,d1
        lsr.w   #2,d1
        andi.w  #31,d1
        move.w  d1,d3
        andi.w  #28,d1
        lsr.w   #1,d1
        addq.w  #2,d1
        adda.w  d1,a0
        move.w  #$0f0f,d2
        btst    #1,d3
        beq.s   .first
        lsr.w   #4,d0
        move.w  #$f0f0,d2
.first:
        move.w  d2,d3
        and.w   (a0),d2
        or.w    d0,d2
        move.w  d2,(a0)
        and.w   128(a0),d3
        or.w    d0,d3
        move.w  d3,128(a0)
        rts

        include "cup_warning.asm"

cup_lap_text: dc.b 'LAP 1/3',0
cup_ko_text: dc.b 'K.O 0/2',0
cup_free_text: dc.b 'FREE   ',0
cup_rank_text: dc.b '1/3',0
cup_energy_text: dc.b 'ENERGY',0
cup_blank_energy: dc.b '      ',0
cup_time_text: dc.b '00:00.00',0
cup_speed_text: dc.b '0000 KM/H',0
        even
