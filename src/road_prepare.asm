; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Lossless coarse visibility table, and lazy outer world/camera coordinates.
; Flags+64 retain heading validity. Inner flags+32 already do the same.
road_prepare:
        tst.w   s_geometry_valid(a6)
        beq.s   .invalidate
        move.w  s_angle(a6),d0
        cmp.w   s_geometry_angle(a6),d0
        beq.s   .visibility
.invalidate:
        move.w  #1,s_geometry_valid(a6)
        move.w  s_angle(a6),s_geometry_angle(a6)
        lea     s_projection_valid+32(a6),a0
        moveq   #15,d0
.clear:
        clr.l   (a0)+
        dbra    d0,.clear
.visibility:
        moveq   #-1,d6
        cmpi.w  #4096,s_far_depth(a6)
        bne.s   .mask_ready     ; F5's unlimited view keeps every section
        move.w  s_gcamx(a6),d0
        cmpi.w  #16384,d0
        bhs.s   .mask_ready
        move.w  s_gcamy(a6),d1
        cmpi.w  #16384,d1
        bhs.s   .mask_ready
        lsr.w   #8,d0
        lsr.w   #4,d0
        lsl.w   #5,d0
        lsr.w   #8,d1
        lsr.w   #4,d1
        lsl.w   #7,d1
        or.w    d1,d0
        move.w  s_angle(a6),d1
        lsr.w   #5,d1
        lsl.w   #2,d1
        or.w    d1,d0
        movea.l a6,a0
        adda.l  #track_buffer-state+track_pvs_offset,a0
        move.l  0(a0,d0.w),d6
.mask_ready:
        move.l  d6,cup_visibility-state(a6)
        move.l  d6,d0
        ror.l   #1,d0
        or.l    d0,d6        ; each surviving section needs both endpoints
        movea.l a6,a0
        adda.l  #track_buffer-state+render_mesh_offset,a0
        lea     s_floor_cache(a6),a1
        lea     s_projection_valid+64(a6),a2
        lea     s_mesh_camera(a6),a3
        moveq   #31,d7
.point:
        btst    d7,d6
        beq     .next
        tst.b   0(a2,d7.w)
        bne.s   .translate
        st      0(a2,d7.w)
        move.w  (a0),d0
        move.w  2(a0),d1
        bsr     rotate_pair
        move.l  d0,(a1)
        move.l  d2,4(a1)
        sub.l   s_world_cam_lat(a6),d0
        asr.l   #8,d0
        move.w  d0,(a3)
        sub.l   s_world_cam_depth(a6),d2
        asr.l   #8,d2
        move.w  d2,2(a3)
        move.w  12(a0),d0
        move.w  14(a0),d1
        bsr     rotate_pair
        move.l  d0,24(a1)
        move.l  d2,28(a1)
        sub.l   s_world_cam_lat(a6),d0
        asr.l   #8,d0
        move.w  d0,12(a3)
        sub.l   s_world_cam_depth(a6),d2
        asr.l   #8,d2
        move.w  d2,14(a3)
        bra.s   .clock
.translate:
        move.l  (a1),d0
        sub.l   s_world_cam_lat(a6),d0
        asr.l   #8,d0
        move.w  d0,(a3)
        move.l  4(a1),d0
        sub.l   s_world_cam_depth(a6),d0
        asr.l   #8,d0
        move.w  d0,2(a3)
        move.l  24(a1),d0
        sub.l   s_world_cam_lat(a6),d0
        asr.l   #8,d0
        move.w  d0,12(a3)
        move.l  28(a1),d0
        sub.l   s_world_cam_depth(a6),d0
        asr.l   #8,d0
        move.w  d0,14(a3)
.clock:
        move.w  d7,d0
        andi.w  #3,d0
        bne.s   .next
        bsr     poll_clock
.next:
        adda.w  #16,a0
        adda.w  #32,a1
        adda.w  #16,a3
        dbra    d7,.point
.prepared:
        rts
