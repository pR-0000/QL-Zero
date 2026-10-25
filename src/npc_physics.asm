; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Pursuit controls at 12.5 Hz; the craft itself accelerates, steers and drifts
; at 50 Hz. No assignment of path coordinates to the actual position.
npc_controls:
        move.w  (a5),d1
        bsr     damp_offset
        move.w  d1,(a5)
        move.w  2(a5),d1
        bsr     damp_offset
        move.w  d1,2(a5)
        bsr     ai_position
        sub.w   4(a4),d0
        sub.w   6(a4),d1
        move.w  d0,d2
        bpl.s   .x_abs
        neg.w   d2
.x_abs:
        move.w  d1,d3
        bpl.s   .y_abs
        neg.w   d3
.y_abs:
        add.w   d3,d2
        cmpi.w  #640,d2
        blo.s   .advance
        cmpi.w  #1536,d2
        bhs.s   .aim
        ; A drifting craft may pass beside a waypoint. Test its crossing
        ; plane instead of making it turn back to hit an exact coordinate.
        movem.w d0-d1,-(sp)
        subi.w  #256,(a4)
        andi.w  #$3fff,(a4)
        bsr     ai_position
        addi.w  #256,(a4)
        andi.w  #$3fff,(a4)
        movem.w (sp)+,d4-d5
        move.w  d4,d2
        add.w   4(a4),d2
        sub.w   d0,d2
        muls.w  d4,d2
        move.w  d5,d3
        add.w   6(a4),d3
        sub.w   d1,d3
        muls.w  d5,d3
        add.l   d3,d2
        move.w  d4,d0
        move.w  d5,d1
        tst.l   d2
        bgt.s   .aim
.advance:
        addi.w  #256,(a4)
        cmpi.w  #$4000,(a4)
        blo.s   .waypoint_ready
        clr.w   (a4)
        addq.w  #1,12(a4)
.waypoint_ready:
        bsr     ai_position
        sub.w   4(a4),d0
        sub.w   6(a4),d1
.aim:
        ; Half a section of look-ahead, with four ticks of lateral drift
        ; compensation: anticipate the bend instead of braking at its apex.
        addi.w  #128,(a4)
        andi.w  #$3fff,(a4)
        bsr     ai_position
        subi.w  #128,(a4)
        andi.w  #$3fff,(a4)
        sub.w   4(a4),d0
        sub.w   6(a4),d1
        move.w  8(a4),d2
        lsl.w   #2,d2
        sub.w   d2,d0
        move.w  10(a4),d2
        lsl.w   #2,d2
        sub.w   d2,d1
        bsr     vector_angle
        sub.w   14(a4),d0
        addi.w  #128,d0
        andi.w  #255,d0
        subi.w  #128,d0
        moveq   #0,d2
        cmpi.w  #1,d0
        ble.s   .left
        moveq   #16,d2
        bra.s   .throttle
.left:
        cmpi.w  #-1,d0
        bge.s   .throttle
        moveq   #2,d2
.throttle:
        tst.w   d0
        bpl.s   .abs_turn
        neg.w   d0
.abs_turn:
        cmpi.w  #9,d0
        bhi.s   .lift
        ori.w   #4,d2
        bra.s   .ready
.lift:
        cmpi.w  #20,d0
        bls.s   .ready
        cmpi.w  #48,(a3)
        bls.s   .ready
        ori.w   #128,d2
.ready:
        bsr     cup_ai_attack
        move.w  d2,2(a3)
        rts

; Signed DX/DY -> unsigned 0..255 heading. One bounded ratio division, then
; a 65-word atan table; quadrants are exact and axes never divide by zero.
vector_angle:
        move.w  d0,d4
        move.w  d1,d5
        tst.w   d0
        bpl.s   .x_abs
        neg.w   d0
.x_abs:
        tst.w   d1
        bpl.s   .y_abs
        neg.w   d1
.y_abs:
        moveq   #0,d2
        cmp.w   d1,d0
        bhs.s   .x_major
        exg     d0,d1
        moveq   #1,d2
.x_major:
        tst.w   d0
        beq.s   .zero
        andi.l  #$ffff,d1
        lsl.l   #6,d1
        divu.w  d0,d1
        lea     atan_ratio(pc),a0
        moveq   #0,d0
        move.b  0(a0,d1.w),d0
        tst.w   d2
        beq.s   .quadrant
        moveq   #64,d1
        sub.w   d0,d1
        move.w  d1,d0
.quadrant:
        tst.w   d4
        bpl.s   .y_sign
        move.w  #128,d1
        sub.w   d0,d1
        move.w  d1,d0
.y_sign:
        tst.w   d5
        bpl.s   .zero
        neg.w   d0
        andi.w  #255,d0
.zero:
        rts

; A4 craft, A3 speed/controls/fractions/stun/pad record. Same acceleration,
; brake, steering and grip rules as the player, with easier cruising limits.
npc_physics_tick:
        move.w  (a3),d0
        move.w  2(a3),d6
        btst    #2,d6
        beq.s   .coast
        addq.w  #1,d0
        bra.s   .brake
.coast:
        btst    #0,s_ai_clock+1(a6)
        bne.s   .brake
        subq.w  #1,d0
.brake:
        btst    #7,d6
        beq.s   .limit
        subq.w  #4,d0
.limit:
        move.w  2(a4),d1
        tst.w   s_hills(a6)
        beq.s   .pad
        move.w  (a4),d2
        lsr.w   #7,d2
        lea     cup_hills-state(a6),a0
.hill_ready:
        move.w  0(a0,d2.w),d2
        beq.s   .pad
        bmi.s   .downhill
        subq.w  #4,d1
        bra.s   .pad
.downhill:
        addq.w  #4,d1
.pad:
        bsr     cup_ai_boost
        tst.w   10(a3)
        beq.s   .positive
        subq.w  #1,10(a3)
        addq.w  #2,d0
        move.w  #112,d1
.positive:
        tst.w   d0
        bpl.s   .clamp
        clr.w   d0
.clamp:
        cmp.w   d1,d0
        bls.s   .speed_ready
        move.w  d1,d0
.speed_ready:
        move.w  d0,(a3)
        moveq   #1,d3
        btst    #2,d6
        bne.s   .turn
        cmpi.w  #32,d0
        blo.s   .turn
        moveq   #2,d3
.turn:
        btst    #1,d6
        beq.s   .right
        sub.w   d3,14(a4)
.right:
        btst    #4,d6
        beq.s   .angle_ready
        add.w   d3,14(a4)
.angle_ready:
        andi.w  #255,14(a4)
        moveq   #3,d3
        btst    #2,d6
        beq.s   .brake_grip
        cmpi.w  #49,d0
        blo.s   .brake_grip
        moveq   #4,d3
        cmpi.w  #65,d0
        blo.s   .brake_grip
        moveq   #5,d3
.brake_grip:
        btst    #7,d6
        beq.s   .stun
        moveq   #2,d3
.stun:
        tst.w   8(a3)
        beq.s   .velocity
        subq.w  #1,8(a3)
        moveq   #5,d3
        cmpi.w  #25,8(a3)
        bhi.s   .move_position     ; six ballistic ticks make the rebound visible
.velocity:
        move.w  14(a4),d1
        add.w   d1,d1
        lea     direction_x-state(a6),a0
        move.w  0(a0,d1.w),d2
        muls.w  d0,d2
        asr.l   #8,d2
        sub.w   8(a4),d2
        add.w   4(a3),d2
        move.w  d2,d4
        asr.w   d3,d2
        add.w   d2,8(a4)
        lsl.w   d3,d2
        sub.w   d2,d4
        move.w  d4,4(a3)
        lea     direction_y-state(a6),a0
        move.w  0(a0,d1.w),d2
        muls.w  d0,d2
        asr.l   #8,d2
        sub.w   10(a4),d2
        add.w   6(a3),d2
        move.w  d2,d4
        asr.w   d3,d2
        add.w   d2,10(a4)
        lsl.w   d3,d2
        sub.w   d2,d4
        move.w  d4,6(a3)
.move_position:
        move.w  4(a4),d1
        add.w   8(a4),d1
        move.w  6(a4),d2
        add.w   10(a4),d2
        bsr     test_road_point
        tst.w   d0
        bne.s   .blocked
        lea     4(a4),a1
        bsr     trace_wall
        tst.w   d0
        bne.s   .blocked
        move.w  d1,4(a4)
        move.w  d2,6(a4)
        ; A0 already points at map data: read the cell without a second lookup.
        btst    #4,d4
        beq.s   .done
        move.w  #35,10(a3)
.done:
        bsr     cup_ai_repair
        rts
.blocked:
        asr.w   (a3)
        bsr     npc_wall_bounce
        clr.l   (a5)
        clr.l   4(a3)
        rts

; Use the exact player rail response for the NPC, preserving all player
; motion and terrain state. Contact is the only path doing a full reacquisition.
npc_wall_bounce:
        movem.l d7/a3-a5,-(sp)
        move.l  s_x(a6),-(sp)
        move.l  s_vx(a6),-(sp)
        move.l  s_vx_fraction(a6),-(sp)
        move.w  s_speed(a6),-(sp)
        move.w  s_hit_ticks(a6),-(sp)
        move.w  s_player_section(a6),-(sp)
        move.w  s_offroad(a6),-(sp)
        move.l  4(a4),s_x(a6)
        move.l  8(a4),s_vx(a6)
        move.w  (a3),s_speed(a6)
        bsr     wall_bounce
        move.l  s_x(a6),4(a4)
        move.l  s_vx(a6),8(a4)
        move.w  s_speed(a6),(a3)
        ; Keep the reflected velocity, but let the pilot regain normal grip
        ; after a rail. A forced 20-tick slide can trap it between two rails.
        clr.w   8(a3)
        move.w  s_player_section(a6),d0
        lsl.w   #8,d0
        move.w  d0,(a4)
        move.w  (sp)+,s_offroad(a6)
        move.w  (sp)+,s_player_section(a6)
        move.w  (sp)+,s_hit_ticks(a6)
        move.w  (sp)+,s_speed(a6)
        move.l  (sp)+,s_vx_fraction(a6)
        move.l  (sp)+,s_vx(a6)
        move.l  (sp)+,s_x(a6)
        movem.l (sp)+,d7/a3-a5
        lea     s_npc_damage(a6),a0
        move.w  d7,d0
        add.w   d0,d0
        move.w  #32,0(a0,d0.w)
        bra     cup_wall_damage
