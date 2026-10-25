; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; ESC replaces QDOS's BASIC report with a native screen, then halts.
; No traps, ROM screen routines, heap allocation or additional race work.
show_native_report:
        move.l  #$20000,s_page(a6)
        move.b  #8,mc_stat
        movea.l #$20000,a0
        moveq   #0,d0
        moveq   #127,d7
        bsr     fill_256bytes
        lea     native_title(pc),a1
        moveq   #8,d1
        moveq   #32,d2
        moveq   #28,d4
        bsr     draw_text
        bsr     show_lod_report
        lea     native_reset(pc),a1
        move.w  #208,d2
        bsr     draw_text
        movea.l #frame_profile,a4
        tst.w   12(a4)
        beq.s   .window_ready
        adda.w  #12,a4
.window_ready:
        move.w  (a4),d0
        lea     s_text(a6),a1
        bsr     format_three
        move.w  #48,d2
        bsr     .number
        lea     native_count(pc),a1
        bsr     .label
        moveq   #0,d6
.stage:
        lea     native_labels(pc),a1
        adda.w  d6,a1
        move.w  d6,d2
        add.w   d2,d2
        addi.w  #72,d2
        bsr     .label
        move.w  d6,d0
        lsr.w   #2,d0
        moveq   #0,d1
        move.w  2(a4,d0.w),d1
        mulu.w  #200,d1          ; tenths of ms, calculated only after ESC
        tst.w   (a4)
        beq.s   .no_frames
        divu.w  (a4),d1
        bvc.s   .average_ready
        move.w  #9999,d1
        bra.s   .average_ready
.no_frames:
        moveq   #0,d1
.average_ready:
        move.w  d1,d0
        cmpi.w  #9999,d0
        bls.s   .average_bounded
        move.w  #9999,d0
.average_bounded:
        lea     s_text(a6),a1
        andi.l  #$ffff,d0
        divu.w  #10,d0
        move.l  d0,d5
        swap    d5
        addi.b  #'0',d5
        bsr     format_three
        move.b  #'.',3(a1)
        move.b  d5,4(a1)
        moveq   #92,d1
        moveq   #5,d4
        bsr     draw_text
        addq.w  #8,d6
        cmpi.w  #32,d6
        blt.s   .stage
        move.w  3266(a6),d0
        cmpi.w  #-1,d0
        bne.s   .min_ready
        moveq   #0,d0
.min_ready:
        mulu.w  #20,d0
        move.w  #152,d2
        lea     native_min(pc),a1
        bsr     .range
        move.w  3198(a6),d0
        mulu.w  #20,d0
        move.w  #168,d2
        lea     native_max(pc),a1
        bsr.s   .range
        moveq   #0,d0
        move.w  s_fps(a6),d0
        move.w  #184,d2
        lea     native_fps(pc),a1
.range:
        bsr     .label
        cmpi.l  #999,d0
        bls.s   .range_ready
        move.w  #999,d0
.range_ready:
        lea     s_text(a6),a1
        bsr     format_three
.number:
        moveq   #92,d1
        moveq   #3,d4
        bra     draw_text
.label:
        moveq   #8,d1
        moveq   #8,d4
        bra     draw_text
native_title: dc.b 'STANDALONE - ACTIVE MS',0
native_reset: dc.b 'RESET QL TO RESTART',0
native_count: dc.b 'FRAMES',0
native_labels:
        dc.b 'KEYS',0,0,0,0
        dc.b 'SOUND',0,0,0
        dc.b 'PHYSICS',0
        dc.b 'DRAW',0,0,0,0
native_min: dc.b 'MIN MS',0
native_max: dc.b 'MAX MS',0
native_fps: dc.b 'FPS',0
        even
