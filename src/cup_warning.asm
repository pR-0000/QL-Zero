; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Cached 26x22 rear threat indicator. Runs with the 10 Hz HUD, never physics.
; World coordinates are 8.8. Two NPCs or the shared TA ghost pose.
; No second interpolation, search/path/square root or extra sprite pass.
; Wider approach corridor; the axis box must also cover its rotated corners.
cup_check_rear_range equ 10*256
cup_check_side_range equ 3*256
cup_check_axis_range equ 11*256
cup_check_near_gap   equ 32
cup_rear_warning:
        movem.l d0-d7/a0-a3,-(sp)
        moveq   #0,d7
        tst.w   s_message(a6)
        bne     .covered
        tst.w   s_dead(a6)
        bne     .covered
        tst.w   cup_phase-state(a6)
        bne     .key
        tst.w   cup_finishing-state(a6)
        bne     .key
        tst.w   s_started(a6)
        beq     .key
        lea     s_rivals(a6),a2
        lea     cup_npc_dead-state(a6),a3
        moveq   #1,d4
        tst.w   s_opponents(a6)
        bne.s   .directions
        cmpi.w  #1,cup_mode-state(a6)
        bne     .key
        cmpi.w  #1,ghost_active-state(a6)
        bne     .key
        ; Waiting ghosts are absent; an active ghost uses one threat record.
        lea     ghost_wait_start-state(a6),a3
        moveq   #0,d4
.directions:
        move.w  s_angle(a6),d0
        add.w   d0,d0
        lea     direction_x-state(a6),a0
        move.w  0(a0,d0.w),d5
        lea     direction_y-state(a6),a0
        move.w  0(a0,d0.w),d6
.pilot:
        tst.w   (a3)+
        bne     .next
        move.w  14(a2),d0
        sub.w   s_angle(a6),d0
        addi.w  #48,d0
        andi.w  #255,d0
        cmpi.w  #96,d0
        bhi     .next          ; ignore the opposite side of a hairpin
        move.w  4(a2),d1
        sub.w   s_x(a6),d1
        cmpi.w  #-cup_check_axis_range,d1
        blt     .next
        cmpi.w  #cup_check_axis_range,d1
        bgt     .next
        move.w  6(a2),d2
        sub.w   s_y(a6),d2
        cmpi.w  #-cup_check_axis_range,d2
        blt     .next
        cmpi.w  #cup_check_axis_range,d2
        bgt     .next
        move.w  d1,d0
        muls.w  d5,d0
        move.w  d2,d3
        muls.w  d6,d3
        add.l   d3,d0
        cmpi.l  #-cup_check_rear_range*256,d0
        blt.s   .next
        cmpi.l  #-cup_check_near_gap*256,d0
        bgt.s   .next          ; genuinely behind, not alongside
        muls.w  d6,d1
        muls.w  d5,d2
        sub.l   d1,d2
        cmpi.l  #-cup_check_side_range*256,d2
        blt.s   .next
        cmpi.l  #cup_check_side_range*256,d2
        bgt.s   .next
        moveq   #1,d7
        btst    #4,s_ticks+1(a6)
        beq.s   .key
        moveq   #2,d7
        bra.s   .key
.next:
        adda.w  #16,a2
        dbra    d4,.pilot
.key:
        cmp.w   cup_check_cache-state(a6),d7
        beq.s   .done
        move.w  d7,cup_check_cache-state(a6)
        movea.l s_page(a6),a0
        adda.w  #226*128+56,a0 ; central bottom tile; no map/speed overlap
        lea     cup_check_red(pc),a1
        moveq   #21,d3
        moveq   #0,d4
        cmpi.w  #2,d7
        bne.s   .row
        move.l  #$ff00ff00,d4
.row:
        moveq   #2,d2
.long:
        moveq   #0,d0
        tst.w   d7
        beq.s   .store
        move.l  (a1)+,d0
        move.l  d0,d1
        lsl.l   #8,d1
        and.l   d4,d1
        or.l    d1,d0
.store:
        move.l  d0,(a0)+
        dbra    d2,.long
        moveq   #0,d0
        tst.w   d7
        beq.s   .tail
        move.w  (a1)+,d0
        move.w  d0,d1
        lsl.w   #8,d1
        and.w   d4,d1
        or.w    d1,d0
.tail:
        move.w  d0,(a0)+
        adda.w  #114,a0
        dbra    d3,.row
        bra.s   .done
.covered:
        ; Messages already clear/draw rows 224..247. Forget the icon rather
        ; than erase text. The complete tile fits inside those cleared rows.
        clr.w   cup_check_cache-state(a6)
.done:
        movem.l (sp)+,d0-d7/a0-a3
        rts

cup_check_cache: dc.w 0
        include "data/cup_check.inc"
