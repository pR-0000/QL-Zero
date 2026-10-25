; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; All durations count 50 Hz physics steps, independent of render cadence.
message_tick:
        tst.w   s_message_ticks(a6)
        beq.s   .done
        subq.w  #1,s_message_ticks(a6)
        bne.s   .done
        clr.w   s_message(a6)
.done:
        rts

; Called after terrain tracking, eight ticks apart. A nearest waypoint can
; be AHEAD of a corner: require clearly backward velocity on BOTH adjacent
; segments. Sideways drift, a recent rebound and a stationary craft are safe.
wrong_way_tick:
        tst.w   s_dead(a6)
        bne     .right_way
        tst.w   s_hit_ticks(a6)
        bne     .right_way
        tst.w   s_offroad(a6)
        bne     .right_way
        move.w  s_vx(a6),d0
        bpl.s   .vx_abs
        neg.w   d0
.vx_abs:
        move.w  s_vy(a6),d1
        bpl.s   .vy_abs
        neg.w   d1
.vy_abs:
        add.w   d1,d0
        cmpi.w  #32,d0
        blo     .right_way
        movea.l a6,a0
        adda.l  #track_buffer-state+track_path_offset,a0
        move.w  s_player_section(a6),d7
        lsl.w   #2,d7
        move.w  d7,d0
        subq.w  #4,d0
        andi.w  #255,d0
        move.w  0(a0,d7.w),d1
        sub.w   0(a0,d0.w),d1
        move.w  2(a0,d7.w),d2
        sub.w   2(a0,d0.w),d2
        bsr     .backwards
        tst.w   d0
        beq.s   .right_way
        move.w  d7,d0
        addq.w  #4,d0
        andi.w  #255,d0
        move.w  0(a0,d0.w),d1
        sub.w   0(a0,d7.w),d1
        move.w  2(a0,d0.w),d2
        sub.w   2(a0,d7.w),d2
        bsr     .backwards
        tst.w   d0
        beq.s   .right_way
        addq.w  #8,s_wrong_ticks(a6)
        cmpi.w  #64,s_wrong_ticks(a6)
        blo.s   .done
        move.w  #64,s_wrong_ticks(a6)
        tst.w   s_message(a6)
        beq.s   .warn
        cmpi.w  #3,s_message(a6)
        bne.s   .done
.warn:
        move.w  #3,s_message(a6)
        move.w  #75,s_message_ticks(a6)
        rts
.right_way:
        clr.w   s_wrong_ticks(a6)
        cmpi.w  #3,s_message(a6)
        bne.s   .done
        clr.w   s_message(a6)
        clr.w   s_message_ticks(a6)
.done:
        rts
; D1/D2 tangent. A negative dot alone accepts almost perpendicular drift.
; Require -dot > (|DX|+|DY|)*(|VX|+|VY|)/4, without angle/division tables.
; D0 boolean; A0 and D7 retain the path/waypoint for the other segment.
.backwards:
        move.w  d1,d3
        bpl.s   .dx_abs
        neg.w   d3
.dx_abs:
        move.w  d2,d4
        bpl.s   .dy_abs
        neg.w   d4
.dy_abs:
        add.w   d4,d3
        move.w  d3,d5
        muls.w  s_vx(a6),d1
        muls.w  s_vy(a6),d2
        add.l   d2,d1
        bpl.s   .no
        neg.l   d1
        move.w  s_vx(a6),d3
        bpl.s   .speed_x
        neg.w   d3
.speed_x:
        move.w  s_vy(a6),d4
        bpl.s   .speed_y
        neg.w   d4
.speed_y:
        add.w   d4,d3
        mulu.w  d3,d5
        lsr.l   #2,d5
        cmp.l   d5,d1
        bls.s   .no
        moveq   #1,d0
        rts
.no:
        moveq   #0,d0
        rts

draw_race_message:
        cmpi.w  #6,s_message(a6)
        bne.s   .normal_message
        tst.w   s_dead(a6)
        bne.s   .normal_message
        lea     cup_machine_down(pc),a1
        move.w  #232,d2
        bra     cup_center
.normal_message:
        tst.w   s_dead(a6)
        bne.s   .lost
        move.w  s_message(a6),d0
        beq     .done
        subq.w  #1,d0
        lsl.w   #2,d0
        lea     message_compiled(pc),a2
        move.w  0(a2,d0.w),d5
        moveq   #0,d1
        move.b  2(a2,d0.w),d1
        lea     0(a2,d5.w),a1
        movem.l d1/a1,-(sp)
        moveq   #11,d7
        bsr     message_panel
        movem.l (sp)+,d1/a1
        movea.l s_page(a6),a0
        adda.w  #232*128,a0
        adda.w  d1,a0
        lea     font_decode(pc),a2
        moveq   #7,d7
.compiled_row:
        movea.l a0,a3
        moveq   #0,d0
        move.b  (a1)+,d0
        adda.w  d0,a0
        moveq   #0,d6
        move.b  (a1)+,d6
        subq.w  #1,d6
        bmi.s   .compiled_next
.compiled_word:
        moveq   #0,d0
        move.b  (a1)+,d0
        move.l  0(a2,d0.w),(a0)+
        dbra    d6,.compiled_word
.compiled_next:
        lea     128(a3),a0
        bsr     poll_clock
        dbra    d7,.compiled_row
        rts
.lost:
        moveq   #11,d7           ; three lines, y180..219
        bsr.s   message_panel
        lea     too_bad_text(pc),a1
        moveq   #48,d1
        move.w  #228,d2
        moveq   #8,d4
        bsr     draw_text
        lea     machine_lost_text(pc),a1
        moveq   #22,d1
        move.w  #238,d2
        moveq   #21,d4
        bsr     draw_text
.done:
        rts

message_panel:
        move.w  #224,d0
.top_ready:
        lsl.w   #7,d0
        move.w  d0,-(sp)
        movea.l s_page(a6),a0
        adda.w  d0,a0
        moveq   #0,d0
        bsr     fill_256bytes
        ; White frame top/bottom; vertical edges are one native word wide.
        movea.l s_page(a6),a0
        adda.w  (sp)+,a0
        move.w  #23,d7
.height_ready:
        move.w  d7,d6
        lsl.w   #7,d6
        lea     0(a0,d6.w),a1
        move.l  #$aaffaaff,d0
        moveq   #31,d6
.horizontal:
        move.l  d0,(a0)+
        move.l  d0,(a1)+
        dbra    d6,.horizontal
        subq.w  #2,d7
.vertical:
        move.w  #$aaff,(a0)
        move.w  #$aaff,126(a0)
        adda.w  #128,a0
        dbra    d7,.vertical
        rts

too_bad_text: dc.b 'Too bad!',0
machine_lost_text: dc.b 'You lost your machine.',0
        even
        include "data/messages_compiled.inc"
