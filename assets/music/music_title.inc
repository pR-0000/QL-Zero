music_tick_hz       equ 50
music_format_version equ 2
music_loop          equ 1
music_event_count   equ 364
music_effect_count  equ 3

        even
music_effects:
        dc.w    0, 0 ; 0: manual
        dc.b    $00, $00
        dc.w    1, 0 ; 1: fine tuning
        dc.b    $10, $00
        dc.w    2, 600 ; 2: solo vibrato
        dc.b    $10, $00
        even

music_loop_flag:
        dc.b    1
        even

music_data:
        dc.b    $fe        ; rest
        dc.w    38
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    10
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    9
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    7
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    7
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $3b        ; QL pitch 59
        dc.w    20
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    92
        dc.b    2         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    58
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    74
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    66
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    33
        dc.b    0         ; effect profile
        dc.b    $de        ; QL pitch 222
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    25
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    66
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    16
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    9
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    16
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    9
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    33
        dc.b    0         ; effect profile
        dc.b    $a4        ; QL pitch 164
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    16
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $27        ; QL pitch 39
        dc.w    2
        dc.b    2         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    9
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    9
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    9
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $ba        ; QL pitch 186
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    51
        dc.b    2         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    9
        dc.b    0         ; effect profile
        dc.b    $0b        ; QL pitch 11
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    14
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    2
        dc.b    2         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $10        ; QL pitch 16
        dc.w    35
        dc.b    2         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    43
        dc.b    2         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    43
        dc.b    2         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $1d        ; QL pitch 29
        dc.w    10
        dc.b    2         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $27        ; QL pitch 39
        dc.w    2
        dc.b    2         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    16
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    66
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    16
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    9
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    33
        dc.b    0         ; effect profile
        dc.b    $a4        ; QL pitch 164
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    17
        dc.b    1         ; effect profile
        dc.b    $59        ; QL pitch 89
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $5e        ; QL pitch 94
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $5e        ; QL pitch 94
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0b        ; QL pitch 11
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    18
        dc.b    2         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    18
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    18
        dc.b    2         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $10        ; QL pitch 16
        dc.w    5
        dc.b    2         ; effect profile
        dc.b    $de        ; QL pitch 222
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    125
        dc.b    2         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    58
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    74
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    66
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    33
        dc.b    0         ; effect profile
        dc.b    $de        ; QL pitch 222
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    25
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    66
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    16
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    9
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    33
        dc.b    0         ; effect profile
        dc.b    $a4        ; QL pitch 164
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    17
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    13
        dc.b    0         ; effect profile
        dc.b    $27        ; QL pitch 39
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    9
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    9
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    9
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $ba        ; QL pitch 186
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    51
        dc.b    2         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    9
        dc.b    0         ; effect profile
        dc.b    $0b        ; QL pitch 11
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    14
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    2
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    2
        dc.b    2         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $10        ; QL pitch 16
        dc.w    34
        dc.b    2         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    43
        dc.b    2         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    43
        dc.b    2         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $1d        ; QL pitch 29
        dc.w    10
        dc.b    2         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $27        ; QL pitch 39
        dc.w    2
        dc.b    2         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    16
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    66
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    9
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    16
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    33
        dc.b    0         ; effect profile
        dc.b    $a4        ; QL pitch 164
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    17
        dc.b    1         ; effect profile
        dc.b    $59        ; QL pitch 89
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $5e        ; QL pitch 94
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $5e        ; QL pitch 94
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0b        ; QL pitch 11
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    12
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    18
        dc.b    2         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    18
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    18
        dc.b    2         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    12
        dc.b    0         ; effect profile
        dc.b    $10        ; QL pitch 16
        dc.w    5
        dc.b    2         ; effect profile
        dc.b    $de        ; QL pitch 222
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $10        ; QL pitch 16
        dc.w    126
        dc.b    2         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    57
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    74
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    66
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    33
        dc.b    0         ; effect profile
        dc.b    $de        ; QL pitch 222
        dc.w    9
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    24
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    66
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    17
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    33
        dc.b    0         ; effect profile
        dc.b    $a4        ; QL pitch 164
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    17
        dc.b    1         ; effect profile
        dc.b    $ba        ; QL pitch 186
        dc.w    8
        dc.b    0         ; effect profile
        dc.b    $ff        ; end
        even
