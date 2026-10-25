<a id="francais"></a>
# Crédits

[English version](#english)

- **pR-0000** : conception, adaptation, choix artistiques, édition des sprites, circuits, ajustements MIDI et validation du jeu.
- Développement réalisé avec l'aide de **Chat GPT 6.1 Sol**.
- [NanoQL](https://github.com/pR-0000/NanoQL) : plateforme de développement et de test Sinclair QL, et outil externe de construction des images Microdrive.
- [Retro Programmers United for Obscure Systems — Sinclair QL 2026](https://itch.io/jam/rpufos-sinclair-ql) : game jam à l'origine de la publication.
- Retours et tests de la communauté, notamment sur Sinclair QL réel.

## Inspirations et musiques

QL-Zero est un hommage amateur à **F-Zero et F-Zero X**, créations de Nintendo. Les noms, références, compositions musicales et éléments de tiers restent la propriété de leurs titulaires respectifs. Nintendo n'est ni associé au projet, ni son éditeur.

Les huit pistes comprennent les thèmes des six circuits, le titre/menu et la cérémonie de fin. Les données ont été préparées à partir de MIDI retravaillés, puis converties et ajustées avec **midi2ql** pour le son monophonique du QL. Les exports utilisés sont conservés dans `assets/music/` ; midi2ql lui-même n'est pas nécessaire pour compiler cette version.

La licence du code ne confère aucun droit supplémentaire sur ces compositions, marques ou autres contenus de tiers. Elle ne les relicencie pas.

## Outils externes

- [vasm](http://sun.hasenbraten.de/vasm/) : assembleur Motorola, fourni séparément.
- [Pillow](https://python-pillow.org/) : traitement des bitmaps.
- [Unicorn Engine](https://www.unicorn-engine.org/) : exécution des instructions 68000 pour l'éditeur et les contrôles.
- Python et Tkinter : outils de construction et interface de l'éditeur.

Ces dépendances conservent leurs licences. Aucune ROM Sinclair/QDOS ni aucun exécutable vasm n'est inclus dans ce dépôt.

---

<a id="english"></a>
# Credits (English)

[Version française](#francais)

- **pR-0000**: design, adaptation, artistic direction, sprite and track editing, MIDI adjustments and game validation.
- Developed with the help of **Chat GPT 6.1 Sol**.
- [NanoQL](https://github.com/pR-0000/NanoQL): Sinclair QL development and testing platform, and external Microdrive image builder.
- [Retro Programmers United for Obscure Systems — Sinclair QL 2026](https://itch.io/jam/rpufos-sinclair-ql): the game jam for which the project was published.
- Community feedback and testing, including tests on real Sinclair QL hardware.

## Inspiration and music

QL-Zero is an amateur tribute to **F-Zero and F-Zero X**, created by Nintendo. Names, references, musical compositions and third-party material remain the property of their respective rights holders. Nintendo is neither affiliated with this project nor its publisher.

The eight music tracks comprise the six course themes, the title/menu theme and the ending ceremony theme. The data was prepared from reworked MIDI files, then converted and adjusted with **midi2ql** for the QL's monophonic sound. The exports used by the game are preserved in `assets/music/`; midi2ql itself is not required to build this release.

The code licence grants no additional rights to these compositions, trademarks or other third-party material. It does not relicense them.

## External tools

- [vasm](http://sun.hasenbraten.de/vasm/): Motorola assembler, supplied separately.
- [Pillow](https://python-pillow.org/): bitmap processing.
- [Unicorn Engine](https://www.unicorn-engine.org/): 68000 instruction execution for the editor and verification tools.
- Python and Tkinter: build tools and editor interface.

These dependencies retain their own licences. No Sinclair/QDOS ROM or vasm executable is included in this repository.
