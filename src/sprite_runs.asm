; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Lossless grouped rows: one/two equal source rows, occupied runs, row end -1.
; Keep separate background merges for both destinations: no copied sky/road
; pixels and no damage to overlapping ships. D5 survives both blitters.
blit_player:
        movea.l #frame_profile,a2
        tst.w   42(a2)
        beq.s   .normal_blit
        moveq   #0,d0
        bra     queue_player_overlay
.normal_blit:
        cmpi.w  #23,d2
        blt     blit_player_legacy
        movem.l d7/a4,-(sp)
        moveq   #0,d7
        bra.s   sprite_full_start
blit_player_white:
        movea.l #frame_profile,a2
        tst.w   42(a2)
        beq.s   .normal_blit
        moveq   #1,d0
        bra     queue_player_overlay
.normal_blit:
        cmpi.w  #23,d2
        blt     blit_player_white_legacy
        movem.l d7/a4,-(sp)
        moveq   #1,d7
sprite_full_start:
.row:
        movea.w (a1)+,a4
        movea.l a0,a3
        btst    #0,d7
        bne     .white_run
        cmpa.w  #2,a4
        beq.s   .pair_run
.single_run:
        move.w  (a1)+,d3
        bmi     .next
        lea     0(a3,d3.w),a0
        move.w  (a1)+,d1
        bmi.s   .single_masked
        move.w  d1,d3
        lsr.w   #1,d1
        beq.s   .single_tail
        subq.w  #1,d1
.single_long:
        move.l  (a1)+,(a0)+
        dbra    d1,.single_long
.single_tail:
        btst    #0,d3
        beq.s   .single_run
        move.w  (a1)+,(a0)+
        bra.s   .single_run
.single_masked:
        neg.w   d1
        subq.w  #1,d1
.single_mixed:
        move.w  (a1)+,d0
        and.w   (a0),d0
        or.w    (a1)+,d0
        move.w  d0,(a0)+
        dbra    d1,.single_mixed
        bra.s   .single_run
.pair_run:
        move.w  (a1)+,d3
        bmi     .next
        lea     0(a3,d3.w),a0
        move.w  (a1)+,d1
        bmi.s   .pair_masked
        move.w  d1,d3
        lsr.w   #1,d1
        beq.s   .pair_tail
        subq.w  #1,d1
.pair_long:
        move.l  (a1)+,d0
        move.l  d0,(a0)+
        move.l  d0,124(a0)
        dbra    d1,.pair_long
.pair_tail:
        btst    #0,d3
        beq.s   .pair_run
        move.w  (a1)+,d0
        move.w  d0,(a0)
        move.w  d0,128(a0)
        bra.s   .pair_run
.pair_masked:
        neg.w   d1
        subq.w  #1,d1
.pair_mixed:
        move.w  (a1)+,d0
        move.w  (a1)+,d3
        move.w  d0,d4
        and.w   (a0),d0
        or.w    d3,d0
        move.w  d0,(a0)
        and.w   128(a0),d4
        or.w    d3,d4
        move.w  d4,128(a0)
        addq.w  #2,a0
        dbra    d1,.pair_mixed
        bra.s   .pair_run
.white_run:
        move.w  (a1)+,d3
        bmi.s   .next
        lea     0(a3,d3.w),a0
        move.w  (a1)+,d1
        bmi.s   .white_masked
        move.w  d1,d0
        add.w   d0,d0
        adda.w  d0,a1
        subq.w  #1,d1
        cmpa.w  #2,a4
        beq.s   .pair_white_opaque
.white_opaque:
        move.w  #$aaff,(a0)+
        dbra    d1,.white_opaque
        bra.s   .white_run
.pair_white_opaque:
        move.w  #$aaff,(a0)+
        move.w  #$aaff,126(a0)
        dbra    d1,.pair_white_opaque
        bra.s   .white_run
.white_masked:
        neg.w   d1
        subq.w  #1,d1
        cmpa.w  #2,a4
        beq.s   .pair_white_masked
.white_mixed:
        move.w  (a1)+,d0
        addq.l  #2,a1
        move.w  (a0),d3
        and.w   d0,d3
        not.w   d0
        andi.w  #$aaff,d0
        or.w    d3,d0
        move.w  d0,(a0)+
        dbra    d1,.white_mixed
        bra.s   .white_run
.pair_white_masked:
        move.w  (a1)+,d0
        addq.l  #2,a1
        move.w  d0,d4
        not.w   d4
        andi.w  #$aaff,d4
        move.w  (a0),d3
        and.w   d0,d3
        or.w    d4,d3
        move.w  d3,(a0)
        and.w   128(a0),d0
        or.w    d4,d0
        move.w  d0,128(a0)
        addq.w  #2,a0
        dbra    d1,.pair_white_masked
        bra     .white_run
.next:
        movea.l a3,a0
        adda.w  #128,a0
        subq.w  #1,d2
        subq.w  #1,s_render_poll(a6)
        cmpa.w  #2,a4
        bne.s   .clock
        adda.w  #128,a0
        subq.w  #1,d2
        subq.w  #1,s_render_poll(a6)
.clock:
        tst.w   s_render_poll(a6)
        bpl.s   .clock_done
        move.w  #3,s_render_poll(a6)
        bsr     poll_clock
.clock_done:
        tst.w   d2
        bpl     .row
        movem.l (sp)+,d7/a4
        rts


; No repeated-row tests or additional registers in their inner loops.
blit_player_legacy:
.row:
        movea.l a0,a3
.run:
        move.w  (a1)+,d3
        bmi.s   .next
        lea     0(a3,d3.w),a0
        move.w  (a1)+,d1
        bmi.s   .masked
        move.w  d1,d3
        lsr.w   #1,d1
        beq.s   .tail
        subq.w  #1,d1
.long:
        move.l  (a1)+,(a0)+
        dbra    d1,.long
.tail:
        btst    #0,d3
        beq.s   .run
        move.w  (a1)+,(a0)+
        bra.s   .run
.masked:
        neg.w   d1
        subq.w  #1,d1
.mixed:
        move.w  (a1)+,d0
        and.w   (a0),d0
        or.w    (a1)+,d0
        move.w  d0,(a0)+
        dbra    d1,.mixed
        bra.s   .run
.next:
        movea.l a3,a0
        adda.w  #128,a0
        subq.w  #1,s_render_poll(a6)
        bpl.s   .clock_done
        move.w  #3,s_render_poll(a6)
        bsr     poll_clock
.clock_done:
        dbra    d2,.row
        rts

blit_player_white_legacy:
.row:
        movea.l a0,a3
.run:
        move.w  (a1)+,d3
        bmi.s   .next
        lea     0(a3,d3.w),a0
        move.w  (a1)+,d1
        bmi.s   .masked
        subq.w  #1,d1
.opaque:
        addq.l  #2,a1
        move.w  #$aaff,(a0)+
        dbra    d1,.opaque
        bra.s   .run
.masked:
        neg.w   d1
        subq.w  #1,d1
.mixed:
        move.w  (a1)+,d0
        addq.l  #2,a1
        move.w  (a0),d3
        and.w   d0,d3
        not.w   d0
        andi.w  #$aaff,d0
        or.w    d3,d0
        move.w  d0,(a0)+
        dbra    d1,.mixed
        bra.s   .run
.next:
        movea.l a3,a0
        adda.w  #128,a0
        bsr     poll_clock
        dbra    d2,.row
        rts

; A0 destination, A1 records, D1 occupied words (1..12), D6 masked flag,
; D7 bit 0 white flag, A4 repeat (1/2). D0/D1/D3/D4 and A0/A1 clobbered.
sprite_run_copy:
        btst    #0,d7
        bne     .white
        tst.w   d6
        bne.s   .masked
        cmpa.w  #2,a4
        beq.s   .pair_opaque
        move.w  d1,d3
        lsr.w   #1,d1
        neg.w   d1
        add.w   d1,d1
        jmp     .opaque_tail(pc,d1.w)
        move.l  (a1)+,(a0)+
        move.l  (a1)+,(a0)+
        move.l  (a1)+,(a0)+
        move.l  (a1)+,(a0)+
        move.l  (a1)+,(a0)+
        move.l  (a1)+,(a0)+
.opaque_tail:
        btst    #0,d3
        beq.s   .done
        move.w  (a1)+,(a0)+
.done:
        rts
.pair_opaque:
        move.w  d1,d3
        lsr.w   #1,d1
        beq.s   .pair_tail
        subq.w  #1,d1
.pair_long:
        move.l  (a1)+,d0
        move.l  d0,(a0)+
        move.l  d0,124(a0)
        dbra    d1,.pair_long
.pair_tail:
        btst    #0,d3
        beq.s   .done
        move.w  (a1)+,d0
        move.w  d0,(a0)
        move.w  d0,128(a0)
        rts
.masked:
        subq.w  #1,d1
        cmpa.w  #2,a4
        beq.s   .pair_mixed
.mixed:
        move.w  (a1)+,d0
        and.w   (a0),d0
        or.w    (a1)+,d0
        move.w  d0,(a0)+
        dbra    d1,.mixed
        rts
.pair_mixed:
        move.w  (a1)+,d0
        move.w  (a1)+,d3
        move.w  d0,d4
        and.w   (a0),d0
        or.w    d3,d0
        move.w  d0,(a0)
        and.w   128(a0),d4
        or.w    d3,d4
        move.w  d4,128(a0)
        addq.w  #2,a0
        dbra    d1,.pair_mixed
        rts
.white:
        btst    #3,d7
        bne     .red
        subq.w  #1,d1
        tst.w   d6
        bne.s   .white_masked
        move.w  d1,d0
        addq.w  #1,d0
        add.w   d0,d0
        adda.w  d0,a1          ; opaque ink is unused in white mode
        cmpa.w  #2,a4
        beq.s   .pair_white_opaque
.white_opaque:
        move.w  #$aaff,(a0)+
        dbra    d1,.white_opaque
        rts
.pair_white_opaque:
        move.w  #$aaff,(a0)+
        move.w  #$aaff,126(a0)
        dbra    d1,.pair_white_opaque
        rts
.white_masked:
        cmpa.w  #2,a4
        beq.s   .pair_white_masked
.white_mixed:
        move.w  (a1)+,d0
        addq.l  #2,a1
        move.w  (a0),d3
        and.w   d0,d3
        not.w   d0
        andi.w  #$aaff,d0
        or.w    d3,d0
        move.w  d0,(a0)+
        dbra    d1,.white_mixed
        rts
.pair_white_masked:
        move.w  (a1)+,d0
        addq.l  #2,a1
        move.w  d0,d4
        not.w   d4
        andi.w  #$aaff,d4
        move.w  (a0),d3
        and.w   d0,d3
        or.w    d4,d3
        move.w  d3,(a0)
        and.w   128(a0),d0
        or.w    d4,d0
        move.w  d0,128(a0)
        addq.w  #2,a0
        dbra    d1,.pair_white_masked
        rts

.red:
        subq.w  #1,d1
        tst.w   d6
        bne.s   .red_masked
        move.w  d1,d0
        addq.w  #1,d0
        add.w   d0,d0
        adda.w  d0,a1          ; opaque ink is unused in white mode
        cmpa.w  #2,a4
        beq.s   .pair_red_opaque
.red_opaque:
        move.w  #$00aa,(a0)+
        dbra    d1,.red_opaque
        rts
.pair_red_opaque:
        move.w  #$00aa,(a0)+
        move.w  #$00aa,126(a0)
        dbra    d1,.pair_red_opaque
        rts
.red_masked:
        cmpa.w  #2,a4
        beq.s   .pair_red_masked
.red_mixed:
        move.w  (a1)+,d0
        addq.l  #2,a1
        move.w  (a0),d3
        and.w   d0,d3
        not.w   d0
        andi.w  #$00aa,d0
        or.w    d3,d0
        move.w  d0,(a0)+
        dbra    d1,.red_mixed
        rts
.pair_red_masked:
        move.w  (a1)+,d0
        addq.l  #2,a1
        move.w  d0,d4
        not.w   d4
        andi.w  #$00aa,d4
        move.w  (a0),d3
        and.w   d0,d3
        or.w    d4,d3
        move.w  d3,(a0)
        and.w   128(a0),d0
        or.w    d4,d0
        move.w  d0,128(a0)
        addq.w  #2,a0
        dbra    d1,.pair_red_masked
        rts
