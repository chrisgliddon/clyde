---
title: "Sprite (hardware)"
reference_url: https://sneslab.net/wiki/Sprite_(hardware)
categories:
  - "Video"
  - "Scene_Slang"
downloaded_at: 2026-02-14T16:48:19-08:00
cleaned_at: 2026-02-14T17:55:19-08:00
---

On the SNES hardware, a sprite is an image drawn at a specific part of the screen. Unlike regular layers, each sprite image can move independently from each other. Furthermore, sprites also always use 4bpp graphics, no matter which BG mode is used. Only two different sprite sizes can be used at the same time - the two sizes available depend on bits 5, 6 and 7 of $2101. In SMW, the two sizes used are 8x8 and 16x16. The sprite data is stored in OAM, the graphics for them are stored in VRAM and the palette in CGRAM.

OBJ Size Combination Select 000 8 dot 16 dot 001 8 dot 32 dot 010 8 dot 64 dot 011 16 dot 32 dot 100 16 dot 64 dot 101 32 dot 64 dot 110 16 dot x 32 dot 32 dot x 64 dot 111 16 dot x 32 dot 32 dot x 32 dot

The last two non-square size combinations are not documented in the official dev manual.\[2]

## Limitations

- Only 32 sprites can be used on the same scanline (this is refered to as 'Range Over')
- Only 34 sprite tiles (8x8) can be used on the same scanline (this is refered to as 'Time Over')
- The OAM can only hold up to 128 sprites.
- Sprites are never hi-res.
- Interlacing does not double the possible sprite vertical positions\[3]

### See Also

Other Layers Backdrop Color Layer 4 Layer 3 Layer 2 Layer 1 [Sprite]() BG3 High Prio

### References

1. Chapter 2, "Object (OBJ)" on [page 2-2-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n60) of the official Super Nintendo development manual
2. [page 2-27-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n114), lbid
3. 18.3 OBJ on [page 2-18-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n88), lbid.
