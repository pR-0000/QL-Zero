; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; A four-second camera orbit precedes the countdown. The grid, racing timer,
; AI, energy and ghost recording remain frozen until GO. No extra state RAM.
cup_intro_ticks equ 200
cup_begin_countdown:
        move.w  #10,cup_phase-state(a6)
        move.w  #1,cup_finishing-state(a6)
        move.w  s_angle(a6),cup_finish_heading-state(a6)
        clr.w   s_started(a6)
        clr.w   s_cache0(a6)
        clr.w   s_sky_horizon0(a6)
        clr.w   cup_go_until-state(a6)
        move.w  s_ticks(a6),cup_countdown_start-state(a6)

cup_intro_frame:
        moveq   #0,d0
        move.w  s_ticks(a6),d0
        sub.w   cup_countdown_start-state(a6),d0
        cmpi.w  #cup_intro_ticks,d0
        bhs.s   .ready
        lsl.l   #8,d0
        divu.w  #cup_intro_ticks,d0
        add.w   cup_finish_heading-state(a6),d0
        andi.w  #255,d0
        move.w  d0,s_angle(a6)
        bsr     render_frame
        moveq   #1,d0
        rts
.ready:
        move.w  cup_finish_heading-state(a6),s_angle(a6)
        clr.w   cup_finishing-state(a6)
        move.w  #7,cup_phase-state(a6)
        move.w  #-1,cup_countdown_stage-state(a6)
        bsr     render_frame
        move.w  s_ticks(a6),cup_countdown_start-state(a6)
        bra     cup_countdown_frame

cup_countdown_frame:
        moveq   #0,d0
        move.w  s_ticks(a6),d0
        sub.w   cup_countdown_start-state(a6),d0
        cmpi.w  #150,d0
        bhs.s   .go
        divu.w  #50,d0
        cmp.w   cup_countdown_stage-state(a6),d0
        beq.s   .wait
        move.w  d0,cup_countdown_stage-state(a6)
        bsr     cup_countdown_draw
.wait:
        moveq   #1,d0
        rts
.go:
        move.w  #3,cup_countdown_stage-state(a6)
        bsr     cup_countdown_draw
        clr.w   ghost_clock-state(a6)
        clr.w   ghost_wait_start-state(a6)
        clr.w   cup_phase-state(a6)
        move.w  #1,s_started(a6)
        move.w  s_ticks(a6),s_last_tick(a6)
        move.w  s_ticks(a6),d0
        addi.w  #35,d0
        bne.s   .go_deadline
        moveq   #1,d0
.go_deadline:
        move.w  d0,cup_go_until-state(a6)
        moveq   #1,d0
        rts

cup_draw_go:
        tst.w   cup_go_until-state(a6)
        beq.s   .done
        move.w  cup_go_until-state(a6),d0
        sub.w   s_ticks(a6),d0
        ble.s   .expired
        bra.s   cup_countdown_draw
.expired:
        clr.w   cup_go_until-state(a6)
.done:
        rts

; Six-column glyphs, 4 x 3 native pixel scale, on a small opaque black panel.
; No second screen or scratch buffer. Glyph rows and text are constant.
cup_countdown_draw:
        movem.l d0-d7/a0-a3,-(sp)
        ; In a descent the panel may overlap cached sky, rather than road.
        ; Invalidate that sky only while the short banner covers it.
        cmpi.w  #112,s_view_horizon(a6)
        bls.s   .background_ready
        clr.w   s_sky_horizon0(a6)
.background_ready:
        movea.l #$20000+112*128+44,a0
        moveq   #26,d7          ; 27 rows: 21 lit glyph rows + 3-row margins
.clear_row:
        movea.l a0,a1
        moveq   #19,d0
.clear_word:
        clr.w   (a1)+
        dbra    d0,.clear_word
        adda.w  #128,a0
        dbra    d7,.clear_row
        move.w  cup_countdown_stage-state(a6),d0
        lsl.w   #3,d0
        lea     cup_countdown_glyphs(pc),a2
        adda.w  d0,a2
        moveq   #0,d6
        movea.l #$20000+115*128+58,a3
        cmpi.w  #3,cup_countdown_stage-state(a6)
        bne.s   .character
        moveq   #2,d6
        suba.w  #10,a3         ; GO!'s visible 60 pixels, centered like digits
.character:
        movea.l a3,a0
        moveq   #6,d5          ; skip the font's final empty source row
.row:
        moveq   #0,d0
        move.b  (a2)+,d0
        movea.l a0,a1
        moveq   #0,d3          ; carry: left half of the preceding 4-pixel cell
        moveq   #5,d4
.pixel:
        moveq   #0,d1
        lsl.b   #1,d0
        bcc.s   .ink
        move.w  #$0a0f,d1      ; two-pixel shift: right half, no flash bits
.ink:
        or.w    d1,d3
        move.w  d3,(a1)
        move.w  d3,128(a1)
        move.w  d3,256(a1)
        lsl.w   #4,d1
        move.w  d1,d3
        addq.w  #2,a1
        dbra    d4,.pixel
        adda.w  #384,a0
        dbra    d5,.row
        addq.l  #1,a2          ; next glyph still starts on an eight-byte slot
        adda.w  #12,a3
        dbra    d6,.character
        movem.l (sp)+,d0-d7/a0-a3
        rts

cup_countdown_glyphs:
        dc.b 240,8,8,112,8,8,240,0
        dc.b 112,136,8,16,32,64,248,0
        dc.b 32,96,32,32,32,32,112,0
        dc.b 120,128,128,184,136,136,120,0
        dc.b 112,136,136,136,136,136,112,0
        dc.b 32,32,32,32,32,0,32,0
        even
