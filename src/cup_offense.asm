; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Local counterattacks in Standard; proactive side attacks in Expert/Master.
; No extra collision scan, path search, or drawing pass.
cup_offense_tick:
        tst.w   s_opponents(a6)
        beq.s   .inactive
        movem.l d0-d1/a0,-(sp)
        lea     cup_npc_attack(pc),a0
        moveq   #1,d1
.pilot:
        tst.w   (a0)
        beq.s   .cooldown
        subq.w  #1,(a0)
.cooldown:
        tst.w   4(a0)
        beq.s   .next
        subq.w  #1,4(a0)
.next:
        addq.l  #2,a0
        dbra    d1,.pilot
        movem.l (sp)+,d0-d1/a0
.inactive:
        rts

; D7 NPC, A3 physics, A4 craft, D2 pursuit controls. Called at 12.5 Hz.
cup_ai_attack:
        movem.l d0-d1/d3-d6/a0-a1,-(sp)
        move.w  d7,d3
        add.w   d3,d3
        lea     cup_npc_attack(pc),a0
        tst.w   0(a0,d3.w)
        bne     .active
        tst.w   4(a0,d3.w)
        bne     .done
        tst.w   s_dead(a6)
        bne     .done
        tst.w   cup_finishing-state(a6)
        bne     .done
        tst.w   cup_difficulty-state(a6)
        beq     .done
        cmpi.w  #2,cup_difficulty-state(a6)
        bhs.s   .proactive
        lea     s_npc_damage(a6),a1
        tst.w   0(a1,d3.w)
        beq     .done             ; Standard retaliates only after a hit
.proactive:
        move.w  d2,d0
        andi.w  #$92,d0
        bne     .done             ; never launch during a tight bend
        cmpi.w  #48,(a3)
        blo     .done
        cmpi.w  #48,s_speed(a6)
        blo     .done
        move.w  14(a4),d0
        sub.w   s_angle(a6),d0
        addi.w  #128,d0
        andi.w  #255,d0
        subi.w  #128,d0
        addi.w  #12,d0
        cmpi.w  #24,d0
        bhi     .done
        move.w  s_x(a6),d4
        sub.w   4(a4),d4
        move.w  d4,d5
        bpl.s   .x
        neg.w   d5
.x:
        cmpi.w  #640,d5
        bhs     .done
        move.w  s_y(a6),d5
        sub.w   6(a4),d5
        move.w  d5,d6
        bpl.s   .y
        neg.w   d6
.y:
        cmpi.w  #640,d6
        bhs     .done
        asr.w   #4,d4
        asr.w   #4,d5
        move.w  d4,d0
        bsr.s   .clamp
        add.w   d0,8(a4)
        move.w  d5,d0
        bsr.s   .clamp
        add.w   d0,10(a4)
        move.w  #32,0(a0,d3.w)
        move.w  #300,d0
        cmpi.w  #2,cup_difficulty-state(a6)
        blo.s   .delay
        move.w  #225,d0
        cmpi.w  #3,cup_difficulty-state(a6)
        blo.s   .delay
        move.w  #175,d0
.delay:
        move.w  d0,4(a0,d3.w)
.active:
        moveq   #4,d2             ; keep normal throttle and inertia
        lea     cup_npc_boost(pc),a1
        clr.w   0(a1,d3.w)
.done:
        movem.l (sp)+,d0-d1/d3-d6/a0-a1
        rts
.clamp:
        cmpi.w  #16,d0
        ble.s   .negative
        moveq   #16,d0
.negative:
        cmpi.w  #-16,d0
        bge.s   .return
        moveq   #-16,d0
.return:
        rts

; Keep existing sprite orientation: no attack-time sprite decompression.
cup_npc_attack_tint:
        tst.w   d0
        beq.s   .damage_ready
        moveq   #1,d0          ; the legacy caller can pass raw flash ticks
.damage_ready:
        movem.l d1/a0,-(sp)
        move.w  d7,d1
        lsr.w   #1,d1
        lea     cup_npc_attack(pc),a0
        tst.w   0(a0,d1.w)
        beq.s   .done
        btst    #2,s_ticks+1(a6)
        bne.s   .done
        moveq   #9,d0
.done:
        movem.l (sp)+,d1/a0
        rts

; Use the existing contact/damage pass; no additional collision search.
cup_enemy_damage:
        movem.l d1/a0,-(sp)
        move.w  d7,d1
        add.w   d1,d1
        lea     cup_npc_attack(pc),a0
        moveq   #16,d0
        tst.w   0(a0,d1.w)
        beq.s   .done
        moveq   #32,d0
.done:
        movem.l (sp)+,d1/a0
        rts

cup_npc_attack: dcb.w 2,0
cup_npc_attack_delay: dcb.w 2,0
