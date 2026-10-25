; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; Flat ribbon renderer, standard 68000 only. Camera coordinates use 8.7:
; even a map diagonal fits a signed word. No expansion RAM is required.
; The floor-cache scratch holds 32-bit rotated world vertices in ROAD mode.
draw_road:
        clr.w   s_contour_collect(a6)
        clr.w   s_contour_overflow(a6)
        tst.w   s_band_compose(a6)
        beq.s   .contour_stack_ready
        suba.w  #contour_pool_size,sp
        move.l  sp,s_contour_base(a6)
        move.l  sp,s_contour_next(a6)
        lea     contour_pool_size(sp),a0
        move.l  a0,s_contour_end(a6)
        move.w  #1,s_contour_collect(a6)
        move.w  cup_factor-state(a6),s_contour_factor(a6) ; 1.2 / (2*5.8), fixed 8-bit ratio
        tst.w   s_track_profile(a6)
        beq.s   .contour_stack_ready
        move.w  cup_factor-state(a6),s_contour_factor(a6) ; Big Blue: 1.2 / (2*4.5)
.contour_stack_ready:
        clr.w   s_band_active(a6) ; F1 selects geometry, samples stay DIRECT
        move.w  #-1,s_floor_quality(a6)
        move.w  #4,s_geom_step(a6)
        move.w  #224,d0
        sub.w   s_view_horizon(a6),d0
        move.w  d0,s_geom_limit(a6)
        clr.w   358(a6)
        lea     460(a6),a1
        moveq   #9,d0
        moveq   #0,d1
        tst.w   s_band_active(a6)
        bne.s   .first_flags_ready
        move.l  #$80808080,d1    ; reference samples will all be cleared
.first_flags_ready:
.thirteen_flags:
        move.l  d1,(a1)+
        dbra    d0,.thirteen_flags
        bsr     road_hidden_bands
        move.l  s_frame_budget(a6),d0
        beq.s   .visible_samples
        tst.w   s_quality(a6)
        bne.s   .visible_samples
        movea.l d0,a0
        bra.s   .sample_target_ready
.visible_samples:
        movea.l s_page(a6),a0
        move.w  s_view_horizon(a6),d0
        lsl.w   #7,d0
        adda.w  d0,a0
.sample_target_ready:
        move.l  floor_patterns-state(a6),d0
        move.w  s_geom_limit(a6),d7
        lsr.w   #1,d7
        subq.w  #1,d7
        cmpi.w  #4,s_geom_step(a6)
        bne.s   .clear_native
        bsr     clear_road_bands
        bra.s   .ground_cleared
.clear_native:
        bsr     fill_256bytes
.ground_cleared:
        move.l  s_camx(a6),d0
        asr.l   #8,d0
        asr.l   #1,d0
        move.w  d0,s_gcamx(a6)
        move.l  s_camy(a6),d0
        asr.l   #8,d0
        asr.l   #1,d0
        move.w  d0,s_gcamy(a6)
        move.w  s_angle(a6),d0
        add.w   d0,d0
        lea     direction_x-state(a6),a0
        move.w  0(a0,d0.w),s_cos(a6)
        lea     direction_y-state(a6),a0
        move.w  0(a0,d0.w),s_sin(a6)
        move.w  s_sin(a6),d1
        move.w  d1,d2
        add.w   s_cos(a6),d1
        sub.w   s_cos(a6),d2
        move.w  d1,s_cos_plus_sin(a6)
        move.w  d2,s_sin_minus_cos(a6)
        ; Rotate the camera first so a heading rebuild can also translate
        ; its outer vertices, without rereading the whole world cache.
        move.w  s_gcamx(a6),d0
        move.w  s_gcamy(a6),d1
        bsr     rotate_pair
        move.l  d0,s_world_cam_lat(a6)
        move.l  d2,s_world_cam_depth(a6)
        bsr     road_prepare
        lea     s_projection_valid(a6),a0
        moveq   #7,d0
.clear_projection:
        clr.l   (a0)+
        dbra    d0,.clear_projection
        clr.w   352(a6)        ; visible rail indices in unused edge scratch
        lea     s_mesh_camera(a6),a4
        moveq   #31,d7
        clr.w   s_rail_pass(a6)
.section:
        clr.w   354(a6)
        lea     16(a4),a5
        tst.w   d7
        bne.s   .next_ready
        lea     s_mesh_camera(a6),a5
.next_ready:
        lea     600(a6),a0
        clr.b   0(a0,d7.w)
        move.l  cup_visibility-state(a6),d0
        btst    d7,d0
        beq     .next_section
        ; Trivial depth rejection costs a few comparisons, before lateral
        ; bounds and perspective work. Conditions are identical to the full
        ; four-point box, including near-plane crossings and wrapped sections.
        cmpi.w  #128,2(a4)
        bge.s   .depth_candidate
        cmpi.w  #128,14(a4)
        bge.s   .depth_candidate
        cmpi.w  #128,2(a5)
        bge.s   .depth_candidate
        cmpi.w  #128,14(a5)
        blt     .next_section
.depth_candidate:
        move.w  s_far_depth(a6),d0
        cmp.w   2(a4),d0
        bgt.s   .bounds_candidate
        cmp.w   14(a4),d0
        bgt.s   .bounds_candidate
        cmp.w   2(a5),d0
        bgt.s   .bounds_candidate
        cmp.w   14(a5),d0
        ble     .next_section
.bounds_candidate:
        move.w  (a4),d1
        move.w  d1,d2
        move.w  2(a4),d3
        move.w  d3,d4
        lea     12(a4),a0
        bsr     ribbon_bounds
        movea.l a5,a0
        bsr     ribbon_bounds
        lea     12(a5),a0
        bsr     ribbon_bounds
        cmpi.w  #128,d3
        blt     .next_section
        cmp.w   s_far_depth(a6),d4
        bge     .next_section
        tst.w   s_quality(a6)
        bne.s   .depth_samples_ready
        bsr     ribbon_depth_sample_visible
        tst.w   d0
        beq     .next_section
.depth_samples_ready:
        ext.l   d3
        lsl.l   #4,d3
        muls.w  #9,d1
        cmp.l   d3,d1
        bgt     .next_section
        neg.l   d3
        muls.w  #9,d2
        cmp.l   d3,d2
        blt     .next_section
        bsr     project_ribbon_section
        lea     600(a6),a0
        tst.w   354(a6)
        beq.s   .ten_unmerged
        move.b  #$81,0(a0,d7.w)
        bra.s   .ten_depth_cert
.ten_unmerged:
        move.b  #1,0(a0,d7.w)
.ten_depth_cert:
        cmpi.w  #128,d4
        blt.s   .front_cached
        addq.b  #1,0(a0,d7.w)
.front_cached:
        move.w  352(a6),d0
        add.w   d0,d0
        lea     288(a6),a0
        move.w  d7,0(a0,d0.w)
        addq.w  #1,352(a6)
        ; Asphalt, then the two rails. Convex strip quads support multiple
        ; separated stretches of road on the same screen scanline.
        move.w  #1,s_poly_color(a6)
        tst.w   s_decor(a6)
        beq.s   .asphalt_color
        moveq   #31,d0
        sub.w   d7,d0
        add.w   d0,d0
        cmpi.w  #32,d0
        blo.s   .speed_band
        cmpi.w  #36,d0
        bhs.s   .speed_band
        move.w  #9,s_poly_color(a6)
        bra.s   .asphalt_color
.speed_band:
        andi.w  #7,d0
        cmpi.w  #2,d0
        bne.s   .asphalt_color
        move.w  #8,s_poly_color(a6)
.asphalt_color:
        moveq   #4,d0
        moveq   #8,d1
        bsr     ribbon_polygon
.asphalt_done:
.next_section:
        tst.w   354(a6)
        beq.s   .ten_single_section
        adda.w  #16,a4
        subq.w  #1,d7
.ten_single_section:
        adda.w  #16,a4
        bsr     poll_clock
        dbra    d7,.section
        clr.w   s_contour_collect(a6)
        tst.w   s_band_compose(a6)
        beq.s   .contour_reference
        tst.w   s_contour_overflow(a6)
        bne.s   .contour_fallback
        bsr     draw_contour_rails
        bra     .markers_ready
.contour_fallback:
        ; The fixed pool never wraps. Finish with original exact rails.
        ; Their outer vertices were skipped, so invalidate all projected caps.
        lea     s_projection_valid(a6),a0
        moveq   #7,d0
.contour_invalidate:
        clr.l   (a0)+
        dbra    d0,.contour_invalidate
.contour_reference:
        moveq   #0,d0
        tst.w   352(a6)
        beq.s   .markers_ready
.visible_rail:
        move.w  d0,-(sp)
        add.w   d0,d0
        lea     288(a6),a0
        move.w  0(a0,d0.w),d7
        moveq   #31,d0
        sub.w   d7,d0
        lsl.w   #4,d0
        lea     s_mesh_camera(a6),a4
        adda.w  d0,a4
        lea     16(a4),a5
        tst.w   d7
        bne.s   .visible_next
        lea     s_mesh_camera(a6),a5
.visible_next:
        tst.w   s_contour_overflow(a6)
        beq.s   .contour_caps_ready
        movea.l a4,a0
        bsr     project_cross_section
        movea.l a5,a0
        bsr     project_cross_section
.contour_caps_ready:
        lea     600(a6),a0
        btst    #7,0(a0,d7.w)
        beq.s   .ten_rail_end
        adda.w  #16,a5
        cmpi.w  #1,d7
        bne.s   .ten_rail_end
        lea     s_mesh_camera(a6),a5
.ten_rail_end:
        move.w  #7,s_poly_color(a6)
        moveq   #0,d0
        moveq   #4,d1
        bsr     ribbon_polygon
        moveq   #8,d0
        moveq   #12,d1
        bsr     ribbon_polygon
 .ten_rails_done:
        bsr     poll_clock
        move.w  (sp)+,d0
        addq.w  #1,d0
        cmp.w   352(a6),d0
        blt.s   .visible_rail
.markers_ready:
        movea.l a6,a4
        adda.l  #track_buffer-state,a4
        adda.w  #track_marker_offset,a4
        moveq   #1,d7
.marker:
        move.w  (a4)+,s_poly_color(a6)
        movea.l a4,a0
        lea     s_poly(a6),a1
        moveq   #3,d6
.marker_vertex:
        bsr     world_to_camera
        dbra    d6,.marker_vertex
        movea.l a0,a4
        bsr     road_polygon
        dbra    d7,.marker
        bsr     expand_road_bands
.complete:
        tst.w   s_band_compose(a6)
        beq.s   .contour_stack_done
        adda.w  #contour_pool_size,sp
.contour_stack_done:
        rts

; Compose each ROAD32 sample only once. All polygons still run in the same
; painter order and merge masks against that sample. Expand the FINAL sample
; after markers, before sprites. Uses no additional RAM and changes no pixels.
clear_road_bands:
        move.l  floor_patterns-state(a6),d0
        move.l  d0,d1
        move.l  d0,d2
        move.l  d0,d3
        move.l  d0,d4
        move.l  d0,d5
        move.l  d0,d6
        movea.l d0,a1
        move.w  s_geom_limit(a6),d7
        lsr.w   #road_band_shift,d7
        subq.w  #1,d7
        tst.w   s_message(a6)
        bne     clear_hidden_road_bands
        tst.w   s_dead(a6)
        bne     clear_hidden_road_bands
.band:
        movem.l d0-d6/a1,0(a0)
        movem.l d0-d6/a1,32(a0)
        movem.l d0-d6/a1,64(a0)
        movem.l d0-d6/a1,96(a0)
        tst.l   s_frame_budget(a6)
        beq.s   .visible_step
        adda.w  #128,a0
        bra.s   .sample_stepped
.visible_step:
        adda.w  #4*128,a0
.sample_stepped:
        btst    #0,d7
        bne.s   .clock_done
        btst    #1,d7
        bne.s   .clock_done
        bsr     poll_clock
.clock_done:
        dbra    d7,.band
        rts

expand_road_bands:
        movea.l #frame_profile,a0
        cmpi.w  #2,22(a0)
        beq     .deferred
        tst.l   s_frame_budget(a6)
        bne     present_road_samples
        movea.l s_page(a6),a0
        move.w  s_view_horizon(a6),d0
        lsl.w   #7,d0
        adda.w  d0,a0
        move.w  s_geom_limit(a6),d7
        lsr.w   #road_band_shift,d7
        subq.w  #1,d7
        lea     460(a6),a3
.band:
        tst.b   (a3)+
        bmi.s   .first_sample_ready
        bne     .thirteen_no_copy
        ; Untouched band: complete the black sample here, immediately
        ; before its ordinary four-row expansion. No extra traversal.
        moveq   #0,d0
        moveq   #0,d1
        moveq   #0,d2
        moveq   #0,d3
        moveq   #0,d4
        moveq   #0,d5
        suba.l  a1,a1
        suba.l  a2,a2
        movem.l d0-d5/a1-a2,0(a0)
        movem.l d0-d5/a1-a2,32(a0)
        movem.l d0-d5/a1-a2,64(a0)
        movem.l d0-d5/a1-a2,96(a0)
.first_sample_ready:
        ; Four fixed chunks: remove address updates and loop instruction
        ; fetches from each band on the 68008 eight-bit bus.
        movem.l 0(a0),d0-d5/a1-a2
        movem.l d0-d5/a1-a2,128(a0)
        movem.l d0-d5/a1-a2,256(a0)
        movem.l d0-d5/a1-a2,384(a0)
        movem.l 32(a0),d0-d5/a1-a2
        movem.l d0-d5/a1-a2,160(a0)
        movem.l d0-d5/a1-a2,288(a0)
        movem.l d0-d5/a1-a2,416(a0)
        movem.l 64(a0),d0-d5/a1-a2
        movem.l d0-d5/a1-a2,192(a0)
        movem.l d0-d5/a1-a2,320(a0)
        movem.l d0-d5/a1-a2,448(a0)
        movem.l 96(a0),d0-d5/a1-a2
        movem.l d0-d5/a1-a2,224(a0)
        movem.l d0-d5/a1-a2,352(a0)
        movem.l d0-d5/a1-a2,480(a0)
.thirteen_no_copy:
        adda.w  #512,a0
        move.w  d7,d0
        andi.w  #3,d0
        bne.s   .clock_done
        bsr     poll_clock
.clock_done:
        dbra    d7,.band
        rts
.deferred:
        rts

; Publish only completed rows. QDOS never sees the temporary black sample
; lines or intermediate polygon edges. 4,864 heap bytes suffice at horizon 72.
; Do not dispatch serial sound while copying to the visible screen: the QDOS
; counter continues in interrupts and pending notes resume after this copy.
present_road_samples:
        movea.l s_frame_budget(a6),a0
        movea.l s_page(a6),a3
        move.w  s_view_horizon(a6),d0
        lsl.w   #7,d0
        adda.w  d0,a3
        move.w  s_geom_limit(a6),d7
        lsr.w   #2,d7
        subq.w  #1,d7
.band:
        moveq   #3,d6
.chunk:
        movem.l (a0)+,d0-d5/a1-a2
        movem.l d0-d5/a1-a2,(a3)
        movem.l d0-d5/a1-a2,128(a3)
        movem.l d0-d5/a1-a2,256(a3)
        movem.l d0-d5/a1-a2,384(a3)
        adda.w  #32,a3
        dbra    d6,.chunk
        adda.w  #384,a3
        dbra    d7,.band
        rts


; Project only sections surviving the camera bounds. Adjacent sections share
; a cached cross-section. Translation itself needs no perspective divisions.
project_ribbon_section:
        movea.l a4,a0
        bsr.s   project_cross_section
        movea.l a5,a0
project_cross_section:
        move.l  a0,d0
        sub.l   a6,d0
        subi.w  #s_mesh_camera,d0
        move.w  d0,d1
        lsr.w   #4,d1
        lea     s_projection_valid(a6),a1
        tst.b   0(a1,d1.w)
        bne.s   .done
        move.b  #1,0(a1,d1.w)
        bsr     materialize_inner
        move.l  a0,d0
        sub.l   a6,d0
        subi.w  #s_mesh_camera,d0
        lea     s_projection_xy(a6),a2
        adda.w  d0,a2
        tst.w   s_contour_collect(a6)
        beq.s   .project_all_vertices
        ; Keep the old cap stride for the reference engine. Only +4/+8
        ; are read by asphalt; the contour pass needs no outer XY points.
        addq.w  #4,a0
        addq.w  #4,a2
        moveq   #1,d6
.inner_vertex:
        move.w  (a0)+,d0
        move.w  (a0)+,d1
        bsr     project_mesh_vertex
        dbra    d6,.inner_vertex
        bra.s   .done
.project_all_vertices:
        moveq   #3,d6
.vertex:
        move.w  (a0)+,d0
        move.w  (a0)+,d1
        bsr     project_mesh_vertex
        dbra    d6,.vertex
.done:
        rts

; A0 camera cross-section, preserve bounds D3/D4/D5 and its base pointer.
; Each heading retains exact 32-bit world products in the original cache.
materialize_inner:
        movem.l d3-d5/a0,-(sp)
        move.l  a0,d4
        sub.l   a6,d4
        subi.w  #s_mesh_camera,d4
        move.w  d4,d5
        lsr.w   #4,d5
        lea     s_projection_valid+32(a6),a3
        add.w   d4,d4
        lea     s_floor_cache+8(a6),a2
        adda.w  d4,a2
        tst.b   0(a3,d5.w)
        bne.s   .translated
        move.b  #1,0(a3,d5.w)
        movea.l a6,a1
        adda.l  #track_buffer-state+render_mesh_offset+4,a1
        move.w  d4,d0
        lsr.w   #1,d0
        adda.w  d0,a1
        move.w  (a1)+,d0
        move.w  (a1)+,d1
        bsr     rotate_pair
        move.l  d0,(a2)
        move.l  d2,4(a2)
        move.w  (a1)+,d0
        move.w  (a1)+,d1
        bsr     rotate_pair
        move.l  d0,8(a2)
        move.l  d2,12(a2)
.translated:
        addq.w  #4,a0
        move.l  (a2)+,d0
        sub.l   s_world_cam_lat(a6),d0
        asr.l   #8,d0
        move.w  d0,(a0)+
        move.l  (a2)+,d0
        sub.l   s_world_cam_depth(a6),d0
        asr.l   #8,d0
        move.w  d0,(a0)+
        move.l  (a2)+,d0
        sub.l   s_world_cam_lat(a6),d0
        asr.l   #8,d0
        move.w  d0,(a0)+
        move.l  (a2)+,d0
        sub.l   s_world_cam_depth(a6),d0
        asr.l   #8,d0
        move.w  d0,(a0)+
        movem.l (sp)+,d3-d5/a0
        rts

; Project front-facing mesh vertices. A2 advances
; even for hidden vertices, so byte offsets match the camera-coordinate mesh.
project_mesh_vertex:
        cmpi.w  #128,d1
        blt.s   .behind
        muls.w  #72,d0
        divs.w  d1,d0
        addi.w  #128,d0
        move.w  d0,(a2)+
        move.l  #28672,d0
        bsr     project_depth_y
        move.w  d0,(a2)+
        rts
.behind:
        addq.l  #4,a2
        rts

; Exact vertical quotients for the common 4..16-unit range. A native word
; lookup replaces DIVU; farther/nearer vertices keep the exact paths.
; D0=28672, D1=depth; D0 output, D2/A3 scratch.
project_depth_y:
        cmpi.w  #2048,d1
        bge     project_far_y
        move.w  d1,d2
        subi.w  #512,d2
        cmpi.w  #1536,d2
        bhs.s   .divide
        lea     depth_y_table-state(a6),a3
        moveq   #0,d0
        lsr.w   #2,d2
        move.b  0(a3,d2.w),d0
        move.w  d0,d2
        lsr.w   #6,d2
        beq.s   .depth_base
        movea.w d0,a3
        move.w  d1,d0
        andi.w  #3,d0
        cmp.w   d2,d0
        blt.s   .depth_no_drop
        move.l  a3,d0
        andi.w  #63,d0
        subq.w  #1,d0
        rts
.depth_no_drop:
        move.l  a3,d0
.depth_base:
        andi.w  #63,d0
        rts
.divide:
        divu.w  d1,d0
        rts

; Outer camera depth bounds imply exact vertical bounds before projecting
; any inner point. A rejected strip saves all four-point materialization,
; rotation, X divisions and polygons. Near strips always take the old path.
ribbon_depth_sample_visible:
        cmpi.w  #2048,d4
        blt.s   .visible
        movem.l d1-d4,-(sp)
        move.w  d3,d1
        move.l  #28672,d0
        bsr     project_depth_y
        addq.w  #4/2-1,d0
        andi.w  #-4,d0
        addq.w  #4/2,d0
        move.w  d0,d4
        move.w  14(sp),d1       ; saved D4 low word: minimum depth
        move.l  #28672,d0
        bsr     project_depth_y
        cmp.w   d0,d4
        movem.l (sp)+,d1-d4    ; MOVEM preserves comparison flags
        blt.s   .visible
        moveq   #0,d0
        rts
.visible:
        moveq   #1,d0
        rts

; Exact floor(28672/z) for z>=2048: only fifteen possible results.
; A balanced comparison tree avoids a slow divide and a large RAM table.
project_far_y:
        include "data/far_y_tree.inc"

; Shared road/rail vertices are divided only once per rendered frame.
; Fully front-facing quads skip clipping; crossing quads retain the exact
; general near-plane clipper. D0/D1 are byte offsets within each cross-section.
ribbon_polygon:
        movem.l d7/a4-a5,-(sp)
        ; Outer depth bounds certify the whole asphalt/rail section. For
        ; front-facing sections, avoid rebuilding and retesting every quad.
        lea     600(a6),a0
        cmpi.b  #2,0(a0,d7.w)
        bhs.s   .front
        lea     s_poly(a6),a0
        move.l  0(a4,d0.w),(a0)+
        move.l  0(a4,d1.w),(a0)+
        move.l  0(a5,d1.w),(a0)+
        move.l  0(a5,d0.w),(a0)+
        lea     s_poly+2(a6),a0
        moveq   #3,d7
.near_test:
        cmpi.w  #128,(a0)
        blt     .clipped
        addq.l  #4,a0
        dbra    d7,.near_test
.front:
        move.w  #4,s_clip_count(a6)
        lea     s_projection_xy-s_mesh_camera(a4),a2
        lea     s_projection_xy-s_mesh_camera(a5),a3
        lea     s_projected(a6),a0
        move.l  0(a2,d0.w),(a0)+
        move.l  0(a2,d1.w),(a0)+
        move.l  0(a3,d1.w),(a0)+
        move.l  0(a3,d0.w),(a0)+
        bsr     polygon_measure
        bra.s   .done
.clipped:
        bsr     road_polygon
.done:
        movem.l (sp)+,d7/a4-a5
        rts

; In ROAD32, distant sections lying entirely between sampled row centres
; produce no pixels. Reject the whole road/rail section before clipping.
; Outer depth extrema bound all four convex quads; near crossings stay exact.

ribbon_bounds:
        move.w  (a0),d0
        cmp.w   d1,d0
        bge.s   .not_min
        move.w  d0,d1
.not_min:
        cmp.w   d2,d0
        ble.s   .not_max
        move.w  d0,d2
.not_max:
        move.w  2(a0),d0
        cmp.w   d4,d0
        bge.s   .not_depth_min
        move.w  d0,d4
.not_depth_min:
        cmp.w   d3,d0
        ble.s   .done
        move.w  d0,d3
.done:
        rts

; a0 world 8.8 pairs -> a1 camera lateral/depth 8.7 pairs.
; d0-d5 clobbered, d6/d7 and a4/a5 preserved.
world_to_camera:
        move.w  (a0)+,d0
        lsr.w   #1,d0
        sub.w   s_gcamx(a6),d0
        move.w  (a0)+,d1
        lsr.w   #1,d1
        sub.w   s_gcamy(a6),d1
        bsr.s   rotate_pair
        asr.l   #8,d2
        asr.l   #8,d0
        move.w  d0,(a1)+
        move.w  d2,(a1)+
        rts

; d0/d1 signed 8.7 world pair -> d0 lateral, d2 depth (unrounded 8.15).
rotate_pair:
        ; Exact three-product rotation: P=(x+y)*c, Q=x*(c+s),
        ; R=y*(s-c); lateral=P-Q, depth=P+R. No rounding or reciprocal.
        ; Signed sum overflow takes the original four-product path.
        move.w  d0,d2
        add.w   d1,d2
        bvs.s   rotate_pair_wide
        muls.w  s_cos(a6),d2
        muls.w  s_cos_plus_sin(a6),d0
        muls.w  s_sin_minus_cos(a6),d1
        neg.l   d0
        add.l   d2,d0
        add.l   d1,d2
        rts
rotate_pair_wide:
        move.w  d0,d2
        muls.w  s_cos(a6),d2
        move.w  d1,d3
        muls.w  s_sin(a6),d3
        add.l   d3,d2
        muls.w  s_sin(a6),d0
        neg.l   d0
        muls.w  s_cos(a6),d1
        add.l   d1,d0
        rts

; Clip each quad against depth=1 world unit BEFORE perspective division.
; A clipped convex quad has at most five vertices. Scratch has room for eight.
road_polygon:
        movem.l d7/a4-a5,-(sp)
        clr.w   s_clip_count(a6)
        lea     s_poly(a6),a0
        lea     s_clip(a6),a1
        move.w  12(a0),d0
        move.w  14(a0),d1
        moveq   #3,d7
.clip_vertex:
        move.w  (a0)+,d2
        move.w  (a0)+,d3
        cmpi.w  #128,d3
        blt.s   .current_out
        cmpi.w  #128,d1
        bge.s   .copy_current
        bsr.s   clip_intersection
.copy_current:
        move.w  d2,(a1)+
        move.w  d3,(a1)+
        addq.w  #1,s_clip_count(a6)
        bra.s   .advance
.current_out:
        cmpi.w  #128,d1
        blt.s   .advance
        bsr.s   clip_intersection
.advance:
        move.w  d2,d0
        move.w  d3,d1
        dbra    d7,.clip_vertex
        bsr     project_polygon
        movem.l (sp)+,d7/a4-a5
        rts

clip_intersection:
        move.w  d2,d4
        sub.w   d0,d4
        move.w  #128,d5
        sub.w   d1,d5
        muls.w  d5,d4
        move.w  d3,d5
        sub.w   d1,d5
        divs.w  d5,d4
        add.w   d0,d4
        move.w  d4,(a1)+
        move.w  #128,(a1)+
        addq.w  #1,s_clip_count(a6)
        rts

project_polygon:
        move.w  s_clip_count(a6),d7
        cmpi.w  #3,d7
        blt     polygon_done
        subq.w  #1,d7
        lea     s_clip(a6),a0
        lea     s_projected(a6),a1
.project:
        move.w  (a0)+,d0
        move.w  (a0)+,d1
        cmpi.w  #128,d1
        bne.s   .general_projection
        ; Near-plane intersections are EXACTLY depth 128. Signed truncation
        ; of x*9/16 replaces DIVS, and y is exactly 224, with no DIVU.
        muls.w  #9,d0
        tst.l   d0
        bpl.s   .near_positive
        addi.l  #15,d0
.near_positive:
        asr.l   #4,d0
        addi.w  #128,d0
        move.w  d0,(a1)+
        move.w  #224,(a1)+
        bra.s   .projected
.general_projection:
        muls.w  #72,d0
        divs.w  d1,d0
        addi.w  #128,d0
        move.w  d0,(a1)+
        move.l  #28672,d0
        bsr     project_depth_y
        move.w  d0,(a1)+
.projected:
        dbra    d7,.project
polygon_measure:
        ; Reject a convex quad wholly beyond either screen edge BEFORE
        ; computing its edge slopes. In near turns, both rails can be outside
        ; while asphalt fills the screen; those invisible rails cost no rows.
        lea     s_projected(a6),a0
        tst.w   (a0)
        bmi.s   .reject_left
        cmpi.w  #256,(a0)
        bgt.s   .reject_right
        bra.s   .x_ready
.reject_left:
        move.w  s_clip_count(a6),d0
        subq.w  #2,d0
.left_vertex:
        addq.w  #4,a0
        tst.w   (a0)
        bpl.s   .x_ready
        dbra    d0,.left_vertex
        rts
.reject_right:
        move.w  s_clip_count(a6),d0
        subq.w  #2,d0
.right_vertex:
        addq.w  #4,a0
        cmpi.w  #256,(a0)
        ble.s   .x_ready
        dbra    d0,.right_vertex
        rts
.x_ready:
        ; Keep the bounds and minimum vertex index in registers. The order
        ; and strict comparisons match the general path exactly.
        move.w  s_geom_limit(a6),d4
        moveq   #0,d5
        moveq   #0,d2
        moveq   #0,d3
        lea     s_projected(a6),a1
        cmpi.w  #4,s_clip_count(a6)
        bne.s   .measure_general
        ; Four vertices: exact original strict minima and tie ordering,
        ; without per-vertex pointer, index and loop bookkeeping.
        move.w  2(a1),d0
        cmp.w   d4,d0
        bge.s   .quad_first_max
        move.w  d0,d4
.quad_first_max:
        cmp.w   d5,d0
        ble.s   .quad_second
        move.w  d0,d5
.quad_second:
        move.w  6(a1),d0
        cmp.w   d4,d0
        bge.s   .quad_second_max
        move.w  d0,d4
        moveq   #4,d2
.quad_second_max:
        cmp.w   d5,d0
        ble.s   .quad_third
        move.w  d0,d5
.quad_third:
        move.w  10(a1),d0
        cmp.w   d4,d0
        bge.s   .quad_third_max
        move.w  d0,d4
        moveq   #8,d2
.quad_third_max:
        cmp.w   d5,d0
        ble.s   .quad_fourth
        move.w  d0,d5
.quad_fourth:
        move.w  14(a1),d0
        cmp.w   d4,d0
        bge.s   .quad_fourth_max
        move.w  d0,d4
        moveq   #12,d2
.quad_fourth_max:
        cmp.w   d5,d0
        ble.s   .measured
        move.w  d0,d5
        bra.s   .measured
.measure_general:
        move.w  s_clip_count(a6),d7
        subq.w  #1,d7
.measure:
        move.w  2(a1),d0
        cmp.w   d4,d0
        bge.s   .not_min
        move.w  d0,d4
        move.w  d3,d2
.not_min:
        cmp.w   d5,d0
        ble.s   .not_max
        move.w  d0,d5
.not_max:
        addq.w  #4,a1
        addq.w  #4,d3
        dbra    d7,.measure
.measured:
        move.w  d4,s_min_y(a6)
        move.w  d5,s_max_y(a6)
        move.w  d2,284(a6)
        move.w  s_geom_limit(a6),d0
        cmp.w   s_max_y(a6),d0
        bge.s   .clamped
        move.w  d0,s_max_y(a6)
.clamped:
        ; Sample the centre of four native rows, rather than quantizing
        ; vertices: ROAD32 retains ROAD128's perspective and thin rail widths.
        cmpi.w  #4,s_geom_step(a6)
        bne.s   .top_ready
        move.w  s_min_y(a6),d0
        addq.w  #4/2-1,d0
        andi.w  #-4,d0
        addq.w  #4/2,d0
        move.w  d0,s_min_y(a6)
.top_ready:
        move.w  s_min_y(a6),d0
        move.w  s_max_y(a6),d1
        sub.w   d0,d1
        ble     polygon_done
        clr.w   380(a6)
        cmpi.w  #16,d1
        blt.s   .certificate_done
        cmpi.w  #4,s_clip_count(a6)
        bne.s   .certificate_done
        lea     s_projected(a6),a0
        cmpi.w  #256,(a0)
        bhi.s   .certificate_done
        cmpi.w  #256,4(a0)
        bhi.s   .certificate_done
        cmpi.w  #256,8(a0)
        bhi.s   .certificate_done
        cmpi.w  #256,12(a0)
        bhi.s   .certificate_done
        move.w  #1,380(a6)
.certificate_done:
        move.w  s_poly_color(a6),d0
        lsl.w   #2,d0
        lea     floor_patterns-state(a6),a1
        move.l  0(a1,d0.w),s_fill_pattern(a6)
        cmpi.w  #4,s_clip_count(a6)
        bne.s   .fifteen_full_setup
        cmpi.w  #4,d1
        bls     geometry_single_quad
.fifteen_full_setup:
        lea     s_spans_left(a6),a4
        lea     s_spans_right(a6),a5
        move.w  284(a6),10(a4)
        move.w  284(a6),10(a5)
        move.w  s_min_y(a6),280(a6)
        moveq   #4,d6
        bsr     polygon_walk_edge
        exg     a4,a5
        moveq   #-4,d6
        bsr     polygon_walk_edge
        exg     a4,a5
        move.w  s_min_y(a6),d7
        cmpi.w  #4,s_geom_step(a6)
        beq     polygon_spans_four
        bra     polygon_spans_one

polygon_spans_four:
        include "road_quad_spans.asm"
polygon_spans_one:
        bra     polygon_spans_four

polygon_done:
        rts

; Walk one side of a convex polygon directly. Horizontal edges are skipped.
; State at a4: x(24.8), slope(24.8), endY, end-vertex byte index.
; d6 is +4/-4, d7 and a4/a5 are preserved. No per-row span arrays or stack saves.
polygon_walk_edge:
        cmpi.w  #4,s_clip_count(a6)
        beq     geometry_quad_edge
walk_edge_find:
        move.w  10(a4),d0
        lea     s_projected(a6),a0
        lea     0(a0,d0.w),a1
        cmpi.w  #4,s_clip_count(a6)
        bne.s   walk_edge_general_wrap
        add.w   d6,d0
        andi.w  #15,d0
        bra.s   walk_edge_wrapped
walk_edge_general_wrap:
        add.w   d6,d0
        bpl.s   walk_edge_not_negative
        move.w  s_clip_count(a6),d0
        lsl.w   #2,d0
        subq.w  #4,d0
walk_edge_not_negative:
        move.w  s_clip_count(a6),d1
        lsl.w   #2,d1
        cmp.w   d1,d0
        blt.s   walk_edge_wrapped
        clr.w   d0
walk_edge_wrapped:
        move.w  d0,10(a4)
        lea     0(a0,d0.w),a2
        move.w  2(a2),d3
        cmp.w   280(a6),d3
        ble.s   walk_edge_find
        move.w  d3,8(a4)
        move.w  (a1),d0
        move.w  (a2),d2
        sub.w   d0,d2
        sub.w   2(a1),d3
walk_edge_calculate_slope:
        bsr     ribbon_edge_math
        move.l  d4,4(a4)
        move.l  d0,(a4)
        rts

geometry_edge_math equ walk_edge_calculate_slope
ribbon_edge_math:
        tst.w   d2
        bne.s   edge_math_non_vertical
        moveq   #0,d4
        bra     edge_math_slope_ready
edge_math_non_vertical:
        ext.l   d2
        ; Try the exact signed 32/16 quotient first. DIVS leaves its
        ; dividend unchanged on overflow on the original 68000/68008.
        ; A large off-screen dx need not imply a large dx/dy slope.
        lsl.l   #8,d2
        divs.w  d3,d2
        bvs.s   edge_math_overflow_slope
        move.w  d2,d4
        ext.l   d4
        bra.s   edge_math_slope_ready
edge_math_overflow_slope:
        asr.l   #8,d2
edge_math_wide_slope:
        divs.w  d3,d2
        move.w  d2,d4
        ext.l   d4
        lsl.l   #8,d4
        swap    d2
        ext.l   d2
        lsl.l   #8,d2
        divs.w  d3,d2
        ext.l   d2
        add.l   d2,d4
edge_math_slope_ready:
        ext.l   d0
        lsl.l   #8,d0
        move.w  280(a6),d1
        sub.w   2(a1),d1
        beq.s   edge_math_start_ready
        cmpi.w  #3,d1
        blo.s   edge_math_start_loop
        move.w  d4,d2
        ext.l   d2
        cmp.l   d4,d2
        bne.s   edge_math_wide_start
        muls.w  d1,d2
        add.l   d2,d0
        bra.s   edge_math_start_ready
edge_math_wide_start:
        ; Exact 32x16 product, low unsigned half + signed high half.
        ; Replaces hundreds of additions for clipped off-screen edges.
        move.w  d4,d2
        mulu.w  d1,d2
        move.l  d4,d3
        swap    d3
        muls.w  d1,d3
        swap    d3
        clr.w   d3
        add.l   d3,d2
        add.l   d2,d0
        bra.s   edge_math_start_ready
edge_math_start_loop:
        subq.w  #1,d1
edge_math_interpolate_start:
        add.l   d4,d0
        dbra    d1,edge_math_interpolate_start
edge_math_start_ready:
        cmpi.w  #4,s_geom_step(a6)
        bne.s   edge_math_step_ready
        lsl.l   #road_band_shift,d4
edge_math_step_ready:
        ; Shift 24.8 accumulators into 16.16 storage. Reading the high word
        ; gives precisely the same signed pixel, including fractional carries.
        lsl.l   #8,d4
        lsl.l   #8,d0
        rts
        include "road_quad_fill.asm"
        include "road_hidden_bands.asm"
        include "road_geometry_runs.asm"
        include "road_contour_union.asm"

; Native-pixel edges, opaque flat middle. a0 row, d1 left, d2 exclusive
; right, d0 repeated MODE 8 pattern. Preserves a0/a3/d7/a4-a6.
; A0 is also required by sky callers that advance it across restored rows.
fill_rail_span:
        include "road_rail_fill.asm"
fill_road_span:
        include "road_register_fill.asm"
