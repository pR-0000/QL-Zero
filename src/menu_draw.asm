; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Shared loader/resident menu. D0 mode, D1 option, A0 asset table.
menu_reset:
        lea     menu_cached_mode(pc),a0
        move.w  #-1,(a0)
        rts

menu_draw:
        movem.l d0-d7/a0-a5,-(sp)
        movea.l a0,a5
        move.w  d0,d6
        move.w  d1,d7
        move.w  menu_cached_mode(pc),d2
        cmp.w   d2,d6
        beq     .captions
        tst.w   d2
        bpl     .changed_icons
        ; A cold menu clears once. Only the nonempty static bands are packed.
        movea.l #$20000,a1
        moveq   #0,d0
        move.w  #8191,d1
.clear:
        move.l  d0,(a1)+
        dbra    d1,.clear
        movea.l a5,a4
        adda.l  (a5),a4
.background:
        move.l  (a4)+,d0
        beq.s   .decode_icons
        movea.l a5,a0
        adda.l  d0,a0
        movea.l #$20000,a1
        adda.w  (a4)+,a1
        movea.l #$20000,a3
        adda.w  (a4)+,a3
        bsr     menu_unpack
        bra.s   .background
.decode_icons:
        movea.l a5,a0
        adda.l  #mode_menu_icons_offset,a0
        ifd intro_entry
        lea     intro_menu_scratch(pc),a1
        else
        movea.l #$28000,a1     ; reuse the inactive racing scene, not extra RAM
        endif
        lea     mode_menu_icon_bank_bytes(a1),a3
        bsr     menu_unpack
        moveq   #0,d2
.icon:
        bsr     menu_icon
        addq.w  #1,d2
        cmpi.w  #4,d2
        blo.s   .icon
        bra.s   .mode_ready
.changed_icons:
        bsr     menu_icon      ; previous selection, immediately checker-dimmed
        move.w  d6,d2
        bsr     menu_icon      ; new selection, all pixels intact
.mode_ready:
        lea     menu_cached_mode(pc),a1
        move.w  d6,(a1)
.captions:
        move.w  d6,d0
        beq.s   .gp
        moveq   #4,d0
        cmpi.w  #1,d6
        beq.s   .course
        moveq   #4+mode_menu_course_count,d0
        cmpi.w  #2,d6
        beq.s   .course
        moveq   #4+2*mode_menu_course_count,d0
.course:
        add.w   d7,d0
        bra.s   .screen
.gp:
        move.w  d7,d0
.screen:
        lsl.w   #3,d0
        movea.l a5,a4
        adda.w  d0,a4
        movea.l a5,a0
        adda.l  4(a4),a0
        movea.l #$20000+mode_menu_caption_y*128,a1
        movea.l #$20000+(mode_menu_caption_y+7)*128,a3
        bsr     menu_unpack
        movea.l a5,a0
        adda.l  8(a4),a0
        movea.l #$20000+mode_menu_rules_y*128,a1
        movea.l #$20000+(mode_menu_rules_y+7)*128,a3
.bottom:
        bsr     menu_unpack
        movea.l #0,a0
        tst.w   d6
        beq.s   .preview
        move.w  d7,d0
        lsl.w   #2,d0
        lea     mode_menu_previews_offset(a5),a0
        move.l  0(a0,d0.w),d0
        movea.l a5,a0
        adda.l  d0,a0
.preview:
        bsr     menu_preview
.done:
        movem.l (sp)+,d0-d7/a0-a5
        rts

; D2 icon, D6 selection. One final word is written, without a later erase
; pass. Shared decoded source words remain intact in the menu workspace.
menu_icon:
        move.w  d2,d0
        mulu.w  #1512,d0
        ifd intro_entry
        lea     intro_menu_scratch(pc),a0
        else
        movea.l #$28000,a0
        endif
        adda.w  d0,a0
        move.w  d2,d0
        mulu.w  #30,d0
        addi.w  #mode_menu_icon_y*128+10,d0
        movea.l #$20000,a1
        adda.w  d0,a1
        moveq   #-1,d3
        moveq   #0,d5
        cmp.w   d6,d2
        beq.s   .ready
        move.w  #$88cc,d3
        move.w  #$aaff,d5
.ready:
        moveq   #83,d4
.row:
        moveq   #8,d1
.word:
        move.w  (a0)+,d0
        and.w   d3,d0
        move.w  d0,(a1)+
        dbra    d1,.word
        eor.w   d5,d3
        adda.w  #110,a1
        bsr     menu_service
        dbra    d4,.row
        rts

menu_unpack:
        move.l  a4,-(sp)
        lea     128(a1),a4
        ; Generated stream; stop at the exact destination boundary.
.command:
        cmpa.l  a4,a1
        blo.s   .bounded
        bsr     menu_service
        lea     128(a1),a4
.bounded:
        cmpa.l  a3,a1
        bhs.s   .done
        moveq   #0,d0
        move.b  (a0)+,d0
        bmi.s   .match
        addq.w  #1,d0
        subq.w  #1,d0
.literal:
        move.b  (a0)+,(a1)+
        dbra    d0,.literal
        bra.s   .command
.match:
        andi.w  #127,d0
        addq.w  #2,d0
        moveq   #0,d1
        move.b  (a0)+,d1
        lsl.w   #8,d1
        move.b  (a0)+,d1
        movea.l a1,a2
        suba.l  d1,a2
.copy:
        move.b  (a2)+,(a1)+
        dbra    d0,.copy
        bra.s   .command
.done:
        movea.l (sp)+,a4
        rts

; Exact monochrome previews computed from the editable spline before build.
; Each row has offset/count and two packed nibbles per byte, no RAM scratch.
menu_preview:
        moveq   #-1,d5
        move.l  a0,d0
        beq.s   .position
        move.w  (a0)+,d5
.position:
        movea.l #$20000+mode_menu_preview_y*128+48,a1
        movea.l a1,a4
        lea     menu_preview_words(pc),a3
        moveq   #31,d4
.row:
        movea.l a1,a2
        moveq   #0,d0
        rept 8
        move.l  d0,(a2)+
        endr
        tst.w   d5
        bmi.s   .next
        moveq   #0,d1
        move.b  (a0)+,d1
        movea.l a1,a2
        adda.w  d1,a2
        moveq   #0,d2
        move.b  (a0)+,d2
        beq.s   .next
        subq.w  #1,d2
.word:
        moveq   #0,d1
        move.b  (a0)+,d1
        move.w  d1,d0
        lsr.w   #4,d0
        add.w   d0,d0
        move.w  0(a3,d0.w),(a2)+
        subq.w  #1,d2
        bmi.s   .next
        move.w  d1,d0
        andi.w  #15,d0
        add.w   d0,d0
        move.w  0(a3,d0.w),(a2)+
        dbra    d2,.word
.next:
        adda.w  #128,a1
        bsr     menu_service
        dbra    d4,.row
        tst.w   d5
        bmi.s   .done
        move.w  #$aa00,0(a4,d5.w)  ; green start/finish marker
.done:
        rts

menu_service:
        ifd intro_entry
        bra     intro_music_update
        else
        bra     poll_clock
        endif
menu_preview_words:
        dc.w $0000,$0203,$080c,$0a0f,$2030,$2233,$283c,$2a3f
        dc.w $80c0,$82c3,$88cc,$8acf,$a0f0,$a2f3,$a8fc,$aaff
menu_cached_mode: dc.w -1
