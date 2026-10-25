; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Sky overlay: 32 x 16 logical pixels, repeated horizontally, fixed Y=28.
; Only initial sky and dirty intervals touch it. No extra frame buffer.
; D0=start Y, D1=end Y, D6=column byte offset, A5=base sky pattern.
themed_sky_segment:
        cmpi.w  #44,d0
        bge     sky_column_segment
        cmpi.w  #28,d1
        ble     sky_column_segment
        movem.l d2-d3/a2,-(sp)
        move.w  d1,d3
        cmpi.w  #28,d0
        bge.s   .clouds
        move.w  #28,d1
        bsr     sky_column_segment
        move.w  #28,d0
.clouds:
        move.w  d3,d1
        cmpi.w  #44,d1
        ble.s   .end
        move.w  #44,d1
.end:
        move.w  d1,d2
        sub.w   d0,d2
        ble.s   .tail
        move.w  d0,d1
        lsl.w   #7,d1
        movea.l s_page(a6),a0
        adda.w  d1,a0
        adda.w  d6,a0
        subi.w  #28,d0
        lsl.w   #4,d0
        move.w  d6,d1
        andi.w  #15,d1
        add.w   d1,d0
        lea     sky_cloud_words(pc),a2
        adda.w  d0,a2
        subq.w  #1,d2
.row:
        move.l  (a2),(a0)
        adda.w  #16,a2
        adda.w  #128,a0
        dbra    d2,.row
.tail:
        cmpi.w  #44,d3
        ble.s   .done
        move.w  #44,d0
        move.w  d3,d1
        bsr     sky_column_segment
.done:
        movem.l (sp)+,d2-d3/a2
        rts

draw_sky_clouds:
        movem.l d2-d7/a2-a5,-(sp)
        move.l  d0,a5          ; initial fill's sky pattern survives fill_256bytes
        moveq   #0,d6
        moveq   #31,d7
.column:
        moveq   #28,d0
        moveq   #44,d1
        bsr     themed_sky_segment
        addq.w  #4,d6
        dbra    d7,.column
        movem.l (sp)+,d2-d7/a2-a5
        rts
