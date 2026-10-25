music_tick_hz       equ 50
music_format_version equ 2
music_loop          equ 1
music_event_count   equ 1398
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
        dc.b    $fe        ; rest
        dc.w    67
        dc.b    0         ; effect profile
        dc.b    $00        ; QL pitch 0
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $01        ; QL pitch 1
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    5
        dc.b    1         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    14
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    23
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $01        ; QL pitch 1
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $01        ; QL pitch 1
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $01        ; QL pitch 1
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $00        ; QL pitch 0
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    129
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    129
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    81
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    38
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $fe        ; rest
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $44        ; QL pitch 68
        dc.w    4
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $01        ; QL pitch 1
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $01        ; QL pitch 1
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $01        ; QL pitch 1
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $00        ; QL pitch 0
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $3c        ; QL pitch 60
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    129
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    5
        dc.b    0         ; effect profile
        dc.b    $02        ; QL pitch 2
        dc.w    129
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $03        ; QL pitch 3
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $05        ; QL pitch 5
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $04        ; QL pitch 4
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $06        ; QL pitch 6
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $07        ; QL pitch 7
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $09        ; QL pitch 9
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0c        ; QL pitch 12
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $08        ; QL pitch 8
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0a        ; QL pitch 10
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0d        ; QL pitch 13
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0f        ; QL pitch 15
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $12        ; QL pitch 18
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $0e        ; QL pitch 14
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $11        ; QL pitch 17
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $14        ; QL pitch 20
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $18        ; QL pitch 24
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1c        ; QL pitch 28
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $28        ; QL pitch 40
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $16        ; QL pitch 22
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $20        ; QL pitch 32
        dc.w    2
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1a        ; QL pitch 26
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $1e        ; QL pitch 30
        dc.w    3
        dc.b    0         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $22        ; QL pitch 34
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $25        ; QL pitch 37
        dc.w    3
        dc.b    1         ; effect profile
        dc.b    $2b        ; QL pitch 43
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    1
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    1
        dc.b    1         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    4
        dc.b    0         ; effect profile
        dc.b    $4e        ; QL pitch 78
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $31        ; QL pitch 49
        dc.w    2
        dc.b    0         ; effect profile
        dc.b    $2e        ; QL pitch 46
        dc.w    82
        dc.b    0         ; effect profile
        dc.b    $38        ; QL pitch 56
        dc.w    33
        dc.b    1         ; effect profile
        dc.b    $ff        ; end
        even
