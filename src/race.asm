; SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
; QL-Zero 1.0: fixed-address 68008 kernel for the original QL 128 KiB.
; cup_boot.asm expands this image at $2c680. A6 addresses game state.

race_period         equ 8
span_tables_long    set 0
race_fine_rows      equ 32
road_band_shift     equ 2
mc_stat             equ $18063
pc_tctrl            equ $18002
pc_ipcwr            equ $18003
pc_ipcrd            equ $18020
pc_intr             equ $18021
road_flag           equ 8
boost_flag          equ 16
wall_flag           equ 32
track_header_size   equ 96
map_saving          equ 7508
track_mesh_offset   equ 16480-map_saving
track_marker_offset equ 17504-map_saving
track_path_offset   equ 17540-map_saving
track_pvs_offset    equ 18308-map_saving
track_size          equ 19332-map_saving-512*1
render_mesh_offset  equ 17796-map_saving

s_ticks             equ 0
s_last_tick         equ 2
s_fps_tick          equ 4
s_frames            equ 6
s_fps               equ 8
s_speed             equ 10
s_vx                equ 12
s_vy                equ 14
s_x                 equ 16
s_y                 equ 18
s_angle             equ 20
s_controls          equ 22
s_old_keys          equ 24
s_quality           equ 26
s_energy            equ 28
s_laps              equ 30
s_gate              equ 32
s_race_ticks        equ 34
s_page              equ 38
s_camx              equ 42
s_camy              equ 46
s_edge_lx           equ 50
s_edge_ly           equ 52
s_edge_rx           equ 54
s_edge_ry           equ 56
s_steer             equ 58
s_boosting          equ 60
s_offroad           equ 62
s_started           equ 64
s_music_pending     equ 66
s_poll_link         equ 76
s_poll_entry        equ 80
s_text              equ 88
s_f1_latch          equ 120
s_pad_ticks         equ 122
s_cache0            equ 128
s_cache1            equ 136
s_gcamx             equ 144
s_gcamy             equ 146
s_cos               equ 148
s_sin               equ 150
s_poly_count        equ 152
s_poly              equ 154
s_clip_count        equ 186
s_clip              equ 188
s_projected         equ 224
s_poly_color        equ 248
s_min_y             equ 250
s_max_y             equ 252
s_far_lod           equ 254
s_band_active       equ 550      ; only the current aligned ROAD32 frame
s_band_compose      equ 552      ; F1 selection, formerly unused LOD scratch
; Reuse retired ribbon scratch; persistent state and its offsets stay fixed.
s_contour_base      equ 400
s_contour_next      equ 404
s_contour_end       equ 408
s_contour_collect   equ 412
s_contour_overflow  equ 414
s_contour_left      equ 632
s_contour_right     equ 634
s_contour_factor    equ 636
contour_pool_size   equ 768      ; 96 commands, inside the existing 1K stack reserve
s_spans_left        equ 256
s_spans_right       equ 512
s_floor_angle       equ 768
s_floor_quality     equ 770
s_geom_step         equ 774
s_geom_limit        equ 776
s_rail_pass         equ 778
s_geometry_valid    equ 780
s_geometry_angle    equ 782
s_world_cam_lat     equ 784
s_world_cam_depth   equ 788
s_floor_cache       equ 800
s_mesh_camera       equ 1840
s_projection_valid  equ 2368
s_projection_xy     equ 2496
s_music_offset      equ 3008
s_music_deadline    equ 3010
s_music_enabled     equ 3012
s_music_active      equ 3014
s_music_latch       equ 3016
s_music_pitch       equ 3018
s_music_effect      equ 3020
s_music_ready       equ 3022
s_ipc_failed        equ 3024
s_sound_packet      equ 3026
s_horizon           equ 3044
s_hills             equ 3046
s_ai_clock          equ 3048
s_player_section    equ 3050
s_rivals            equ 3052       ; two 16-byte independent records
s_rival_camera      equ 3160
s_opponents         equ 3092
s_options_ready     equ 3094
s_f3_latch          equ 3096
s_f4_latch          equ 3098
s_goal_horizon      equ 3100
s_bump_timer        equ 3102
s_view_horizon      equ 3104
s_sky_horizon0      equ 3106
s_sky_horizon1      equ 3108
s_fill_pattern      equ 3110
s_sprite_x          equ 3114
s_sprite_y          equ 3116
s_dead              equ 3146
s_death_ticks       equ 3148
s_wall_timer        equ 3150
s_boost_charge      equ 3152       ; reserved legacy field, no boost reserve remains
s_grip_shift        equ 3154
s_decor             equ 3156
s_render_poll       equ 3158
s_vx_fraction       equ 3172
s_vy_fraction       equ 3174
s_hit_ticks         equ 3176
s_npc_offsets       equ 3180       ; two signed x/y displacement pairs
s_music_bank        equ 3188
s_normal_factor     equ 3190
s_track_profile     equ 3192
s_pair_timer        equ 3194
s_wall_hits         equ 3196
s_npc_physics       equ 3200       ; two speed/controls/fractions/stun records, 12 bytes
s_far_depth         equ 3224       ; 8.7, limits distant polygon work only
s_f5_latch          equ 3226
s_hud_values        equ 3228       ; seven words per physical page
s_message           equ 3256
s_message_ticks     equ 3258
s_wrong_ticks       equ 3260
s_death_angle       equ 3262
s_boost_announced   equ 3264
s_sky_dirty0        equ 3268       ; byte-X left/right and top Y, six bytes/page
s_sky_dirty1        equ 3274
s_cos_plus_sin      equ 3280
s_sin_minus_cos     equ 3282
s_npc_damage        equ 3284       ; independent 32-tick hull flashes, two words
s_frame_start       equ 3288
s_frame_budget      equ 3290       ; race high-water work budget in 50 Hz ticks
s_frame_work        equ 3292
s_boost_ticks       equ 3294       ; 40 physical ticks per energy-paid boost
s_frame_warmup      equ 3296       ; exclude cold initialization of both pages
; Profiler reserves ROAD scratch 376/378 for current/published
; physics-step totals. Edge records, projection caches and NPCs do not use it.
; Profiler reserves ROAD scratch 376/378 for current/published
; physics-step totals. Edge records, projection caches and NPCs do not use it.
s_jet_clock         equ 3298
s_jet_phase         equ 3300
state_size          equ 3302

race_entry:
bare_start:
        ; Original 68008 exception vectors reside in ROM. Keep interrupts
        ; masked and sample the VBL latch frequently between rendering chunks.
        move.w  #$2700,sr
        ; QDOS can return from LBYTES with a motor still selected. Its gap
        ; server normally deselects it later; the standalone game must do so.
        bsr     stop_microdrives
        movea.l #state,a6
        movea.l a6,a0
        move.w  #state_size/4-1,d0
.clear_state:
        clr.l   (a0)+
        dbra    d0,.clear_state
        bsr     cup_boot_config
        bsr     cup_storage_init
        bsr     cup_init
        bsr     cup_initial_menu
        bsr     validate_track
        tst.l   d0
        bne     invalid_track
        lea     frame_profile-state(a6),a0
        move.w  #2,22(a0)       ; fixed resident compositor
        ; cup_load_track already reset the race, grid and mode.
        move.l  #$20000,s_page(a6)
        move.w  #1,pc_tctrl
        move.b  #$1f,pc_intr
        move.b  #8,mc_stat
        move.l  #$20000,s_page(a6)
        move.l  #$28000,s_frame_budget(a6)
        lea     frame_profile-state(a6),a0
        move.w  #2,22(a0)

        bsr     music_init
main_loop:
        move.w  s_ticks(a6),s_frame_start(a6)
        lea     frame_profile-state(a6),a0
        move.w  s_ticks(a6),10(a0)
        clr.w   24(a0)
        bsr     read_controls
        ; ESC is handled by the mode selector, never returns to discarded QDOS.
        moveq   #2,d0
        bsr     record_frame_stage
        bsr     cup_menu_frame
        tst.w   d0
        beq.s   .cup_racing
        bsr     poll_clock
        bra     main_loop
.cup_racing:
        bsr     music_update
        moveq   #4,d0
        bsr     record_frame_stage
        move.w  s_ticks(a6),d0
        move.w  d0,d1
        sub.w   s_last_tick(a6),d1
        beq     idle_wait
        move.w  d0,s_last_tick(a6)
        tst.w   s_started(a6)
        beq.s   .clock_stopped
        moveq   #0,d2
        move.w  d1,d2
        add.l   d2,s_race_ticks(a6)
.clock_stopped:
        ; Bound recovery after a pause, retaining real elapsed race time.
        cmpi.w  #25,d1
        bls.s   .steps_ready
        moveq   #25,d1
.steps_ready:
.catch_up:
        move.w  d1,-(sp)
        bsr     cup_physics_tick
        bsr     ai_tick
        bsr     cup_tick
        bsr     poll_clock        ; sustain musical time during physics catch-up
        move.w  (sp)+,d1
        tst.w   cup_phase-state(a6)
        bne.s   .cup_steps_done
        subq.w  #1,d1
        bne.s   .catch_up
.cup_steps_done:
        moveq   #6,d0
        bsr     record_frame_stage
        tst.w   cup_phase-state(a6)
        bne     main_loop
        bsr     render_frame
        bsr     cup_draw_go
        moveq   #8,d0
        bsr     record_frame_stage
        addq.w  #1,s_frames(a6)
        move.w  s_ticks(a6),d0
        sub.w   s_fps_tick(a6),d0
        cmpi.w  #50,d0
        blo.s   .no_fps_update
        moveq   #0,d1
        move.w  s_frames(a6),d1
        mulu.w  #50,d1
        divu.w  d0,d1
        move.w  d1,s_fps(a6)
        clr.w   s_frames(a6)
        move.w  s_ticks(a6),s_fps_tick(a6)
.no_fps_update:
        bsr     pace_frame
        ; Switch immediately after VBL acknowledgement. Defer any pending
        ; sound packet until the foreground render/input checkpoints: serial
        ; IPC must not spend the blanking interval before the page switch.
.wait_flip:
        btst    #3,pc_intr
        beq.s   .wait_flip
        move.b  #8,pc_intr
        addq.w  #1,s_ticks(a6)
        move.w  #1,s_music_pending(a6)
        cmpi.l  #$20000,s_page(a6)
        beq.s   .show_first
        move.b  #$88,mc_stat
        bra.s   .shown
.show_first:
        move.b  #8,mc_stat
.shown:
        ; Single-screen composite is published in completed four-row bands.
        bra     main_loop

; Keep a stable deadline after a costly view. The high-water mark never
; shrinks during this race: a fast view cannot trigger repeated fast/slow
; oscillation. Measure input, IPC, simulation and drawing, BEFORE waiting.
; Original QL VBL/QDOS 50 Hz clock only, no host timers or CPU assumptions.
pace_frame:
        ; No target period, high-water deadline, suspension or busy wait.
        ; Keep measurements only; direct mode still flips at the next VBL.
        tst.w   s_frame_warmup(a6)
        beq.s   .free_measure
        subq.w  #1,s_frame_warmup(a6)
        rts
.free_measure:
        move.w  s_ticks(a6),d0
        move.w  d1,-(sp)
        bsr     peek_vbl_ticks
        move.w  d1,d0
        move.w  (sp)+,d1
        sub.w   s_frame_start(a6),d0
        cmp.w   3198(a6),d0
        bls.s   .free_peak
        move.w  d0,3198(a6)
.free_peak:
        cmp.w   3266(a6),d0
        bhs.s   .free_minimum
        move.w  d0,3266(a6)
.free_minimum:
        lea     frame_profile-state(a6),a0
        addq.w  #1,(a0)
        cmpi.w  #64,(a0)
        blo.s   .free_done
        lea     12(a0),a1
        moveq   #4,d0
.publish_stats:
        move.w  (a0),(a1)+
        clr.w   (a0)+
        dbra    d0,.publish_stats
.free_done:
        rts

; D0 = bucket offset (input, update, simulation, drawing). Serial sound time
; is recorded by music_send, then removed from whichever stage contained it.
; One clock read per boundary; no extra IPC, no instrumentation in interrupts.
record_frame_stage:
        cmpi.w  #8,d0
        beq.s   .end_peek
        bsr     poll_vbl          ; direct mode has no interrupt-updated counter
        lea     frame_profile-state(a6),a0
        move.w  s_ticks(a6),d1
        bra.s   .timestamp_ready
.end_peek:
        lea     frame_profile-state(a6),a0
        bsr     peek_vbl_ticks
.timestamp_ready:
        move.w  d1,d2
        sub.w   10(a0),d2
        move.w  d1,10(a0)
        tst.w   s_frame_warmup(a6)
        bne.s   .cold_stage
        sub.w   24(a0),d2
        add.w   d2,0(a0,d0.w)
        move.w  24(a0),d2
        add.w   d2,4(a0)
.cold_stage:
        clr.w   24(a0)
        rts

idle_wait:
        bsr     poll_clock
        bra     main_loop

invalid_track:
        move.w  #$2700,sr
.halt_bad:
        stop    #$2700
        bra.s   .halt_bad

exit_game:
        bsr     music_stop
        move.w  #$2700,sr
        bsr     show_native_report
        move.b  #8,mc_stat
.halt:
        stop    #$2700
        bra.s   .halt

; QDOS invokes this tiny counter through its normal interrupt dispatch.
poll_counter:
        move.l  a0,-(sp)
        lea     state-state(a6),a0
        addq.w  #1,s_ticks(a0)
        move.w  #1,s_music_pending(a0)
        movea.l (sp)+,a0
        rts

; Bare-metal clock. Calls are bounded by a floor band, a skyline column,
; one ship/font row group or 256 bytes of background. Never change vectors
; in the original QL's ROM, and never clear QDOS's interrupt status.
; All foreground registers are preserved. Flags may change.
poll_clock:
        btst    #3,pc_intr
        beq.s   .no_frame
        move.b  #8,pc_intr
        addq.w  #1,s_ticks(a6)
        move.w  #1,s_music_pending(a6)
.no_frame:
        ; Cheap comparison at the existing bounded render checkpoints.
        ; This is foreground code, so it cannot interrupt a KEYROW packet.
        tst.w   s_music_pending(a6)
        beq.s   .done
        clr.w   s_music_pending(a6)
        bra     music_update
.done:
        rts

; Timestamp only: preserve every register and leave sound pending. This may
; be called inside music_send, where dispatching music would recurse.
poll_vbl:
        btst    #3,pc_intr
        beq.s   .done
        move.b  #8,pc_intr
        addq.w  #1,s_ticks(a6)
        move.w  #1,s_music_pending(a6)
.done:
        rts

; Timestamp only at end of frame: preserve a pending VBL for the presenter.
peek_vbl_ticks:
        move.w  s_ticks(a6),d1
        btst    #3,pc_intr
        beq.s   .done
        addq.w  #1,d1
.done:
        rts
validate_track:
        lea     state-state(a6),a0
        adda.l  #track_buffer-state,a0
        cmpi.l  #$515a5231,(a0)       ; QZR1
        bne.s   .bad
        cmpi.w  #8,4(a0)
        bne.s   .bad
        cmpi.w  #128,6(a0)
        bne.s   .bad
        cmpi.w  #128,8(a0)
        bne.s   .bad
        cmpi.w  #64,64(a0)
        bne.s   .bad
        cmpi.w  #track_mesh_offset,66(a0)
        bne.s   .bad
        cmpi.w  #2,68(a0)
        bne.s   .bad
        cmpi.w  #track_marker_offset,70(a0)
        bne.s   .bad
        cmpi.w  #track_path_offset,72(a0)
        bne.s   .bad
        cmpi.w  #32768,10(a0)
        bhs.s   .bad
        cmpi.w  #32768,12(a0)
        bhs.s   .bad
        moveq   #0,d0
        rts
.bad:
        moveq   #-15,d0
        rts

reset_race:
        ; Direct routine tests enter through reset_race rather than race_entry.
        tst.w   s_options_ready(a6)
        bne.s   .band_mode_ready
        move.w  #1,s_band_compose(a6)
.band_mode_ready:
        lea     frame_profile-state(a6),a0
        move.w  22(a0),d1        ; retain allocation status through ENTER
        moveq   #12,d0
.clear_profile:
        clr.w   (a0)+
        dbra    d0,.clear_profile
        lea     frame_profile-state(a6),a0
        move.w  d1,22(a0)
        clr.w   34(a0)
        move.w  #-1,36(a0)       ; invalidate cached message, keep sys pointers
        clr.l   38(a0)
        clr.w   42(a0)
        clr.w   3198(a6)        ; measured maximum, not the cadence budget
        move.w  #-1,3266(a6)    ; measured minimum
        clr.w   3170(a6)
        move.w  #3,s_frame_warmup(a6)
        clr.w   s_boost_ticks(a6)
        clr.w   s_geometry_valid(a6)
        move.l  #$00800000,s_sky_dirty0(a6)
        move.l  #$00800000,s_sky_dirty1(a6)
        clr.w   s_sky_dirty0+4(a6)
        clr.w   s_sky_dirty1+4(a6)
        move.w  #-1,s_cache0+6(a6)
        move.w  #-1,s_cache1+6(a6)
        lea     s_hud_values(a6),a1
        moveq   #6,d0
.invalidate_hud:
        move.l  #-1,(a1)+
        dbra    d0,.invalidate_hud
        clr.w   s_message(a6)
        clr.w   s_message_ticks(a6)
        clr.w   s_wrong_ticks(a6)
        clr.w   s_boost_announced(a6)
        lea     state-state(a6),a0
        adda.l  #track_buffer-state,a0
        move.w  10(a0),s_x(a6)
        move.w  12(a0),s_y(a6)
        move.w  14(a0),d0
        andi.w  #255,d0
        move.w  d0,s_angle(a6)
        clr.w   s_speed(a6)
        clr.w   s_vx(a6)
        clr.w   s_vy(a6)
        clr.w   s_vx_fraction(a6)
        clr.w   s_vy_fraction(a6)
        clr.w   s_laps(a6)
        clr.w   s_started(a6)
        clr.w   s_pad_ticks(a6)
        clr.l   s_race_ticks(a6)
        move.w  #255,s_energy(a6)
        move.w  #255,s_boost_charge(a6)
        move.w  s_ticks(a6),s_jet_clock(a6)
        clr.w   s_jet_phase(a6)
        clr.w   s_dead(a6)
        clr.w   s_death_ticks(a6)
        clr.w   s_wall_timer(a6)
        clr.w   s_hit_ticks(a6)
        clr.w   s_wall_hits(a6)
        clr.w   s_pair_timer(a6)
        clr.l   s_npc_offsets(a6)
        clr.l   s_npc_offsets+4(a6)
        move.w  74(a0),s_music_bank(a6)
        move.w  76(a0),s_track_profile(a6)
        move.w  78(a0),s_normal_factor(a6)
        bne.s   .normal_ready
        move.w  #22,s_normal_factor(a6)
.normal_ready:
        move.w  #3,s_render_poll(a6)
        move.w  #1,s_gate(a6)
        bsr     race_init
        rts

read_controls:
        moveq   #1,d0
        bsr     read_keyrow
        move.w  d0,s_controls(a6)
        moveq   #7,d0          ; CTRL: QL matrix contact 57, row 7 bit 1
        bsr     read_keyrow
        btst    #1,d0
        beq.s   .ctrl_done
        ori.w   #256,s_controls(a6)
.ctrl_done:
        ; Flight keys (row 1: arrows, SPACE, ENTER, ESC) remain sampled on
        ; EVERY frame. Query option-only row 0 every other frame to save a

        eori.w  #1,3170(a6)
        tst.w   3170(a6)
        beq     .keys_done
        moveq   #0,d0
        bsr     read_keyrow
        move.w  d0,d3
        bsr     read_extra_controls
        btst    #3,d3                ; F2 = row 0, bit 3 (QL matrix contact 3)
        beq.s   .f2_up
        tst.w   s_music_latch(a6)
        bne.s   .f2_done
        move.w  #1,s_music_latch(a6)
        bsr     music_toggle
        bra.s   .f2_done
.f2_up:
        clr.w   s_music_latch(a6)
.f2_done:
        move.w  d3,d0
        andi.w  #2,d0                ; F1 = row 0, bit 1
        tst.w   d0
        beq.s   .f1_up
        tst.w   s_f1_latch(a6)
        bne.s   .keys_done
        move.w  #1,s_f1_latch(a6)
        clr.w   s_far_lod(a6)
        eori.w  #1,s_band_compose(a6)
        move.w  #-1,s_cache0+6(a6)
        move.w  #-1,s_cache1+6(a6)
        bsr     reset_render_measurements
        bra.s   .keys_done
.f1_up:
        clr.w   s_f1_latch(a6)
.keys_done:
        bsr     poll_clock
        rts

read_keyrow:
        movem.l d1-d3/a3,-(sp)
        ; Same IPC bit-serial protocol as our raycaster.
        clr.w   s_ipc_failed(a6)
        move.w  sr,-(sp)
        ori.w   #$0700,sr
        move.w  d0,-(sp)
        moveq   #9,d0
        bsr.s   ipc_nibble
        move.w  (sp)+,d0
        bsr.s   ipc_nibble
        tst.w   s_ipc_failed(a6)
        bne.s   .read_failed
        moveq   #0,d0
        moveq   #7,d2
.read_bit:
        move.b  #14,pc_ipcwr
        move.w  #4095,d3
.read_wait:
        btst    #6,pc_ipcrd
        beq.s   .read_ready
        dbra    d3,.read_wait
        move.w  #1,s_ipc_failed(a6)
        bra.s   .read_failed
.read_ready:
        move.b  pc_ipcrd,d1
        add.b   d1,d1
        addx.b  d0,d0
        dbra    d2,.read_bit
        bra.s   .read_done
.read_failed:
        moveq   #0,d0
.read_done:
        move.w  (sp)+,sr
        andi.w  #255,d0
        movem.l (sp)+,d1-d3/a3
        rts

ipc_nibble:
        tst.w   s_ipc_failed(a6)
        bne.s   .skip
        ; Four encoded wire bytes replace per-bit carry/shift construction.
        ; Identical 8049 handshake, timeout and MSB-first bit order. A1 and D2
        ; are restored, so KEYROW and foreground music retain their callers.
        move.l  a1,-(sp)
        move.w  d2,-(sp)
        andi.w  #15,d0
        lsl.w   #2,d0
        lea     ipc_wire_bits(pc),a1
        move.l  0(a1,d0.w),d1
        moveq   #3,d0
.wire_bit:
        rol.l   #8,d1
        move.b  d1,pc_ipcwr
        move.w  #4095,d2
.wire_wait:
        btst    #6,pc_ipcrd
        beq.s   .wire_ready
        dbra    d2,.wire_wait
        move.w  #1,s_ipc_failed(a6)
        bra.s   .wire_done
.wire_ready:
        dbra    d0,.wire_bit
.wire_done:
        move.w  (sp)+,d2
        movea.l (sp)+,a1
.skip:
        rts
ipc_wire_bits:
        dc.l $0c0c0c0c,$0c0c0c0e,$0c0c0e0c,$0c0c0e0e
        dc.l $0c0e0c0c,$0c0e0c0e,$0c0e0e0c,$0c0e0e0e
        dc.l $0e0c0c0c,$0e0c0c0e,$0e0c0e0c,$0e0c0e0e
        dc.l $0e0e0c0c,$0e0e0c0e,$0e0e0e0c,$0e0e0e0e

; 50 Hz, unsigned position 8.8, signed velocity 8.8, 256 headings.
physics_tick:
        bsr     message_tick
        tst.w   s_dead(a6)
        beq.s   .alive
        cmpi.w  #448,s_death_ticks(a6)
        bhs.s   .dead_done
        addq.w  #1,s_death_ticks(a6)
        move.w  s_death_ticks(a6),d0
        subi.w  #64,d0
        blt.s   .dead_done
        cmpi.w  #128,d0
        blo.s   .fast_orbit
        subi.w  #128,d0
        bra.s   .orbit_angle
.fast_orbit:
        add.w   d0,d0
.orbit_angle:
        add.w   s_death_angle(a6),d0
        andi.w  #255,d0
        move.w  d0,s_angle(a6)
.dead_done:
        rts
.alive:
        tst.w   s_hit_ticks(a6)
        beq.s   .hit_ready
        subq.w  #1,s_hit_ticks(a6)
.hit_ready:
        tst.w   s_wall_timer(a6)
        beq.s   .wall_ready
        subq.w  #1,s_wall_timer(a6)
.wall_ready:
        move.w  s_controls(a6),d7
        clr.w   s_boosting(a6)
        clr.w   s_steer(a6)
        move.w  s_speed(a6),d0
        btst    #2,d7
        beq.s   .coast
        move.w  #1,s_started(a6)
        addq.w  #1,d0
        bra.s   .brake
.coast:
        move.w  s_ai_clock(a6),d2
        andi.w  #1,d2
        bne.s   .brake
        subq.w  #1,d0
.brake:
        btst    #7,d7
        beq.s   .boost
        subq.w  #4,d0
.boost:
        moveq   #80,d1
        tst.w   s_pad_ticks(a6)
        beq.s   .manual_boost
        subq.w  #1,s_pad_ticks(a6)
        move.w  #1,s_boosting(a6)
        addq.w  #2,d0
        moveq   #112,d1
.manual_boost:
        tst.w   s_boost_ticks(a6)
        bne.s   .boost_active
        btst    #6,d7
        beq.s   .limit
        cmpi.w  #3,cup_mode-state(a6)
        beq.s   .practice_boost
        cmpi.w  #2,cup_mode-state(a6)
        beq.s   .practice_boost
        tst.w   s_laps(a6)         ; completed lap 1 => current lap 2
        beq.s   .limit
.practice_boost:
        cmpi.w  #1,s_energy(a6)
        bls.s   .limit             ; boost never spends the last energy point
        move.w  d0,-(sp)
        move.w  s_energy(a6),d2
        subq.w  #1,d2
        cmpi.w  #32,d2
        blo.s   .partial_boost
        moveq   #32,d0
        moveq   #40,d2
        bra.s   .boost_payment
.partial_boost:
        move.w  d2,d0              ; spend only what lies above the reserve
        mulu.w  #40,d2
        lsr.l   #5,d2              ; duration proportional to the paid energy
.boost_payment:
        move.w  d2,-(sp)
        bsr     take_damage
        move.w  (sp)+,s_boost_ticks(a6)
        move.w  (sp)+,d0
.boost_active:
        subq.w  #1,s_boost_ticks(a6)
        move.w  #1,s_boosting(a6)
        addq.w  #2,d0
        moveq   #112,d1
.limit:
        ; A small slope load only on every fourth physics step, and only
        ; outside boost. The pitch profile is independent of render FPS.
        tst.w   s_hills(a6)
        beq.s   .grade_done
        tst.w   s_boosting(a6)
        bne.s   .grade_done
        cmpi.w  #96,s_goal_horizon(a6)
        beq.s   .grade_done
        blt.s   .downhill
        moveq   #76,d1
        move.w  s_ai_clock(a6),d2
        andi.w  #3,d2
        bne.s   .grade_done
        subq.w  #1,d0
        bra.s   .grade_done
.downhill:
        moveq   #84,d1
        move.w  s_ai_clock(a6),d2
        andi.w  #3,d2
        bne.s   .grade_done
        addq.w  #1,d0
.grade_done:
        tst.w   d0
        bpl.s   .positive
        clr.w   d0
.positive:
        cmp.w   d1,d0
        bls.s   .limited
        move.w  d1,d0
.limited:
        move.w  d0,s_speed(a6)
        ; High-speed throttle retains lateral momentum for ~32 ticks.
        ; Boost stretches that to 64; lifting restores 8-tick grip.
        moveq   #1,d3
        move.w  #3,s_grip_shift(a6)
        cmpi.w  #49,d0
        blo.s   .throttle_grip
        move.w  #4,s_grip_shift(a6)
        cmpi.w  #65,d0
        blo.s   .throttle_grip
        move.w  #5,s_grip_shift(a6)
        cmpi.w  #96,d0
        blo.s   .throttle_grip
        move.w  #6,s_grip_shift(a6)
.throttle_grip:
        btst    #2,d7
        bne.s   .grip_ready
        move.w  #3,s_grip_shift(a6)
        cmpi.w  #32,d0
        blo.s   .grip_ready
        moveq   #2,d3
.grip_ready:
        btst    #7,d7
        beq.s   .steering_ready
        move.w  #2,s_grip_shift(a6)
.steering_ready:
        tst.w   s_hit_ticks(a6)
        beq.s   .grip_final
        move.w  #5,s_grip_shift(a6)
.grip_final:
        cmpi.w  #4,d0
        blo.s   .heading_done
        btst    #1,d7
        beq.s   .right
        sub.w   d3,s_angle(a6)
        subq.w  #1,s_steer(a6)
.right:
        btst    #4,d7
        beq.s   .heading_done
        add.w   d3,s_angle(a6)
        addq.w  #1,s_steer(a6)
.heading_done:
        andi.w  #255,s_angle(a6)
        move.w  s_angle(a6),d6
        add.w   d6,d6
        lea     direction_x-state(a6),a0
        move.w  0(a0,d6.w),d1
        muls.w  d0,d1
        asr.l   #8,d1
        sub.w   s_vx(a6),d1
        add.w   s_vx_fraction(a6),d1
        move.w  d1,d4
        move.w  s_grip_shift(a6),d3
        asr.w   d3,d1
        add.w   d1,s_vx(a6)
        lsl.w   d3,d1
        sub.w   d1,d4
        move.w  d4,s_vx_fraction(a6)
        lea     direction_y-state(a6),a0
        move.w  0(a0,d6.w),d2
        muls.w  d0,d2
        asr.l   #8,d2
        sub.w   s_vy(a6),d2
        add.w   s_vy_fraction(a6),d2
        move.w  d2,d4
        asr.w   d3,d2
        add.w   d2,s_vy(a6)
        lsl.w   d3,d2
        sub.w   d2,d4
        move.w  d4,s_vy_fraction(a6)
        ; Once stopped, snap tiny negative fixed-point residuals to zero.
        tst.w   s_speed(a6)
        bne.s   .move
        clr.w   s_vx(a6)
        clr.w   s_vy(a6)
.move:
        move.w  s_x(a6),d1
        add.w   s_vx(a6),d1
        move.w  s_y(a6),d2
        add.w   s_vy(a6),d2
        cmpi.w  #256,d1
        blo     .collision
        cmpi.w  #32512,d1
        bhs     .collision
        cmpi.w  #256,d2
        blo     .collision
        cmpi.w  #32512,d2
        bhs     .collision
        move.w  d1,d3
        lsr.w   #8,d3
        move.w  d2,d4
        lsr.w   #1,d4
        andi.w  #$3f80,d4
        or.w    d3,d4
        bsr     map_sample
        move.w  d5,d0
        andi.w  #40,d0
        cmpi.w  #8,d0            ; asphalt only, including gaps in raster rails
        bne     .collision
        lea     s_x(a6),a1
        bsr     trace_wall
        tst.w   d0
        bne.s   .collision
        move.w  d1,s_x(a6)
        move.w  d2,s_y(a6)
        clr.w   s_offroad(a6)
        btst    #3,d5
        bne.s   .on_road
        move.w  #1,s_offroad(a6)
        cmpi.w  #32,s_speed(a6)
        bls.s   .on_road
        subq.w  #3,s_speed(a6)
.on_road:
        btst    #6,d5
        beq.s   .repair_done
        addq.w  #3,s_energy(a6)
        cmpi.w  #255,s_energy(a6)
        bls.s   .repair_done
        move.w  #255,s_energy(a6)
.repair_done:
        btst    #4,d5
        beq.s   .gates
        move.w  #35,s_pad_ticks(a6)
        cmpi.w  #112,s_speed(a6)
        bhs.s   .gates
        addq.w  #2,s_speed(a6)
.gates:
        bsr     check_gate
        rts
.collision:
        tst.w   s_wall_timer(a6)
        bne.s   .bounce
        move.w  s_speed(a6),d0
        lsr.w   #3,d0
        addq.w  #8,d0
        move.w  #10,s_wall_timer(a6)
        addq.w  #1,s_wall_hits(a6)
        bsr     take_damage
        tst.w   s_dead(a6)
        bne.s   .collision_done
.bounce:
        cmpi.w  #10,s_wall_timer(a6)
        bne.s   .rebound
        asr.w   s_speed(a6)
.rebound:
        bsr     wall_bounce
.collision_done:
        rts

; D0 positive damage. Death is latched once, freezes the course and leaves
; restart/quality/music keys available. No frame-rate dependent damage.
take_damage:
        tst.w   cup_attack_ticks-state(a6)
        bne     .done
        cmpi.w  #2,cup_mode-state(a6)
        beq     .done
        sub.w   d0,s_energy(a6)
        bgt.s   .done
        clr.w   s_energy(a6)
        move.w  #1,s_dead(a6)
        move.w  s_angle(a6),s_death_angle(a6)
        clr.w   s_death_ticks(a6)
        clr.w   s_started(a6)
        clr.w   s_speed(a6)
        clr.w   s_vx(a6)
        clr.w   s_vy(a6)
        clr.w   s_boosting(a6)
        clr.w   s_boost_ticks(a6)
.done:
        rts

check_gate:
        tst.w   cup_finishing-state(a6)
        bne     .outside
        tst.w   s_gate(a6)
        bne.s   .checkpoint
        move.l  d7,-(sp)
        moveq   #0,d7
        bsr     cup_line_cross
        move.l  (sp)+,d7
        tst.w   d0
        beq     .outside
.checkpoint:
        move.w  s_gate(a6),d0
        lsl.w   #3,d0
        lea     state-state(a6),a0
        adda.l  #track_buffer-state+32,a0
        adda.w  d0,a0
        cmp.w   (a0),d1
        blo.s   .outside
        cmp.w   2(a0),d2
        blo.s   .outside
        cmp.w   4(a0),d1
        bhi.s   .outside
        cmp.w   6(a0),d2
        bhi.s   .outside
        tst.w   s_gate(a6)
        bne.s   .next
        addq.w  #1,s_laps(a6)
        bsr     cup_capture_lap
        cmpi.w  #3,cup_mode-state(a6)
        beq     .next
        cmpi.w  #2,cup_mode-state(a6)
        beq     .next
        cmpi.w  #1,s_laps(a6)
        bne.s   .not_boost_lap
        move.w  #1,s_boost_announced(a6)
        move.w  #1,s_message(a6)
        move.w  #100,s_message_ticks(a6)
.not_boost_lap:
        cmpi.w  #2,s_laps(a6)
        bne.s   .not_final
        move.w  #2,s_message(a6)
        move.w  #125,s_message_ticks(a6)
.not_final:
        cmpi.w  #3,s_laps(a6)
        bne.s   .next
        move.w  #4,s_message(a6)
        move.w  #150,s_message_ticks(a6)
.next:
        addq.w  #1,s_gate(a6)
        andi.w  #3,s_gate(a6)
.outside:
        rts

render_frame:
        clr.w   s_quality(a6)
        clr.w   s_quality(a6)   ; this QDOS build keeps ROAD32 only
        move.w  s_horizon(a6),s_view_horizon(a6)
        lea     frame_profile-state(a6),a0
        cmpi.w  #2,22(a0)
        beq.s   .background_deferred
        bsr     prepare_background
.background_deferred:
        ; ROAD: higher/wider camera, 3.5 units behind, vehicle at y~160.
        ; Affine comparison modes retain the original 1.75-unit camera.
        move.w  #896,d5
        move.w  s_angle(a6),d6
        add.w   d6,d6
        lea     direction_x-state(a6),a0
        move.w  0(a0,d6.w),d0
        muls.w  d5,d0
        asr.l   #8,d0
        moveq   #0,d1
        move.w  s_x(a6),d1
        sub.l   d0,d1
        lsl.l   #8,d1
        move.l  d1,s_camx(a6)
        lea     direction_y-state(a6),a0
        move.w  0(a0,d6.w),d0
        muls.w  d5,d0
        asr.l   #8,d0
        moveq   #0,d1
        move.w  s_y(a6),d1
        sub.l   d0,d1
        lsl.l   #8,d1
        move.l  d1,s_camy(a6)
        bsr     draw_road
        lea     frame_profile-state(a6),a0
        cmpi.w  #2,22(a0)
        bne.s   .ordinary_qdos
        bsr     prepare_scene_overlays
        bsr     present_composite_scene
        bsr     update_hud
        rts
.ordinary_qdos:
        bsr     draw_rivals
        bsr     draw_ship
        bsr     update_hud
        bsr     draw_race_message
        rts

; Two independent cache records: neither double-buffer page may rely on the

select_cache:
        lea     s_cache0(a6),a5
        cmpi.l  #$20000,s_page(a6)
        beq.s   .selected
        lea     s_cache1(a6),a5
.selected:
        rts

prepare_background:
        bsr     select_cache
        tst.w   (a5)
        bne.s   .check_sky
        movea.l s_page(a6),a0
        moveq   #0,d0
        moveq   #11,d7
        bsr     fill_256bytes
        movea.l s_page(a6),a0
        adda.w  #224*128,a0
        moveq   #15,d7
        bsr     fill_256bytes
        bsr     draw_hud_static
        move.w  #1,(a5)
        move.w  #-1,2(a5)
        move.w  #-1,6(a5)
.check_sky:
        bsr     restore_sky_sprites
        move.w  s_angle(a6),d0
        lsr.w   #2,d0
        andi.w  #31,d0
        cmp.w   2(a5),d0
        bne.s   .redraw_sky
        bsr     sky_horizon_cache
        move.w  s_view_horizon(a6),d1
        cmp.w   (a4),d1
        beq.s   .sky_done
.redraw_sky:
        bsr     sky_horizon_cache
        cmpi.w  #24,(a4)
        blt.s   .initial_sky
        bsr     update_sky_columns
        bsr     sky_horizon_cache
        move.w  s_view_horizon(a6),(a4)
        move.w  s_angle(a6),d0
        lsr.w   #2,d0
        andi.w  #31,d0
        move.w  d0,2(a5)
        bra.s   .sky_done
.initial_sky:
        move.w  s_view_horizon(a6),(a4)
        move.w  d0,2(a5)
        movea.l s_page(a6),a0
        adda.w  #24*128,a0
        move.l  cup_sky_color-state(a6),d0
        move.w  s_view_horizon(a6),d7
        subi.w  #24,d7
        lsr.w   #1,d7
        subq.w  #1,d7
        bsr     fill_256bytes
        bsr     draw_sky_clouds
        bsr     draw_skyline
.sky_done:
        rts

sky_horizon_cache:
        lea     s_sky_horizon0(a6),a4
        cmpi.l  #$20000,s_page(a6)
        beq.s   .done
        lea     s_sky_horizon1(a6),a4
.done:
        rts

update_hud:
        bra     cup_update_hud

; Eight identical longwords per MOVEM: fewer instruction fetches on a 68008.
; a0 destination, d0 pattern, d7 number of 256-byte chunks minus one.
fill_256bytes:
        move.l  d0,d1
        move.l  d0,d2
        move.l  d0,d3
        move.l  d0,d4
        move.l  d0,d5
        move.l  d0,d6
        movea.l d0,a1
.chunk:
        movem.l d0-d6/a1,(a0)
        movem.l d0-d6/a1,32(a0)
        movem.l d0-d6/a1,64(a0)
        movem.l d0-d6/a1,96(a0)
        movem.l d0-d6/a1,128(a0)
        movem.l d0-d6/a1,160(a0)
        movem.l d0-d6/a1,192(a0)
        movem.l d0-d6/a1,224(a0)
        adda.w  #256,a0
        bsr     poll_clock
        dbra    d7,.chunk
        rts

draw_skyline:
        ; 32 chunky city silhouettes, scrolling with the camera heading.
        movea.l #city_heights,a1
        move.w  s_angle(a6),d3
        lsr.w   #2,d3
        andi.w  #31,d3
        moveq   #0,d4
        moveq   #31,d5
.building:
        moveq   #0,d2
        move.b  0(a1,d3.w),d2
        movea.l s_page(a6),a0
        move.w  s_view_horizon(a6),d1
        sub.w   d2,d1
        lsl.w   #7,d1
        adda.w  d1,a0
        adda.w  d4,a0
        subq.w  #1,d2
        move.l  cup_city_color-state(a6),d0
.building_row:
        move.l  d0,(a0)
        adda.w  #128,a0
        dbra    d2,.building_row
        addq.w  #4,d4
        addq.w  #1,d3
        andi.w  #31,d3
        bsr     poll_clock
        dbra    d5,.building
        rts

; floor kernels are generated from one template, differing only in block size.
floor_low:
floor_wide:
floor_medium:
floor_high:
        bra     draw_road
        include "road.asm"
        include "road_prepare.asm"
        include "native_report.asm"
        include "sky.asm"
        include "sky_theme.asm"
; Mode comparisons must never mix the two modes in one 64-frame window.
reset_render_measurements:
        lea     frame_profile-state(a6),a0
        moveq   #10,d0
.clear:
        clr.w   (a0)+
        dbra    d0,.clear
        clr.w   3198(a6)
        move.w  #-1,3266(a6)
        move.w  #3,s_frame_warmup(a6)
        rts
; Keep the selected level beside the native report title (caller row D2).
show_lod_report:
        movem.l d0-d4/a1,-(sp)
        move.w  s_band_compose(a6),d0
        lsl.w   #3,d0
        lea     band_mode_names(pc),a1
        adda.w  d0,a1
        moveq   #100,d1
        moveq   #7,d4
        bsr     draw_text
        movem.l (sp)+,d0-d4/a1
        rts
        include "cup.asm"
        include "music.asm"
        include "rivals.asm"
        include "npc_physics.asm"
        include "collisions.asm"
        include "compact_map.asm"
        include "messages.asm"

jet_normal_y equ 172
jet_boost_y equ 170
draw_ship:
        cmpi.w  #9,cup_phase-state(a6)
        bne.s   .ordinary_draw
        tst.w   podium_stage-state(a6)
        beq.s   .ordinary_draw
        rts
.ordinary_draw:
        cmpi.w  #3,cup_mode-state(a6)
        beq.s   .ordinary_ship
        tst.w   cup_finishing-state(a6)
        bne     cup_draw_finish_ship
.ordinary_ship:
        tst.w   s_dead(a6)
        bne     draw_explosion
        tst.w   cup_attack_ticks-state(a6)
        bne     cup_draw_attack
        movea.l s_page(a6),a0
        adda.w  #156*128+52,a0
        cmpi.w  #8,s_hit_ticks(a6)
        bls.s   .compiled_normal
        lea     ship_1(pc),a1
        moveq   #29,d2
        bsr     blit_player_white
        bra.s   .compiled_done
.compiled_normal:
        lea     ship_1(pc),a1
        moveq   #29,d2
        bsr     blit_player
.compiled_done:
        tst.w   s_boosting(a6)
        bne.s   .jets
        tst.w   s_speed(a6)
        beq.s   .done
        btst    #2,s_controls+1(a6)
        beq.s   .done
.jets:
        move.l  d7,-(sp)
        move.w  #jet_normal_y*128,d7
        move.w  s_steer(a6),d0
        addq.w  #1,d0
        lsl.w   #2,d0
        bsr     jet_animation_phase
        add.w   d1,d1
        add.w   d1,d0
        tst.w   s_boosting(a6)
        beq.s   .jet_bank
        addi.w  #12,d0
        move.w  #jet_boost_y*128,d7
.jet_bank:
        move.w  d0,d5
        lea     jet_offsets(pc),a1
        move.w  0(a1,d0.w),d0
        lea     jet_base(pc),a1
        adda.w  d0,a1
        move.w  (a1)+,d6
        subq.w  #1,d6
        movea.l s_page(a6),a0
        adda.w  d7,a0
        adda.w  #54,a0
        move.w  d6,d2
        bsr     blit_player
        lea     jet_right_offsets(pc),a1
        move.w  0(a1,d5.w),d0
        lea     jet_right_base(pc),a1
        adda.w  d0,a1
        move.w  (a1)+,d6
        subq.w  #1,d6
        movea.l s_page(a6),a0
        adda.w  d7,a0
        adda.w  #66,a0
        move.w  d6,d2
        bsr     blit_player
        move.l  (sp)+,d7
.done:
        rts

; Toggle at most once per displayed frame. Never skip an even number of
; phases on a slow 68008; fast machines retain a bounded 80ms pulse interval.
jet_animation_phase:
        move.w  s_ticks(a6),d1
        sub.w   s_jet_clock(a6),d1
        cmpi.w  #4,d1
        blo.s   .ready
        move.w  s_ticks(a6),s_jet_clock(a6)
        eori.w  #1,s_jet_phase(a6)
.ready:
        move.w  s_jet_phase(a6),d1
        rts

draw_explosion:
        ; Four prepacked wreck orientations, centered at the actual projected
        ; ground point. During orbit only the camera heading changes.
        move.w  s_death_angle(a6),d0
        sub.w   s_angle(a6),d0
        addi.w  #32,d0
        andi.w  #255,d0
        lsr.w   #6,d0
        add.w   d0,d0
        lea     wreck_offsets(pc),a1
        move.w  0(a1,d0.w),d0
        lea     wreck_base(pc),a1
        adda.w  d0,a1
        movea.l s_page(a6),a0
        move.w  s_view_horizon(a6),d0
        addi.w  #46,d0
        lsl.w   #7,d0
        adda.w  d0,a0
        adda.w  #58,a0
        moveq   #17,d2
        bsr     blit_player
        move.w  s_death_ticks(a6),d0
        cmpi.w  #64,d0
        bhs.s   .done
        lsr.w   #3,d0
        add.w   d0,d0
        lea     explosion_offsets(pc),a1
        move.w  0(a1,d0.w),d0
        lea     explosion_base(pc),a1
        adda.w  d0,a1
        movea.l s_page(a6),a0
        move.w  s_view_horizon(a6),d0
        addi.w  #35,d0
        lsl.w   #7,d0
        adda.w  d0,a0
        adda.w  #52,a0
        bsr     blit_fire
.done:
        rts

; Lossless 2-bit explosion records, decode four pixels with one lookup.
; Used only in the death sequence; transparent gaps don't touch VRAM.
blit_fire:
        lea     frame_profile-state(a6),a2
        tst.w   42(a2)
        bne     queue_fire_overlay
        lea     fire_decode(pc),a2
        moveq   #39,d2
.row:
        movea.l a0,a3
        moveq   #0,d0
        move.b  (a1)+,d0
        adda.w  d0,a0
        moveq   #0,d1
        move.b  (a1)+,d1
        beq.s   .next
        subq.w  #1,d1
.word:
        moveq   #0,d0
        move.b  (a1)+,d0
        bsr     cup_fire_word
        move.w  d3,(a0)+
        dbra    d1,.word
.next:
        movea.l a3,a0
        adda.w  #128,a0
        bsr     poll_clock
        dbra    d2,.row
        rts

; Lossless row runs. Opaque runs copy two words per longword; masked runs
; merge only the occupied words. Transparent gaps are skipped by their offset.
        include "sprite_runs.asm"
        include "scene_compositor.asm"

draw_hud_static:
        bra     cup_hud_static
draw_hud:
        bra     cup_hud_draw
        include "cup_hud.asm"

; d0 unsigned integer, a1 three-character destination; preserves a1.
format_three:
        andi.l  #$ffff,d0
        divu.w  #1000,d0
        swap    d0
        andi.l  #$ffff,d0
        divu.w  #100,d0
        addi.b  #'0',d0
        move.b  d0,(a1)
        swap    d0
        andi.l  #$ffff,d0
        divu.w  #10,d0
        addi.b  #'0',d0
        move.b  d0,1(a1)
        swap    d0
        addi.b  #'0',d0
        move.b  d0,2(a1)
        rts

; a1 text, d1 byte X, d2 row Y, d4 max chars. Opaque 8x8 native MODE 8 font.
draw_text:
        movem.l d0-d7/a0-a3/a5,-(sp)
        movea.l s_page(a6),a0
        lsl.w   #7,d2
        adda.w  d2,a0
        adda.w  d1,a0
        lea     font_glyphs(pc),a2
        subq.w  #1,d4
.character:
        moveq   #0,d0
        move.b  (a1)+,d0
        beq.s   .text_done
        cmpi.b  #'a',d0
        blo.s   .case_ready
        cmpi.b  #'z',d0
        bhi.s   .case_ready
        subi.b  #32,d0
.case_ready:
        subi.w  #32,d0
        cmpi.w  #63,d0
        bls.s   .printable
        moveq   #31,d0
.printable:
        lsl.w   #3,d0
        lea     0(a2,d0.w),a3
        lea     font_decode(pc),a5
        moveq   #0,d0
        move.b  (a3)+,d0
        move.l  0(a5,d0.w),0(a0)
        move.b  (a3)+,d0
        move.l  0(a5,d0.w),128(a0)
        move.b  (a3)+,d0
        move.l  0(a5,d0.w),256(a0)
        move.b  (a3)+,d0
        move.l  0(a5,d0.w),384(a0)
        move.b  (a3)+,d0
        move.l  0(a5,d0.w),512(a0)
        move.b  (a3)+,d0
        move.l  0(a5,d0.w),640(a0)
        move.b  (a3)+,d0
        move.l  0(a5,d0.w),768(a0)
        move.b  (a3)+,d0
        move.l  0(a5,d0.w),896(a0)
        addq.w  #4,a0
        bsr     poll_clock
        dbra    d4,.character
.text_done:
        movem.l (sp)+,d0-d7/a0-a3/a5
        rts

        include "mdv_stop.asm"

floor_patterns:
        dc.l $00000000,$00550055,$00aa00aa,$00ff00ff
        dc.l $aa00aa00,$aa55aa55,$aaaaaaaa,$aaffaaff
        dc.l $0055aa55,$00ffaaff
        include "data/sky_theme.inc"
city_heights:
        dc.b 12,24,18,8,32,20,14,28,10,18,36,14,22,8,26,16
        dc.b 20,30,12,24,10,16,28,8,20,14,32,18,10,24,16,12
hud_speed: dc.b 'SPD ',0
hud_lap: dc.b 'LAP ',0
hud_fps: dc.b 'FPS ',0
hud_quality: dc.b 'F1: ',0
hud_keys: dc.b 'ARROWS SPACE F1-5 OPT ESC STATS',0
hud_sec: dc.b 'SEC',0
energy_text: dc.b 'ENERGIE',0
boost_text: dc.b 'BOOST',0
boost_locked: dc.b 'LAP 2  ',0
boost_ready: dc.b 'READY! ',0
lost_text: dc.b 'COURSE PERDUE',0
restart_text: dc.b 'ENTREE RECOMMENCER',0
quality_names:
        dc.b 'ROAD32 ',0
        even
band_mode_names:
        dc.b 'GEOM15 ',0,'UNION20',0
key_packet:
        dc.b 9,1
        dc.l 0
        dc.b 1,2
        even
state:
        dcb.b state_size,0
frame_profile:
        ; 0..8: current count and four stage sums; 10: boundary tick.
        ; 12..20: last complete 64-frame window; 22 reserved; 24 pending IPC.
        dcb.w   13,0
        dc.l    0,0             ; QDOS sysvars and saved keyboard queue
        dcb.w   5,0             ; count, cached message ID/top/height, queue flag
        dcb.w   26,0            ; one occupancy byte per four-row screen band
        ; Cup music banks precede the entry code to keep PC displacements bounded.
        include "data/assets.inc"
        ; Cup overlays use the exact row-run source; no duplicate column programs.
        even
track_buffer equ $29a20
        ; Active circuit uses the former message-cache RAM below the image.
        include "data/cup_resources.inc"
        include "../assets/title/mode_menu.inc"
image_end:
