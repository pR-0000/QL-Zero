<a id="francais"></a>
# Éditeur de circuits et graphismes

[English version](#english)

Lancez `python tools/circuit_editor.py` ou `run_editor.cmd` sous Windows. Le projet fourni, `assets/project/classic_cup.qlr.json`, s'ouvre par défaut. Travaillez sur une copie pour conserver les circuits de la version publiée.

## Circuit et relief

Sélectionnez un circuit, déplacez ses points de contrôle, ajustez sa largeur et son profil d'altitude. Le tracé est fermé et ses points sont rééchantillonnés pour le moteur. Les contrôles de validité signalent les dépassements de carte et les zones problématiques. L'élargissement permet d'adoucir la difficulté sans diminuer la distance de vue.

L'onglet Coupe permet de choisir l'ordre des trois à six circuits d'un projet et leurs musiques. La coupe publiée utilise les six circuits.

## Ambiances et bitmaps

Dans l'onglet **Graphismes**, choisissez le circuit et son ambiance. Les motifs de route, sol extérieur, bandes de vitesse, recharge, ciel, nuages et décor lointain sont éditables dans la palette QL. Une couleur unie se dessine plus simplement qu'un motif détaillé, mais le coût total dépend aussi de la géométrie.

Les vaisseaux, leurs vues, flammes, carcasses et explosions sont dans le même projet. La commande de collage permet d'importer un bitmap du presse-papier ; Pillow convertit ses couleurs vers la palette et le format du graphisme sélectionné. Le collage d'image est principalement prévu pour Windows ; selon la plateforme, l'import depuis un fichier PNG est préférable.

Les quatre icônes du menu principal sont des PNG de **36 × 84 pixels** : `assets/title/menu_gp.png`, `menu_time_attack.png`, `menu_practice.png`, `menu_death_race.png`. L'illustration du titre est `assets/title/ql-zero-title-art.png`. Reconstruisez le jeu après les avoir modifiées.

## Aperçu

- **Piloter** emploie la physique native du moteur : flèches, Espace, CTRL.
- **Caméra libre** permet de parcourir le circuit pour vérifier les reliefs et perspectives : flèches pour avancer/tourner, Q/D pour se décaler, E/C pour changer la hauteur, Maj pour accélérer le déplacement.
- L'aperçu PC facilite l'édition. Le rendu natif affiche les pixels du moteur
68000. La vitesse du PC ne représente pas celle d'un QL.
- Le test de coupe charge le jeu complet et ses menus. F4 agit sur le fantôme en Time Attack. La pause et les séquences suivent les mêmes états qu'en jeu.

L'aperçu ne synthétise pas le son matériel. Écoutez les musiques sur QL ou NanoQL. Les écritures de la cartouche en aperçu restent dans une copie en mémoire et ne modifient pas vos records sur disque.

## Exporter

Enregistrez le projet, puis exportez la coupe vers un nouveau dossier. L'export utilise la même construction que la version publiée et nécessite vasm et le constructeur MDV de NanoQL. Un projet doit contenir trois à six circuits pour une coupe jouable ; un tracé isolé peut être ajouté à une copie du projet fourni. Voir [BUILD.md](BUILD.md) pour la configuration.

---

<a id="english"></a>
# Track and graphics editor (English)

[Version française](#francais)

Run `python tools/circuit_editor.py`, or `run_editor.cmd` on Windows. The supplied project, `assets/project/classic_cup.qlr.json`, opens by default. Work on a copy to preserve the published release's tracks.

## Track and terrain

Select a track, move its control points, and adjust its width and elevation profile. The layout is a closed loop, and its points are resampled for the engine. Validation checks report layouts that exceed the map boundaries and other problematic areas. Widening a track can make it less difficult without reducing the viewing distance.

The **Coupe (Cup)** tab lets you choose the order of a project's three to six tracks and their music. The published cup uses all six tracks.

## Environments and bitmaps

In the **Graphismes (Graphics)** tab, select the track and its environment. Road, off-track ground, speed strips, recharge strips, sky, clouds and distant scenery patterns can be edited using the QL palette. A solid colour is simpler to draw than a detailed pattern, but total cost also depends on the geometry.

Machines, their views, flames, wrecks and explosions are stored in the same project. The paste command imports a bitmap from the clipboard; Pillow converts its colours to the palette and format of the selected graphic. Image pasting is primarily intended for Windows; on other platforms, importing a PNG file may be preferable.

The four main menu icons are **36 × 84 pixel** PNG files: `assets/title/menu_gp.png`, `menu_time_attack.png`, `menu_practice.png`, `menu_death_race.png`. The title illustration is `assets/title/ql-zero-title-art.png`. Rebuild the game after editing these files.

## Preview

- **Piloter (Drive)** uses the engine's native physics: arrow keys, Space, CTRL.
- **Caméra libre (Free camera)** lets you explore the track to inspect terrain and perspective: arrow keys to move forward/turn, Q/D to strafe, E/C to change height, and Shift to move faster.
- The PC preview helps with editing. Native rendering displays the 68000 engine's pixels. PC speed does not represent QL performance.
- Cup testing loads the full game and its menus. F4 controls the ghost in Time Attack. Pause and cinematic sequences use the same states as the game.

The preview does not synthesise hardware sound. Listen to the music on QL or NanoQL. Preview cartridge writes remain in an in-memory copy and do not modify your records on disk.

## Exporting

Save the project, then export the cup to a new directory. Exporting uses the same build process as the published release and requires vasm and NanoQL's MDV image builder. A project must contain three to six tracks for a playable cup; a single layout can be added to a copy of the supplied project. See [BUILD.md](BUILD.md#english) for setup instructions.
