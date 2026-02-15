---
title: "Mosaic"
reference_url: https://sneslab.net/wiki/Mosaic
categories:
  - "Video"
  - "Registers"
downloaded_at: 2026-02-14T15:35:34-08:00
cleaned_at: 2026-02-14T17:55:18-08:00
---

**Mosaic** is a screen pixellation effect. The **mosaic register** is located at 2106h, and it can be enabled or disabled on a per-background basis via bits 0-3 (called the **mosaic mode select**). When enabled for a given background, the output background color (which will then be fed to the compositor and combined with all the other possibly mosaicized backgrounds) of the pixel at screen position (H,V) is:

`output_color(H,V) = input_color(floor(H/size)*size, floor(V/size)*size)`

where size is the value of bits 4-7 of 2106h plus one. Thus, for each mosaicized background, the shaded output consists of a grid of solid-colored squares where each entire square's color matches that of its top-leftmost input pixel.

The first mosaic square's location is always (0,0) so that the upper-left corner of the square is coincident with the upper-left corner of the screen, disregarding overscan. Sprites are unaffected by the mosaic filter. All background modes support mosaic.\[7]

The mosaic filter has a horizontal and vertical subsystem:

- The **horizontal mosaic latches** remember the color of the top-leftmost pixel of each mosaicized block.
- The **vertical mosaic latch** remembers what the value of the PPU vertical scanline counter was at the top of each mosaicized block.\[3]

On Mode 7's EXTBG, vertical mosaic is enabled when bit 0 of the mosaic register is set, and horizontal mosaic is enabled when bit 1 is set. \[4]

### Examples

Game Name Mosaic Usage Animated GIF *Animaniacs* upon opening a door *Axelay* when the Stage 3 boss' final form takes damage *Final Fantasy III (US)* when trying to select a disabled menu option and upon entering a battle *Final Fantasy Mystic Quest* upon entering battles and before/after loading new sections of the map *The Legend of Zelda: A Link to the Past*

- upon entering/exiting the [Lost Woods](https://zelda.fandom.com/wiki/Lost_Woods)
- when trying to slash [Agahnim](https://zelda.fandom.com/wiki/Agahnim) with the [Master Sword](https://zelda.fandom.com/wiki/Master_Sword)
- when being shocked by a [bari](https://www.zeldadungeon.net/wiki/Bari_%28A_Link_to_the_Past%29)
- upon entering/exiting a [whirlpool waterway](https://zelda.fandom.com/wiki/Whirlpool_Waterway) or dungeon warp tile

*The Magical Quest Starring Mickey Mouse* when the final boss takes damage, and on the walls of that same battle *Star Ocean* upon entering every battle *Street Fighter II* on the title screen logo *Super Mario World* after selecting and entering a level

### Apparent Resolution

This table describes how many complete mosaicized blocks appear on each axis when the mosaic filter is applied (the "apparent" screen resolution, in other words) disregarding overscan. The number of spare pixels off to the right and/or bottom of the screen that make up the last incomplete blocks when the block size does not evenly divide the screen is also given.

$2106.4-7 Mosaic Block Size Image # of rows of complete blocks # of columns of complete blocks # of rows of spare pixels # of columns of spare pixels 0 1 224 256 0 0 1 2 112 128 0 0 2 3 74 85 2 1 3 4 56 64 0 0 4 5 44 51 4 1 5 6 37 42 2 4 6 7 32 36 0 4 7 8 28 32 0 0 8 9 24 28 8 4 9 10 22 25 4 6 10 11 20 23 4 3 11 12 18 21 8 4 12 13 17 19 3 9 13 14 16 18 0 4 14 15 14 17 14 1 15 16 14 16 0 0

Anomie mentions these two mosaic block patterns for Mode 7 EXTBG:

### See Also

- Offset Change Mode

### External Links

- [https://emudev.de/q00-snes/mosaic-effect](https://emudev.de/q00-snes/mosaic-effect)

### References

1. setting example: [page 2-4-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n64) of the official Super Nintendo development manual
2. [https://problemkaputt.de/fullsnes.htm#snesppubgcontrol](https://problemkaputt.de/fullsnes.htm#snesppubgcontrol)
3. [https://board.zsnes.com/phpBB3/viewtopic.php?p=204966#p204966](https://board.zsnes.com/phpBB3/viewtopic.php?p=204966#p204966)
4. [anomie's register doc](https://www.romhacking.net/documents/196)
5. bit-by-bit breakdown of the mosaic register: [page 2-27-3](https://archive.org/details/SNESDevManual/book1/page/n116) lbid
6. display example of mosaic effect: [Appendix A-7](https://archive.org/details/SNESDevManual/book1/page/n201) lbid
7. [Appendix A-5](https://archive.org/details/SNESDevManual/book1/page/n199) lbid
