; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Foreground selector; all its code/bitmaps are erased when race loads.
intro_menu_init:
        bsr     menu_reset
        clr.w   intro_mode-intro_state(a5)
        move.w  #1,intro_level-intro_state(a5)
        clr.w   intro_course-intro_state(a5)
        move.w  #255,intro_old_keys-intro_state(a5)
        clr.w   intro_menu_stage-intro_state(a5)
        rts

intro_menu_keys:
        movem.l d1-d7/a0-a4,-(sp)
        move.b  #1,intro_key_param-intro_state(a5)
        lea     intro_key_packet-intro_state(a5),a3
        bsr     intro_ipcom
        move.w  d0,d4
        move.b  #7,intro_key_param-intro_state(a5)
        lea     intro_key_packet-intro_state(a5),a3
        bsr     intro_ipcom
        btst    #1,d0
        beq.s   .no_ctrl
        ori.w   #256,d4
.no_ctrl:
        move.w  d4,d0
        move.w  intro_old_keys-intro_state(a5),d1
        move.w  d0,intro_old_keys-intro_state(a5)
        not.w   d1
        and.w   d1,d0
        move.w  d0,d4
        btst    #0,d4
        bne     .enter
        tst.w   intro_menu_stage-intro_state(a5)
        beq     .idle
        btst    #8,d4
        beq.s   .choose_mode
        move.l  #$515a4d4e,$27ff0
        move.w  #$0100,$27ff4
        move.w  #-2,$27ff6      ; native MDV menu opens personal records
        moveq   #1,d0
        bra     .done
.choose_mode:
        move.w  intro_mode-intro_state(a5),d2
        btst    #1,d4            ; row 1: LEFT bit 1, RIGHT bit 4
        beq.s   .right
        subq.w  #1,d2
.right:
        btst    #4,d4
        beq.s   .mode_wrap
        addq.w  #1,d2
.mode_wrap:
        bpl.s   .mode_high
        moveq   #3,d2
.mode_high:
        cmpi.w  #4,d2
        blo.s   .mode_ready
        moveq   #0,d2
.mode_ready:
        move.w  d2,intro_mode-intro_state(a5)
        lea     intro_course-intro_state(a5),a0
        moveq   #mode_menu_course_count,d3
        tst.w   d2
        bne.s   .option
        lea     intro_level-intro_state(a5),a0
        moveq   #4,d3
.option:
        move.w  (a0),d2
        btst    #2,d4
        beq.s   .down
        subq.w  #1,d2
.down:
        btst    #7,d4
        bne.s   .increment
        btst    #6,d4
        beq.s   .option_wrap
.increment:
        addq.w  #1,d2
.option_wrap:
        bpl.s   .option_high
        move.w  d3,d2
        subq.w  #1,d2
.option_high:
        cmp.w   d3,d2
        blo.s   .option_ready
        moveq   #0,d2
.option_ready:
        move.w  d2,(a0)
        andi.w  #$d6,d4
        beq.s   .idle
        bsr     intro_menu_draw
.idle:
        moveq   #0,d0
        bra.s   .done
.enter:
        tst.w   intro_menu_stage-intro_state(a5)
        bne.s   .confirm
        move.w  #1,intro_menu_stage-intro_state(a5)
        bsr     intro_menu_draw
        bra.s   .idle
.confirm:
        move.l  #$515a4d4e,$27ff0
        move.w  intro_level-intro_state(a5),d0
        lsl.w   #8,d0
        or.w    intro_mode-intro_state(a5),d0
        move.w  d0,$27ff4
        move.w  intro_course-intro_state(a5),$27ff6
        moveq   #1,d0
.done:
        movem.l (sp)+,d1-d7/a0-a4
        rts

intro_menu_draw:
        movem.l d0-d7/a0-a6,-(sp)
        move.w  intro_mode-intro_state(a5),d0
        move.w  intro_course-intro_state(a5),d1
        tst.w   d0
        bne.s   .option
        move.w  intro_level-intro_state(a5),d1
.option:
        lea     mode_menu_data(pc),a0
        bsr     menu_draw
        ifd menu_records
        lea     intro_records_hint(pc),a0
        movea.l #$20000+mode_menu_records_y*128,a1
        movea.l #$20000+(mode_menu_records_y+mode_menu_records_rows)*128,a3
        bsr     menu_unpack
        endif
        movem.l (sp)+,d0-d7/a0-a6
        rts
        include "menu_draw.asm"
        ifd menu_records
intro_records_hint:
        incbin "../assets/title/records_hint.lz"
        even
        endif
