; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Exact quotient intervals; generated balanced decision tree.
        cmpi.w  #3584,d1
        ble.s   .far_0_14
        cmpi.w  #7168,d1
        ble.s   .far_0_7
        cmpi.w  #14336,d1
        ble.s   .far_0_3
        cmpi.w  #28672,d1
        ble.s   .far_0_1
        moveq   #0,d0
        rts
.far_0_1:
        moveq   #1,d0
        rts
.far_0_3:
        cmpi.w  #9557,d1
        ble.s   .far_2_3
        moveq   #2,d0
        rts
.far_2_3:
        moveq   #3,d0
        rts
.far_0_7:
        cmpi.w  #4778,d1
        ble.s   .far_4_7
        cmpi.w  #5734,d1
        ble.s   .far_4_5
        moveq   #4,d0
        rts
.far_4_5:
        moveq   #5,d0
        rts
.far_4_7:
        cmpi.w  #4096,d1
        ble.s   .far_6_7
        moveq   #6,d0
        rts
.far_6_7:
        moveq   #7,d0
        rts
.far_0_14:
        cmpi.w  #2389,d1
        ble.s   .far_8_14
        cmpi.w  #2867,d1
        ble.s   .far_8_11
        cmpi.w  #3185,d1
        ble.s   .far_8_9
        moveq   #8,d0
        rts
.far_8_9:
        moveq   #9,d0
        rts
.far_8_11:
        cmpi.w  #2606,d1
        ble.s   .far_10_11
        moveq   #10,d0
        rts
.far_10_11:
        moveq   #11,d0
        rts
.far_8_14:
        cmpi.w  #2048,d1
        ble.s   .far_12_14
        cmpi.w  #2205,d1
        ble.s   .far_12_13
        moveq   #12,d0
        rts
.far_12_13:
        moveq   #13,d0
        rts
.far_12_14:
        moveq   #14,d0
        rts
