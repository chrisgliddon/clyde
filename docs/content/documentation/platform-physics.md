---
title: "Super NES Programming/Platform Physics"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/Platform_Physics
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:17:34-08:00
---

## Ground Mode

Ground mode is when the player is standing or walking on the ground. In ground mode, the following routine is performed:

1\) Check to see if jumping button is pressed

2\) If so, jump to "initiate\_jump\_mode" routine

3\) Check collision with the tiles below

4\) If all tiles underneath player are empty, jump to "initiate\_fall\_mode" routine

### Initiate Jump Mode

1\) set "y\_velocity" to "take\_off\_velocity"

2\) set "jump\_mode" flag

### Initiate Fall Mode

1\) set "y\_velocity" to #0

2\) set "jump\_mode" flag

## Jump/Fall Mode

Jump/Fall mode is when the player jumps or falls. In jump/fall mode, the following routine is performed:

1\) increment "y\_velocity" by #gravital\_acceleration

2\) add "y\_velocity" to "y\_coordinate"

3\) if "y\_velocity"&gt;0, then go to "fall\_mode" routine

### Fall Mode

1\) checks for collision between player and tiles

2\) If collision is detected, follow "land\_on\_ground" routine

#### Land on Ground

1\) reset "jump\_mode" flag

2\) pop the sprite up to the top of the ground tile
