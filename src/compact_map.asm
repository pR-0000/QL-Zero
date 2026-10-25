; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; D4 linear 128x128 index. D5 sampled flags; D3/D4/A0 scratch.
; No decompression, storage reads or allocation during racing.
map_sample:
        bsr.s   map_sample_flags
        moveq   #0,d5
        move.w  d3,d5
        rts
; Contact tests retain D5 without a stack save or another wrapper call.
map_sample_flags:
        move.w  d4,d3
        lsr.w   #1,d3
        andi.w  #$fffe,d3
        movea.l a6,a0
        adda.l  #track_buffer-state+96,a0
        move.w  0(a0,d3.w),d3
        bmi.s   .uniform
        adda.w  d3,a0
        andi.w  #3,d4
        moveq   #0,d3
        move.b  0(a0,d4.w),d3
        rts
.uniform:
        andi.l  #255,d3
        rts
