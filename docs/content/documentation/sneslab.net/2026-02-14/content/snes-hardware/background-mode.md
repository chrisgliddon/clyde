---
title: "Background Mode"
reference_url: https://sneslab.net/wiki/Background_Mode
categories:
  - "SNES_Hardware"
  - "Video"
downloaded_at: 2026-02-14T11:08:15-08:00
cleaned_at: 2026-02-14T17:54:07-08:00
---

On the SNES hardware, the BG modes are used to specify the number of layers, the color depth of the graphics and some effect avaliable. There are 8 different BG modes. The BG mode is stored in bit 0,1 and 2 of $2105

- Mode 0: 4 layers, all using 2bpp graphic.
- Mode 1: 3 layers, two using 4bpp graphic and one using 2bpp graphic. This is one of the most commonly used video modes.
- Mode 2: 2 layers, both using 4bpp graphic. Each tile can be individually scrolled.
- Mode 3: 2 layers, one using 8bpp graphic and one using 4bpp graphic. The 8bpp layer can also directly specify colors from an 11-bit (RGB443) colorspace.
- Mode 4: 2 layers, one using the 8bpp graphic and one using 2bpp graphic. The 8bpp layer can directly specify colors as with Mode 3, and each tile can be individually scrolled as in Mode 2.
- Mode 5: 2 layers, one using 4bpp graphic and one using 2bpp graphic. In this mode, output is always 512 pixels horizontally with altered tile decoding to facilitate use of the 512-width and interlaced modes.
- Mode 6: 1 layer, using 4bpp graphic. Output is as in Mode 5, and individual tiles are scrolled as in Mode 2.
- Mode 7: 1 layer of 128x128 tiles from a set of 256, which can be interpreted as 8bpp or 7bpp (using the higher bit as a pixel priority bit) depending of bit 7 of $2133 . The layer may be rotated and scaled using matrix transformations. HDMA is often used to change the matrix parameters for each scanline to generate perspective effects, giving a pseudo-3d effect.

### Reference

- [page 2-3-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n62) of the official Super Nintendo development manual
