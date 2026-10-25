<a id="francais"></a>
# Compiler QL-Zero

[English version](#english)

## Prérequis

- Python **3.10 ou plus récent** ; compilation vérifiée avec Python 3.12.
- `python -m pip install -r requirements.txt` : Pillow et Unicorn.
- [vasm](http://sun.hasenbraten.de/vasm/), cible `m68k`, syntaxe `mot`, exécutable `vasmm68k_mot`. Il n'est pas distribué dans ce dépôt.
- Le script `tools/nanoql_drive.py` du dépôt [NanoQL](https://github.com/pR-0000/NanoQL), utilisé pour créer les images QLAY. Ce script reste un outil externe sous sa propre licence.
- Pour l'éditeur : Tkinter, inclus dans l'installation Python Windows habituelle. Sous Linux, installer le paquet Tk de sa distribution si nécessaire.

Les musiques nécessaires à la construction sont conservées dans `assets/music/`. L'aperçu natif utilise un modèle de l'interface secteur de la ROM ; aucune copie de ROM Sinclair n'est distribuée ni nécessaire à cet aperçu.

## Configuration Windows — PowerShell

Adaptez ces deux chemins à vos installations :

```powershell
$env:VASM_M68K = 'D:/outils/vasm/vasmm68k_mot.exe'
$env:NANOQL_DRIVE = 'D:/projets/NanoQL/tools/nanoql_drive.py'
python -m pip install -r requirements.txt
python tools/build_cup.py
```

`build.cmd` effectue la même construction avec la configuration de l'environnement.

## Linux / macOS

```sh
export VASM_M68K=/chemin/vers/vasmm68k_mot
export NANOQL_DRIVE=/chemin/vers/NanoQL/tools/nanoql_drive.py
python3 -m pip install -r requirements.txt
python3 tools/build_cup.py
```

## Entrées et résultats

Le projet par défaut est `assets/project/classic_cup.qlr.json`. Il contient les six tracés, leurs reliefs, les ambiances et les sprites. Pour un autre projet :

```text
python tools/build_cup.py --project mon-projet.qlr.json --output build/ma-coupe
```

Un dossier d'export alternatif doit être vide. Le dossier par défaut `build/classic_cup` peut être reconstruit ; les journaux de records compatibles de sa cartouche sont conservés. Sauvegardez toujours votre cartouche de jeu.

Principaux résultats :

- `qlzero_classic_cup.mdv` : cartouche avec BOOT, titre, menu, moteur, circuits et emplacements de sauvegarde préalloués ;
- `cup_nanoql.bin` : chargeur pour injection directe ;
- `cup_image.bin` : moteur décompressé, employé aussi par l'aperçu ;
- `metadata.json` : symboles, limites mémoire et caractéristiques de la version ;
- `course_0.qzt` à `course_5.qzt` : circuits natifs ;
- `source/` : copie des sources et ressources effectivement assemblées.

Le programme vérifie les limites des 128 Ko, la pile de 1 Ko, la capacité du chargement QDOS et l'absence d'écrasement des données pendant la décompression. Les ressources de titre et de menu générées dans `assets/title/` sont ignorées par Git. Elles sont reconstruites depuis les PNG et la police.

## Vérifier et préparer une distribution

```text
python -m unittest discover -s tests -v
python tools/package_release.py --build build/classic_cup --output build/QL-Zero-v1.0.0.zip
```

L'archive de distribution contient une cartouche aux records vierges, sans modifier la cartouche locale. Elle inclut une notice, la jaquette et les empreintes SHA-256. Le moteur v1 est également fourni dans `release/v1.0.0` pour permettre l'aperçu de l'éditeur dès le téléchargement du dépôt.

Les contrôles Unicorn exécutent les instructions du moteur et vérifient les formats ; ils ne mesurent ni la contention vidéo, ni les FPS d'un QL réel, ni le tempo sonore matériel. Pour valider une modification du rendu ou du son, terminez par un essai sur QL ou NanoQL en configuration QL de base.

Les tests utilisent `build/classic_cup` lorsqu'il existe, sinon la version distribuée. La variable `QLZERO_TEST_BUILD` permet de sélectionner un autre dossier de construction.

---

<a id="english"></a>
# Building QL-Zero (English)

[Version française](#francais)

## Requirements

- Python **3.10 or newer**; building has been verified with Python 3.12.
- `python -m pip install -r requirements.txt`: Pillow and Unicorn.
- [vasm](http://sun.hasenbraten.de/vasm/), `m68k` target, `mot` syntax, `vasmm68k_mot` executable. It is not distributed with this repository.
- The `tools/nanoql_drive.py` script from [NanoQL](https://github.com/pR-0000/NanoQL), used to build QLAY images. This remains an external tool under its own licence.
- For the editor: Tkinter, included in a typical Windows Python installation. On Linux, install your distribution's Tk package if necessary.

The music required for building is preserved in `assets/music/`. The native preview models the ROM's sector interface; no copy of a Sinclair ROM is distributed or required for this preview.

## Windows setup — PowerShell

Adjust these two paths to match your installations:

```powershell
$env:VASM_M68K = 'D:/outils/vasm/vasmm68k_mot.exe'
$env:NANOQL_DRIVE = 'D:/projets/NanoQL/tools/nanoql_drive.py'
python -m pip install -r requirements.txt
python tools/build_cup.py
```

`build.cmd` performs the same build using the environment configuration.

## Linux / macOS

```sh
export VASM_M68K=/chemin/vers/vasmm68k_mot
export NANOQL_DRIVE=/chemin/vers/NanoQL/tools/nanoql_drive.py
python3 -m pip install -r requirements.txt
python3 tools/build_cup.py
```

## Inputs and outputs

The default project is `assets/project/classic_cup.qlr.json`. It contains the six layouts, their terrain profiles, environments and sprites. To use another project:

```text
python tools/build_cup.py --project mon-projet.qlr.json --output build/ma-coupe
```

An alternative export directory must be empty. The default directory, `build/classic_cup`, can be rebuilt; compatible record journals from its cartridge are preserved. Always back up your playing cartridge.

Main outputs:

- `qlzero_classic_cup.mdv`: cartridge containing BOOT, title, menu, engine, tracks and preallocated save slots;
- `cup_nanoql.bin`: direct injection loader;
- `cup_image.bin`: decompressed engine, also used by the preview;
- `metadata.json`: symbols, memory limits and release characteristics;
- `course_0.qzt` to `course_5.qzt`: native tracks;
- `source/`: copy of the source files and resources actually assembled.

The build checks the 128 KB memory limits, the 1 KB stack, the QDOS loading allocation and the absence of unread-data overwrites during decompression. Generated title and menu resources in `assets/title/` are ignored by Git. They are rebuilt from the PNG files and font.

## Verification and distribution packaging

```text
python -m unittest discover -s tests -v
python tools/package_release.py --build build/classic_cup --output build/QL-Zero-v1.0.0.zip
```

The distribution archive contains a cartridge with blank records, without modifying the local cartridge. It includes a guide, the cover and SHA-256 checksums. The v1 engine is also supplied in `release/v1.0.0` so the editor preview works as soon as the repository has been downloaded.

Unicorn checks execute engine instructions and verify formats; they do not measure video contention, real QL frame rates or hardware sound timing. When validating a rendering or sound change, finish with a test on a QL or NanoQL configured as a base QL.

Tests use `build/classic_cup` when it exists, otherwise the distributed release. The `QLZERO_TEST_BUILD` environment variable selects a different build directory.
