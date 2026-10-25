; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Mark only FOUR-row bands wholly covered by the opaque announcement.
; Partial bands still draw normally, including an unaligned moving horizon.
road_hidden_bands:
        rts

; Same zero registers and target as the original clear. Enter only while
; a panel is active; ordinary racing retains the original unfiltered loop.
clear_hidden_road_bands:
        lea     460(a6),a2
.band:
        btst    #6,(a2)+
        bne.s   .hidden
        movem.l d0-d6/a1,0(a0)
        movem.l d0-d6/a1,32(a0)
        movem.l d0-d6/a1,64(a0)
        movem.l d0-d6/a1,96(a0)
.hidden:
        adda.w  #128,a0
        btst    #0,d7
        bne.s   .clock
        btst    #1,d7
        bne.s   .clock
        bsr     poll_clock
.clock:
        dbra    d7,.band
        rts
