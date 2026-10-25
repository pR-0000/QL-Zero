; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
direct equ 1
        org $2c680
        bra.w cup_game_start
        include "data/music_cup.inc"
        include "cup_music_ring.asm"
cup_game_start:
        include "race.asm"
