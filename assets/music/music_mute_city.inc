music_tick_hz       equ 50
music_format_version equ 2
music_loop          equ 1
music_event_count   equ 366
music_effect_count  equ 2

        even
music_effects:
        dc.w    0, 0 ; 0: manual
        dc.b    $00, $00
        dc.w    1, 0 ; 1: fine tuning
        dc.b    $10, $00
        even

music_loop_flag:
        dc.b    1
        even

music_data:
        dc.b    $20        ; QL pitch 32
        dc.w    62
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    62
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    62
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    42
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    62
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    62
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    62
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    58
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    62
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    62
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    62
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    42
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    62
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    62
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    62
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    42
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    25
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    46
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    46
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    25
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    25
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    25
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    25
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    25
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    25
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    25
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    37
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    96
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    46
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    46
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    21
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    21
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    25
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    25
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    25
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    25
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    25
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    25
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    25
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    37
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    96
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $ff        ; end
        even
