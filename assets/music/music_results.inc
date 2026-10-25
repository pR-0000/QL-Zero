music_tick_hz       equ 50
music_format_version equ 2
music_loop          equ 1
music_event_count   equ 1020
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
        dc.b    $31        ; QL pitch 49
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $92        ; QL pitch 146
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $92        ; QL pitch 146
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $34        ; QL pitch 52
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $72        ; QL pitch 114
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $72        ; QL pitch 114
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $92        ; QL pitch 146
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $92        ; QL pitch 146
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $34        ; QL pitch 52
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $72        ; QL pitch 114
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $72        ; QL pitch 114
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $92        ; QL pitch 146
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $92        ; QL pitch 146
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $34        ; QL pitch 52
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $72        ; QL pitch 114
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $72        ; QL pitch 114
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $92        ; QL pitch 146
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $92        ; QL pitch 146
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $34        ; QL pitch 52
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $72        ; QL pitch 114
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $72        ; QL pitch 114
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $ff        ; end
        even
