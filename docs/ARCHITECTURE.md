<a id="francais"></a>
# Carte du code

[English version](#english)

Les outils génèrent les données du projet, puis assemblent directement les routines du moteur de `src/`.

## Points d'entrée

| Module | Rôle |
| --- | --- |
| `src/cup_main.asm` | Organisation de l'image fixe : musique, puis moteur |
| `src/cup_boot.asm` | Chargeur QDOS et variante d'injection, expansion à rebours |
| `src/race.asm` | Constantes, état A6, boucle principale, physique du joueur et affichage de base |
| `src/cup.asm` | Initialisation des circuits, classement, points et transitions |
| `src/title_loader.asm` | Décompression de l'image du titre dans la mémoire vidéo |
| `src/title_music.asm`, `src/title_menu.asm` | Menu initial sous QDOS et musique avant prise de contrôle |

Les offsets `s_*` sont relatifs à A6. Les positions et vitesses utilisent principalement des entiers en virgule fixe. Les ticks sont à 50 Hz ; il faut conserver la gestion du rebouclage des compteurs sur 16 bits.

## Affichage

| Module | Rôle |
| --- | --- |
| `road.asm`, `road_prepare.asm` | Projection, visibilité et préparation des tronçons |
| `road_contour_union.asm` | Fusion des portions de route et contours exposés |
| `road_quad_fill.asm`, `road_quad_spans.asm` | Remplissage spécialisé des bandes de route |
| `road_register_fill.asm`, `road_rail_fill.asm` | Écritures mémoire et bordures |
| `scene_compositor.asm` | Composition de la scène et publication par bandes |
| `sprite_runs.asm`, `sprite_clip.asm` | Blits de lignes opaques ou masquées et découpage |
| `cup_sprite.asm`, `rivals.asm` | Cache des vues de vaisseaux, tailles et orientations |
| `sky.asm`, `sky_theme.asm` | Ciel, nuages et décor distant propre au circuit |
| `cup_hud.asm`, `cup_warning.asm`, `messages.asm` | Interface, mini-carte, CHECK et annonces |
| `menu_draw.asm` | Dessin partagé des menus ; seules les icônes modifiées sont repeintes |

Le rendu de course reste en MODE 8 avec la distance de vue complète. Les ressources du titre, du menu et des podiums réutilisent des zones mémoire qui ne servent pas simultanément au rendu de course. Il n'y a pas deux écrans complets résidents.

## Jeu, IA et séquences

| Module | Rôle |
| --- | --- |
| `npc_physics.asm`, `cup_ai.asm`, `cup_offense.asm` | Conduite, boost et attaques des deux adversaires |
| `collisions.asm`, `swept_wall.asm`, `cup_combat.asm` | Collisions, dégâts, rebonds, carcasses et tournoiement |
| `cup_timing.asm` | Tours, chronos, vitesses maximales et records |
| `cup_ghost.asm` | Enregistrement et interpolation du meilleur Time Attack complet |
| `cup_countdown.asm`, `cup_finish.asm` | Tour de caméra initial, décompte et arrivée automatique |
| `cup_podium.asm` | Défilé et podiums ; durée complète obligatoire de 1 700 ticks |
| `cup_pause.asm` | Pause, reprise et retour au menu |
| `cup_modes.asm`, `cup_records.asm` | Modes de jeu et consultation des records |

La phase `cup_phase` pilote les transitions : 0 course, 1 résultats de manche, 2 classement final, 3 présentation de course, 4 défaite, 5 sélecteur, 6 résultats solo, 7 décompte, 8 records, 9 cérémonie, 10 caméra de départ, 11 pause. Le fantôme est un enregistrement depuis GO! sur trois tours, pas un tour lancé.

## Son et stockage

`music.asm` séquence les commandes de l'IPC 8049 en premier plan. Une note est entretenue par l'IPC ; la transmission et le séquenceur ont néanmoins un coût CPU. Les accès clavier et son sont sérialisés. `cup_music_ring.asm` conserve 512 octets d'historique pour la musique compressée. F2 reste traité dans la lecture clavier.

`cup_storage.asm` et `cup_records.asm` utilisent les vecteurs secteur documentés de la ROM entre les courses. Aucune lecture ni écriture Microdrive n'a lieu en course. Les scores et fantômes utilisent des emplacements préalloués, deux journaux et des contrôles CRC. L'identité de la coupe dépend des tracés : changer un tracé rend les anciens records incompatibles avec ce projet.

## Mémoire de la v1 distribuée

| Zone | Usage |
| --- | --- |
| `0x20000–0x27fff` | Écran MODE 8, 32 Ko |
| `0x28000–0x29a1f` | Espace de composition / chargement, 6 688 octets |
| `0x29a20–0x2c64f` | Circuit actif, 11 312 octets |
| `0x2c680–0x3f9c5` | Code, état et données résidentes, 78 662 octets |
| `0x3fc00–0x3ffff` | Pile réservée, 1 Ko |

La marge entre le moteur et la pile est de **570 octets**. La construction refuse tout dépassement. Une extension de données n'est donc pas gratuite en RAM, même si la cartouche dispose encore d'espace libre.

## Données et outils

`assets/project/classic_cup.qlr.json` est la source des circuits et sprites. `assets/music/` conserve les huit exports midi2ql ; les PNG de `assets/title/` alimentent le titre et le menu. `src/data/` fournit les tables statiques et les modèles de données ; les tables variables sont régénérées dans la copie de construction. Ne modifiez pas un fichier situé dans `build/` pour changer le jeu.

`tools/build_cup.py` orchestre les conversions, l'assemblage et la création MDV. `editor_model.py` est le modèle de projet ; `circuit_editor.py` gère la GUI ; `editor_preview.py`, `native_cpu.py` et `cup_emulation.py` exécutent la physique et le moteur pour l'aperçu sans ROM propriétaire.

---

<a id="english"></a>
# Code map (English)

[Version française](#francais)

The tools generate project data, then directly assemble the engine routines in `src/`.

## Entry points

| Module | Purpose |
| --- | --- |
| `src/cup_main.asm` | Fixed image layout: music, followed by the engine |
| `src/cup_boot.asm` | QDOS loader and injection variant, backwards expansion |
| `src/race.asm` | Constants, A6 state, main loop, player physics and basic rendering |
| `src/cup.asm` | Track initialisation, standings, points and transitions |
| `src/title_loader.asm` | Title image decompression into video memory |
| `src/title_music.asm`, `src/title_menu.asm` | Initial QDOS menu and music before hardware takeover |

`s_*` offsets are relative to A6. Positions and velocities primarily use fixed-point integers. Ticks run at 50 Hz; preserve the handling of 16-bit counter wraparound.

## Rendering

| Module | Purpose |
| --- | --- |
| `road.asm`, `road_prepare.asm` | Projection, visibility and track segment preparation |
| `road_contour_union.asm` | Merging road areas and drawing exposed contours |
| `road_quad_fill.asm`, `road_quad_spans.asm` | Specialised road band filling |
| `road_register_fill.asm`, `road_rail_fill.asm` | Memory writes and barriers |
| `scene_compositor.asm` | Scene composition and publication in bands |
| `sprite_runs.asm`, `sprite_clip.asm` | Opaque or masked row blits and clipping |
| `cup_sprite.asm`, `rivals.asm` | Machine view, size and orientation caching |
| `sky.asm`, `sky_theme.asm` | Track-specific sky, clouds and distant scenery |
| `cup_hud.asm`, `cup_warning.asm`, `messages.asm` | HUD, mini-map, CHECK and announcements |
| `menu_draw.asm` | Shared menu rendering; only changed icons are repainted |

Race rendering remains in MODE 8 with the full viewing distance. Title, menu and podium resources reuse memory areas that are not needed simultaneously by race rendering. Two complete screens are not kept resident.

## Gameplay, AI and sequences

| Module | Purpose |
| --- | --- |
| `npc_physics.asm`, `cup_ai.asm`, `cup_offense.asm` | Driving, boost and attacks for both opponents |
| `collisions.asm`, `swept_wall.asm`, `cup_combat.asm` | Collisions, damage, rebounds, wrecks and spinning attack |
| `cup_timing.asm` | Laps, times, top speeds and records |
| `cup_ghost.asm` | Recording and interpolation of the best complete Time Attack race |
| `cup_countdown.asm`, `cup_finish.asm` | Opening camera orbit, countdown and automatic finish |
| `cup_podium.asm` | Parade and podiums; mandatory full duration of 1,700 ticks |
| `cup_pause.asm` | Pause, resume and return to menu |
| `cup_modes.asm`, `cup_records.asm` | Game modes and record viewing |

`cup_phase` controls transitions: 0 racing, 1 race results, 2 final standings, 3 race introduction, 4 defeat, 5 selector, 6 solo results, 7 countdown, 8 records, 9 ceremony, 10 starting camera orbit, 11 pause. The ghost records three laps from GO!, rather than a flying lap.

## Sound and storage

`music.asm` sequences IPC 8049 commands in the foreground. The IPC sustains each note; transmission and sequencing still have a CPU cost. Keyboard and sound access are serialised. `cup_music_ring.asm` retains 512 bytes of history for compressed music. F2 remains handled by keyboard input.

`cup_storage.asm` and `cup_records.asm` use documented ROM sector vectors between races. No Microdrive reads or writes occur during a race. Scores and ghosts use preallocated slots, dual journals and CRC checks. Cup identity depends on track layouts: changing a layout makes old records incompatible with that project.

## Distributed v1 memory layout

| Region | Usage |
| --- | --- |
| `0x20000–0x27fff` | MODE 8 screen, 32 KB |
| `0x28000–0x29a1f` | Composition / loading workspace, 6,688 bytes |
| `0x29a20–0x2c64f` | Active track, 11,312 bytes |
| `0x2c680–0x3f9c5` | Code, state and resident data, 78,662 bytes |
| `0x3fc00–0x3ffff` | Reserved stack, 1 KB |

The margin between the engine and the stack is **570 bytes**. The build rejects any overflow. Additional data therefore has a RAM cost, even when the cartridge still has free space.

## Data and tools

`assets/project/classic_cup.qlr.json` is the source for tracks and sprites. `assets/music/` preserves the eight midi2ql exports; PNG files in `assets/title/` supply the title and menu. `src/data/` provides static tables and data templates; variable tables are regenerated in the build copy. Do not edit files in `build/` to modify the game.

`tools/build_cup.py` coordinates conversion, assembly and MDV creation. `editor_model.py` is the project model; `circuit_editor.py` handles the GUI; `editor_preview.py`, `native_cpu.py` and `cup_emulation.py` execute physics and the engine for the preview without a proprietary ROM.
