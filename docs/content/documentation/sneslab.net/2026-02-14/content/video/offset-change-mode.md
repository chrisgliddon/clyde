---
title: "Offset Change Mode"
reference_url: https://sneslab.net/wiki/Offset_Change_Mode
categories:
  - "Official_Jargon"
  - "Offset_Change_Modes"
downloaded_at: 2026-02-14T15:47:12-08:00
cleaned_at: 2026-02-14T17:55:18-08:00
---

The term **Offset Change Mode**, also known as **Offset per Tile**, describes an effect on the Super NES where the offset of each displayed column of a background tilemap can be overwritten by a different offset. Games such as *Tetris Attack* and *Super Mario World 2: Yoshi's Island* make use of it.

## Function

The Super NES console has got eight modes, numbered from 0 to 7, for displaying background layers, three of them (background modes 2, 4 and 6) supporting Offset Change Mode. In these background modes, the offsets for almost every column can be overwritten by a new value. Said offsets can be applies for both visible background layers in the horizontal and vertical direction.

In these background modes, the tilemap of background layer 3 is repurposed to contain offsets and not tile data. This is especially evident on Mode 2 which is otherwise identical to Mode 1: Two 4bpp backgrounds but only the latter has got three visible background layers. Furthermore, the Super NES is wired to always use background layer 3 for offsets even on Mode 6 which lacks layer 2.

### Reading an Offset

Because an actual background tilemap is used to get the offsets, reading an offset follows similar rules as reading a tile. The formula of the first offset on a 32x32 tilemap looks like this: `(BG3SC & 0xFC << 8) + (BG3VOFS & 0xF8 << 2) + (BG3HOFS & 0xF8 >> 3)` where BG3SC is the value in $2109, BG3VOFS the value in $2112 and BG3HOFS the value in $2111. Because the offsets are affected by BG3VOFS and BG3HOFS, you can make use of a raster interrupt (i.e. IRQ and HDMA) to change the BG3 offsets and use a different offset for that portion of the screen.

Furthermore, the Super NES reads from the offset data twice in background modes 2 and 6: First to get a horizontal offset and then again offset by 32 bytes (i.e. a single row of tiles) to get the vertical offset. Mode 4, on the other hand, only allows offsets in one direction, controlled by bit 15 of the offset data.

### Applying the Offset

The real difference comes in the tilemap data. Usually, the tiles use the `YXPCCCTT TTTTTTTT` format but offsets use the `D21---OO OOOOOOOO` format where D is the direction (0 = horizontal, 1 = vertical, only applicable in Mode 4), 2 and 1 are the affected background layers (0 = disabled, 1 = enabled) and the O bits are the offsets. Keep in mind that for horizontal offsets, the last three bytes are ignored and taken from the original background offset instead.

## Limitations

Besides the limitation of horizontal offsets as well as Mode 4, Offset Change Mode isn't able to apply an offset to the leftmost displayed column. This is because even though Offset Change Mode can change offsets on 32 different columns, there are actually up to 33 columns onscreen. This can be fixed either by masking out the eight leftmost pixels of the screen or treat the original background offset as the 0th column.

### See Also

- Mosaic
- Windowing

### References

- Official Super Nintendo development manual on Offset Change Mode: [Page 2-12-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n77)
- [Appendix A-13](https://archive.org/details/SNESDevManual/book1/page/n207) on Offset Change Mode
- [https://problemkaputt.de/fullsnes.htm#snesppuoffsetpertilemode](https://problemkaputt.de/fullsnes.htm#snesppuoffsetpertilemode)

### External Links

- Touch Fuzzy Get Dizzy example: [https://youtu.be/Pus2I9aPUY4](https://youtu.be/Pus2I9aPUY4)
