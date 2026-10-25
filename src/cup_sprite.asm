; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; D0 view/size table byte index, D7 rival camera offset (0/4). A1 native rows.
; Only a source change pays LZ/colour conversion. The blitters stay unchanged.
cup_sprite_select:
        movem.l d0-d7/a0/a2-a5,-(sp)
        move.w  d7,d1
        lsl.w   #3,d1
        add.w   d1,d0
        move.w  d7,d1
        lsr.w   #1,d1
        lea     cup_npc_dead(pc),a0
        tst.w   0(a0,d1.w)
        beq.s   .key
        andi.w  #7,d0
        addi.w  #64,d0
.key:
        cmpi.w  #1,cup_mode-state(a6)
        bne.s   .ordinary_bank
        addi.w  #72,d0
.ordinary_bank:
        movea.l a6,a4
        adda.l  #cup_sprite_buffers-state,a4
        tst.w   d7
        beq.s   .buffer
        adda.w  #cup_sprite_capacity,a4
.buffer:
        movea.l a6,a5
        adda.l  #cup_sprite_keys-state,a5
        adda.w  d1,a5
        movea.l a6,a2
        adda.l  #cup_sprite_recent-state,a2
        adda.w  d1,a2
        cmp.w   (a5),d0
        bne.s   .second_key
        clr.w   (a2)
        bra     .ready
.second_key:
        cmp.w   4(a5),d0
        bne.s   .cache_miss
        move.w  #1,(a2)
        adda.w  #2*cup_sprite_capacity,a4
        bra     .ready
.cache_miss:
        tst.w   (a2)
        bne.s   .replace_first
        move.w  #1,(a2)
        adda.w  #2*cup_sprite_capacity,a4
        addq.l  #4,a5
        bra.s   .replace_key
.replace_first:
        clr.w   (a2)
.replace_key:
        move.w  d0,(a5)
        lsl.w   #2,d0
        lea     cup_sprite_table(pc),a5
        adda.w  d0,a5
        lea     cup_sprite_table(pc),a0
        adda.l  (a5),a0
        movea.l a0,a2
        adda.w  4(a5),a2
        movea.l a4,a1
        movea.l a1,a3
        adda.w  6(a5),a3
        move.l  a4,-(sp)
        bsr     cup_sprite_word_unpack
        movea.l (sp)+,a4
        tst.l   d0
        bne     cup_corrupt
        ; A buffer address stays fixed even when its source changes. Force
        ; fresh row indexes in the compositor without erasing queued rows.
        movea.l s_frame_budget(a6),a0
        adda.w  #scene_records,a0
        moveq   #5,d0
        lea     4(a4),a1      ; native row source after width/height header
.invalidate:
        cmpa.l  8(a0),a1
        bne.s   .keep_index
        clr.l   8(a0)
.keep_index:
        adda.w  #scene_stride,a0
        dbra    d0,.invalidate
.ready:
        movea.l a4,a1
        movem.l (sp)+,d0-d7/a0/a2-a5
        rts

; Build-time native RLE words, dictionary literals, word-sized LZ matches.
; A0/A2 compressed bounds, A1/A3 output bounds. D0=0 success / -15 corrupt.
; Palette 0..254, token 255 followed by an unaligned big-endian raw word.
cup_sprite_word_unpack:
        movea.l a1,a4
.command:
        cmpa.l  a2,a0
        beq     .end
        bhi     .bad
        moveq   #0,d0
        move.b  (a0)+,d0
        bmi     .match
        addq.w  #1,d0
        move.w  d0,d2
        add.w   d2,d2
        move.l  a1,d3
        add.l   d2,d3
        cmp.l   a3,d3
        bhi     .bad
        move.l  a0,d3
        add.l   d0,d3         ; at least one token byte for every literal
        cmp.l   a2,d3
        bhi     .bad
        subq.w  #1,d0
        movea.l a6,a5
        adda.l  #cup_sprite_word_palette-state,a5
.literal:
        moveq   #0,d1
        move.b  (a0)+,d1
        cmpi.b  #255,d1
        beq.s   .escape
        add.w   d1,d1
        move.w  0(a5,d1.w),(a1)+
        dbra    d0,.literal
        bra     .command
.escape:
        move.l  a0,d3
        addq.l  #2,d3
        add.l   d0,d3         ; raw word plus remaining literal tokens
        cmp.l   a2,d3
        bhi     .bad
        move.b  (a0)+,d1
        lsl.w   #8,d1
        move.b  (a0)+,d1
        move.w  d1,(a1)+
        dbra    d0,.literal
        bra     .command
.match:
        andi.w  #127,d0
        addq.w  #3,d0
        cmpa.l  a2,a0
        bhs     .bad
        moveq   #0,d1
        move.b  (a0)+,d1
        tst.w   d1
        beq     .bad
        add.l   d1,d1
        movea.l a1,a5
        suba.l  d1,a5
        cmpa.l  a4,a5
        blo     .bad
        move.w  d0,d2
        add.w   d2,d2
        move.l  a1,d3
        add.l   d2,d3
        cmp.l   a3,d3
        bhi.s   .bad
        subq.w  #1,d0
.copy:
        move.w  (a5)+,(a1)+
        dbra    d0,.copy
        bra     .command
.end:
        cmpa.l  a3,a1
        bne.s   .bad
        moveq   #0,d0
        rts
.bad:
        moveq   #-15,d0
        rts
