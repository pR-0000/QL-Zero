music_tick_hz       equ 50
music_format_version equ 2
music_loop          equ 1
music_event_count   equ 686
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
        dc.w    75
        dc.b    0         ; effect profile
        dc.b    $49        ; QL pitch 73
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    11
        dc.b    0         ; effect profile
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
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    27
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    2
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $1b        ; QL pitch 27
        dc.w    38
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    13
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0b        ; QL pitch 11
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    28
        dc.b    2         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    82
        dc.b    2         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    68
        dc.b    2         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    14
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    10
        dc.b    0         ; effect profile
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
        dc.b    $12        ; QL pitch 18
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    28
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $1b        ; QL pitch 27
        dc.w    7
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    13
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    10
        dc.b    1         ; effect profile
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
        dc.b    $12        ; QL pitch 18
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    157
        dc.b    2         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $4d        ; QL pitch 77
        dc.w    156
        dc.b    2         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    156
        dc.b    2         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    68
        dc.b    2         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    13
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    14
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    13
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    13
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    39
        dc.b    2         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    13
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    13
        dc.b    0         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    14
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    36
        dc.b    2         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    36
        dc.b    2         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    10
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    68
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    14
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $1b        ; QL pitch 27
        dc.w    39
        dc.b    2         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    35
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    13
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    14
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    2
        dc.b    2         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $1b        ; QL pitch 27
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $30        ; QL pitch 48
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $27        ; QL pitch 39
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $2d        ; QL pitch 45
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    14
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    68
        dc.b    2         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    2
        dc.b    2         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    10
        dc.b    0         ; effect profile
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
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    28
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $1b        ; QL pitch 27
        dc.w    39
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    14
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    2
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0b        ; QL pitch 11
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    28
        dc.b    2         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    81
        dc.b    2         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    68
        dc.b    2         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    13
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    11
        dc.b    0         ; effect profile
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
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    28
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $1b        ; QL pitch 27
        dc.w    6
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    14
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    11
        dc.b    1         ; effect profile
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
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    156
        dc.b    2         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $4d        ; QL pitch 77
        dc.w    157
        dc.b    2         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    10
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $6b        ; QL pitch 107
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $64        ; QL pitch 100
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $58        ; QL pitch 88
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $79        ; QL pitch 121
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    157
        dc.b    2         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    68
        dc.b    2         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    14
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    13
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    14
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    13
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    39
        dc.b    2         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    14
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    13
        dc.b    0         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    13
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    36
        dc.b    2         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    6
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    36
        dc.b    2         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    10
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    68
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    13
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $1b        ; QL pitch 27
        dc.w    39
        dc.b    2         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $40        ; QL pitch 64
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    6
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    8
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    36
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    10
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    14
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    13
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $1b        ; QL pitch 27
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $30        ; QL pitch 48
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $27        ; QL pitch 39
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $2d        ; QL pitch 45
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    13
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    68
        dc.b    2         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    11
        dc.b    0         ; effect profile
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
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    28
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $1b        ; QL pitch 27
        dc.w    38
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    13
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $17        ; QL pitch 23
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $13        ; QL pitch 19
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    11
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $0b        ; QL pitch 11
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    11
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    27
        dc.b    2         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    2
        dc.b    2         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    15
        dc.b    0         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    1
        dc.b    2         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    15
        dc.b    1         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    81
        dc.b    2         ; effect profile
        dc.b    $ff        ; end
        even
