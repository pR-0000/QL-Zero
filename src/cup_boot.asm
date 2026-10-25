; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Relocatable compressed cup loader. QDOS is discarded before decoding.
; Screen 0 stages the stream; output begins at cup_image_base. The old
; message cache holds the active track, outside the decoded image.
        ifnd cup_image_base
cup_image_base equ $2c680
        endif
        move.w  #$0100,d6       ; GP / Standard
        moveq   #-1,d7          ; show resident selector (direct injection)
        ifnd cup_injection
        cmpi.l  #$515a4d4e,$27ff0
        bne.s   .no_selection
        move.w  $27ff4,d6
        move.w  $27ff6,d7
.no_selection:
        trap    #0
        endif
        move.w  #$2700,sr
        ; ZX8301 bit 1 blanks RGB while VRAM stages executable/LZ bytes.
        ; Stay in MODE 8; the game reveals only a completed clean screen.
        move.b  #10,$18063
        ifnd cup_injection
        clr.l   $27ff0         ; handshake is consumed while its screen is hidden
        endif
        lea     cup_payload(pc),a0
        lea     cup_boot_kernel(pc),a1
        movea.l #$20000,a2
        move.w  #(cup_boot_kernel_end-cup_boot_kernel)/2-1,d0
.install:
        move.w  (a1)+,(a2)+
        dbra    d0,.install
        jmp     $20000
cup_boot_kernel:
        movea.l #$20100,a1
        move.l  #cup_payload_end-cup_payload,d0
        cmpa.l  a0,a1
        beq.s   .decode
        blo.s   .forward
        adda.l  d0,a0
        adda.l  d0,a1
        subq.l  #1,d0
.backward:
        move.b  -(a0),-(a1)
        dbra    d0,.backward
        bra.s   .decode
.forward:
        subq.l  #1,d0
.copy:
        move.b  (a0)+,(a1)+
        dbra    d0,.copy
.decode:
        movea.l #$3fff0,sp
        movea.l #$20100+cup_payload_end-cup_payload,a0
        movea.l #$20100,a2
        movea.l #cup_image_base+cup_image_size,a1
        movea.l #cup_image_base,a3
        bsr.s   cup_unpack
        tst.l   d0
        bne.s   .invalid
        jmp     cup_image_base
.invalid:
        move.b  #8,$18063
        stop    #$2700
        bra.s   .invalid
        include "cup_lz_reverse.asm"
        even
cup_boot_kernel_end:
        ifgt cup_boot_kernel_end-cup_boot_kernel-256
        fail    "Cup bootstrap exceeds 256 bytes"
        endif
cup_payload:
        incbin  "../assets/cup_image.lz"
cup_payload_end:
        even
