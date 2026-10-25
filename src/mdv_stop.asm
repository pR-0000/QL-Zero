; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Original QL MD.DESEL protocol: shift eight zero select bits, high then low.
; $18020 writes control the drives; reads at the same address are IPC status.
; Keep WRITE/ERASE zero. Delays match the original JS ROM L2C50 sequence and
; also leave enough time for NanoQL's ZX8302 to sample each clock edge.
stop_microdrives:
        moveq   #7,d1
.motor:
        move.b  #2,pc_ipcrd     ; select=0, clock=1, write=0, erase=0
        moveq   #$39,d0
        ror.l   d0,d0
        clr.b   pc_ipcrd        ; falling edge shifts a deselect bit
        moveq   #$39,d0
        ror.l   d0,d0
        dbra    d1,.motor
        rts
