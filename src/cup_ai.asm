; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Initial grid depends on difficulty; Master always puts the player last.
; Other GP rounds reverse the last finish order. All pilots precede the line.
cup_grid:
        move.w  s_x(a6),d5
        move.w  s_y(a6),d6
        moveq   #0,d7
.pilot:
        move.w  d7,d4
        tst.w   cup_mode-state(a6)
        bne.s   .slot
        cmpi.w  #3,cup_difficulty-state(a6)
        beq.s   .initial
        tst.w   cup_round-state(a6)
        beq.s   .initial
        move.w  d7,d0
        add.w   d0,d0
        lea     cup_last_places(pc),a0
        moveq   #3,d4
        sub.w   0(a0,d0.w),d4
        bra.s   .slot
.initial:
        move.w  cup_difficulty-state(a6),d4
        cmpi.w  #2,d4
        bls.s   .level
        moveq   #2,d4
.level:
        tst.w   d7
        beq.s   .slot
        cmpi.w  #1,d7
        bne.s   .last_npc
        tst.w   d4
        beq.s   .npc_second
        moveq   #0,d4
        bra.s   .slot
.npc_second:
        moveq   #1,d4
        bra.s   .slot
.last_npc:
        cmpi.w  #2,d4
        beq.s   .npc_second
        moveq   #2,d4
.slot:
        move.w  d7,d0
        add.w   d0,d0
        lea     cup_grid_slots(pc),a0
        move.w  d4,0(a0,d0.w)
        lsl.w   #8,d4
        add.w   d4,d4
        addi.w  #384,d4         ; 1.5, 3.5, 5.5 units behind start
        move.w  s_angle(a6),d0
        add.w   d0,d0
        lea     direction_x-state(a6),a0
        move.w  0(a0,d0.w),d1
        muls.w  d4,d1
        asr.l   #8,d1
        neg.w   d1
        add.w   d5,d1
        lea     direction_y-state(a6),a0
        move.w  0(a0,d0.w),d2
        muls.w  d4,d2
        asr.l   #8,d2
        neg.w   d2
        add.w   d6,d2
        ; Alternate lanes by rank: first/third left, second right. The
        ; perpendicular offset is 1.5 units; longitudinal slots stay intact.
        lea     cup_grid_slots(pc),a0
        move.w  d7,d3
        add.w   d3,d3
        move.w  0(a0,d3.w),d3
        andi.w  #1,d3
        move.w  #-384,d4
        tst.w   d3
        beq.s   .lane
        move.w  #384,d4
.lane:
        lea     direction_y-state(a6),a0
        move.w  0(a0,d0.w),d3
        muls.w  d4,d3
        asr.l   #8,d3
        sub.w   d3,d1
        lea     direction_x-state(a6),a0
        move.w  0(a0,d0.w),d3
        muls.w  d4,d3
        asr.l   #8,d3
        add.w   d3,d2
        tst.w   d7
        bne.s   .npc
        move.w  d1,s_x(a6)
        move.w  d2,s_y(a6)
        bra.s   .next
.npc:
        move.w  d7,d0
        subq.w  #1,d0
        lsl.w   #4,d0
        lea     s_rivals(a6),a0
        adda.w  d0,a0
        clr.w   (a0)
        move.w  d1,4(a0)
        move.w  d2,6(a0)
.next:
        addq.w  #1,d7
        cmpi.w  #3,d7
        blo     .pilot
        bsr     player_find_section
        bsr     cup_line_reset
        rts

; D7 NPC index, D0 speed, D1 cruise cap, D6 controls. No teleportation.
cup_ai_boost:
        movem.l d2-d4/a0-a2,-(sp)
        move.w  d7,d2
        add.w   d2,d2
        lea     cup_npc_attack(pc),a2
        tst.w   0(a2,d2.w)
        bne     .done
        lea     cup_npc_energy(pc),a0
        adda.w  d2,a0
        lea     cup_npc_boost(pc),a1
        adda.w  d2,a1
        lea     s_npc_damage(a6),a2
        move.w  0(a2,d2.w),d3
        lea     cup_npc_cooldown(pc),a2
        adda.w  d2,a2
        tst.w   (a2)
        beq.s   .available
        subq.w  #1,(a2)
.available:
        tst.w   d3
        beq.s   .safe
        clr.w   (a1)
        bra.s   .done
.safe:
        tst.w   (a1)
        bne.s   .active
        tst.w   (a2)
        bne.s   .done
        cmpi.w  #3,cup_mode-state(a6)
        beq.s   .boost_lap
        lea     cup_npc_laps(pc),a2
        tst.w   0(a2,d2.w)
        beq.s   .done
.boost_lap:
        cmpi.w  #64,(a0)
        bls.s   .done
        move.w  d6,d3
        andi.w  #$92,d3         ; no steering/braking while launching boost
        bne.s   .done
        btst    #2,d6
        beq.s   .done
        cmpi.w  #60,(a3)
        blo.s   .done
        subi.w  #32,(a0)
        move.w  #40,(a1)
        lea     cup_npc_cooldown(pc),a2
        move.l  a0,-(sp)
        lea     cup_difficulty_boost(pc),a0
        move.w  cup_difficulty-state(a6),d3
        cmpi.w  #3,cup_mode-state(a6)
        bne.s   .boost_level
        moveq   #1,d3
.boost_level:
        add.w   d3,d3
        move.w  0(a0,d3.w),0(a2,d2.w)
        movea.l (sp)+,a0
.active:
        subq.w  #1,(a1)
        addq.w  #2,d0
        move.w  #112,d1
.done:
        movem.l (sp)+,d2-d4/a0-a2
        rts

cup_ai_repair:
        btst    #6,d4           ; same pink map cells as player recharge
        beq.s   .done
        move.l  a0,-(sp)
        move.w  d7,d0
        add.w   d0,d0
        lea     cup_npc_energy(pc),a0
        cmpi.w  #253,0(a0,d0.w)
        bhs.s   .full
        addq.w  #2,0(a0,d0.w)
        bra.s   .restore
.full:
        move.w  #255,0(a0,d0.w)
.restore:
        movea.l (sp)+,a0
.done:
        rts

; HUD progress: validated lap, nearby path node, distance to next node.
; D7=pilot; signed D0 increases around track. Gates disambiguate the line.
cup_progress:
        movem.l d1-d6/a0-a2,-(sp)
        move.w  s_player_section(a6),d4
        move.w  s_x(a6),d1
        move.w  s_y(a6),d2
        move.w  s_laps(a6),d5
        move.w  s_gate(a6),d6
        tst.w   d7
        beq.s   .path
        move.w  d7,d0
        subq.w  #1,d0
        move.w  d0,d3
        add.w   d3,d3
        lea     cup_npc_laps(pc),a0
        move.w  0(a0,d3.w),d5
        lea     cup_npc_gates(pc),a0
        move.w  0(a0,d3.w),d6
        lea     cup_npc_dead(pc),a0
        tst.w   0(a0,d3.w)
        beq.s   .live_progress
        move.l  #-$100000,d0
        bra     .done_progress
.live_progress:
        lsl.w   #4,d0
        lea     s_rivals(a6),a0
        adda.w  d0,a0
        move.w  (a0),d4
        lsr.w   #8,d4
        move.w  4(a0),d1
        move.w  6(a0),d2
.path:
        movea.l a6,a0
        adda.l  #track_buffer-state+track_path_offset,a0
        subq.w  #1,d4
        move.w  #32767,a1
        moveq   #2,d3
.nearest:
        move.w  d4,d0
        andi.w  #63,d0
        lsl.w   #2,d0
        move.w  0(a0,d0.w),a2
        suba.w  d1,a2
        move.w  a2,d0
        bpl.s   .x
        neg.w   d0
.x:
        move.w  d0,-(sp)
        move.w  d4,d0
        andi.w  #63,d0
        lsl.w   #2,d0
        move.w  2(a0,d0.w),d0
        sub.w   d2,d0
        bpl.s   .y
        neg.w   d0
.y:
        add.w   (sp)+,d0
        cmp.w   a1,d0
        bhs.s   .next
        move.w  d0,a1
        move.w  d4,a2
        move.w  a2,cup_progress_node-state(a6)
.next:
        addq.w  #1,d4
        dbra    d3,.nearest
        move.w  cup_progress_node-state(a6),d4
        andi.w  #63,d4
        move.w  d4,d0
        addq.w  #1,d0
        andi.w  #63,d0
        lsl.w   #2,d0
        move.w  0(a0,d0.w),d3
        sub.w   d1,d3
        bpl.s   .nx
        neg.w   d3
.nx:
        move.w  2(a0,d0.w),d0
        sub.w   d2,d0
        bpl.s   .ny
        neg.w   d0
.ny:
        add.w   d3,d0
        lsr.w   #3,d0
        cmpi.w  #511,d0
        bls.s   .distance
        move.w  #511,d0
.distance:
        cmpi.w  #1,d6
        bne.s   .finish_gate
        cmpi.w  #48,d4
        blo.s   .index
        tst.w   d5
        beq.s   .before_start
        clr.w   d4
        bra.s   .index
.before_start:
        subi.w  #64,d4
        bra.s   .index
.finish_gate:
        tst.w   d6
        bne.s   .index
        tst.w   d4
        bne.s   .index
        moveq   #63,d4
.index:
        lsl.w   #6,d5
        add.w   d5,d4
        ext.l   d4
        lsl.l   #8,d4
        add.l   d4,d4
        ext.l   d0
        sub.l   d0,d4
        move.l  d4,d0
.done_progress:
        movem.l (sp)+,d1-d6/a0-a2
        rts
