<a id="francais"></a>
# Jouer sur QL et NanoQL

[English version](#english)

Le jeu cible un Sinclair QL avec **128 Ko**, un écran MODE 8 et un Microdrive. La version a été testée par des joueurs sur machine réelle. NanoQL a servi au développement et permet également de jouer en configuration QL ou accélérée.

Le fichier `release/v1.0.0/qlzero_classic_cup.mdv` est une image QLAY de 255 secteurs. Pour un support physique, transférez l'ensemble des fichiers de la cartouche avec un outil compatible, en conservant leurs noms. Le programme utilise le pilote secteur de la ROM Sinclair ; la compatibilité avec tous les pilotes ou ROM de remplacement n'est pas garantie.

Montez la cartouche dans MDV1 et démarrez, ou saisissez `LRUN mdv1_BOOT`. L'écran titre attend Entrée. Le menu permet de choisir mode et difficulté ou circuit. CTRL ouvre les records. En course, F2 coupe/reprend la musique et Échap ouvre la pause ; QUIT ramène au même menu.

## Énergie et combats

Le boost se débloque au deuxième tour et prélève de l'énergie. Il s'arrête avant de vider la jauge. Les collisions avec les bordures ou les machines causent des dégâts ; à énergie nulle, le vaisseau explose. Les bandes roses rechargent la jauge. Une attaque tournoyante au CTRL conserve la vitesse et l'inertie, bloque la direction et le boost, et procure une protection temporaire. Les carcasses des adversaires restent des obstacles.

En GP, un crash rapporte zéro point et permet de poursuivre la coupe. En Time Attack ou Death Race, il termine la tentative. Le mode Practice offre une énergie illimitée. Les adversaires utilisent leur boost et peuvent attaquer, avec une agressivité liée à la difficulté.

## Records et fantôme

Les chronos par tour, les vitesses maximales et le résultat sont présentés après la course. Les meilleurs records compatibles sont enregistrés entre les courses. Une cartouche protégée en écriture permet de jouer, mais ne conserve pas les nouveaux records ; le menu des records indique le résultat de la sauvegarde.

Le fantôme compare deux départs arrêtés depuis GO! sur trois tours. Il est masqué par défaut. F4 affiche son vaisseau blanc, son point cyan sur la mini-carte et l'avertissement CHECK quand il arrive derrière le joueur. GHOST: ON/OFF confirme le choix. Le joueur reste magenta et la ligne d'arrivée est verte. Masquer le fantôme ne désactive pas l'enregistrement d'une tentative.

## Performances

Le QL de base reste limité par son 68008 et la contention de sa mémoire vidéo. La cadence varie selon la piste et la scène ; les essais de développement se situaient généralement autour de **6 à 8 images/s**, sans cadence garantie. Les modes CPU 16 ou 24 MHz de NanoQL peuvent produire une animation plus fluide.

Sur NanoQL, comparez les performances avec le CPU en mode QL et la vitesse Microdrive en mode Authentic. Le mode Turbo des Microdrives peut accélérer temporairement le processeur pendant les accès disque. Les moteurs sont arrêtés et aucun accès MDV n'a lieu pendant les courses.

Pour l'injection : montez aussi la cartouche, puis chargez `cup_nanoql.bin` avec Load/PC à `0x30000` et SSP à `0x3fff0`. Cette méthode démarre au menu, sans afficher l'image du titre. Le jeu prend le contrôle de la machine après chargement ; QUIT revient au menu du jeu, pas à QDOS.

---

<a id="english"></a>
# Playing on QL and NanoQL (English)

[Version française](#francais)

The game targets a Sinclair QL with **128 KB**, a MODE 8 display and a Microdrive. Players have tested the release on real hardware. NanoQL was used during development and can also run the game in base QL or accelerated configurations.

`release/v1.0.0/qlzero_classic_cup.mdv` is a 255-sector QLAY image. For physical media, transfer all cartridge files using a compatible tool, preserving their names. The program uses the Sinclair ROM's sector driver; compatibility with every replacement driver or ROM is not guaranteed.

Mount the cartridge in MDV1 and boot, or enter `LRUN mdv1_BOOT`. The title screen waits for Enter. The menu lets you select a mode and difficulty or track. CTRL opens records. During a race, F2 toggles music and Escape opens the pause menu; QUIT returns to the same main menu.

## Energy and combat

Boost unlocks on the second lap and consumes energy. It stops before emptying the gauge. Collisions with barriers or machines cause damage; at zero energy, the machine explodes. Pink strips recharge the gauge. A CTRL spinning attack preserves speed and momentum, locks steering and boost, and provides temporary protection. Opponent wrecks remain obstacles.

In GP, crashing earns zero points and lets you continue the cup. In Time Attack or Death Race, it ends the attempt. Practice provides unlimited energy. Opponents use boost and can attack, with aggression depending on the difficulty level.

## Records and ghost

Lap times, top speeds and the result are shown after each race. Compatible best records are saved between races. A write-protected cartridge can be used to play, but will not retain new records; the records menu reports the save result.

The ghost compares two standing starts from GO! over three laps. It is hidden by default. F4 displays its white machine, its cyan mini-map marker and the CHECK warning when it approaches the player from behind. GHOST: ON/OFF confirms the setting. The player remains magenta and the finish line is green. Hiding the ghost does not disable attempt recording.

## Performance

The base QL remains limited by its 68008 and video memory contention. Frame rate varies with the track and scene; development tests generally achieved around **6 to 8 frames/s**, without a guaranteed frame rate. NanoQL's 16 or 24 MHz CPU modes can provide smoother animation.

On NanoQL, compare performance with the CPU in QL mode and Microdrive speed set to Authentic. Microdrive Turbo mode can temporarily accelerate the processor during disk access. Motors are stopped and there is no MDV access during races.

For injection, also mount the cartridge, then load `cup_nanoql.bin` with Load/PC at `0x30000` and SSP at `0x3fff0`. This method starts at the menu without displaying the title image. The game takes control of the machine after loading; QUIT returns to the game's menu, not to QDOS.
