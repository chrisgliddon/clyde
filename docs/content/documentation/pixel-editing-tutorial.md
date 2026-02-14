---
title: "Super NES Programming/pixel editing tutorial"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/pixel_editing_tutorial
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:18:19-08:00
---

## Formats

The SNES supports multiple image formats, the main two being 2bpp, meaning two bits per pixel, and 4bpp, meaning 4 bits per pixel.

2bpp images allow 4 colors in an image, and 4bpp images allow 16 colors in an image. The format most commonly associated with the SNES is that of 4bpp, so if you are looking to create SNES-*like* graphics, use 4bpp. Additionally, all sprites in SNES games use 4bpp images.

The image format used by the background is determined by which Mode is chosen. The most commonly used mode, Mode 1, has 3 background layers, the first two being 4bpp and the third being 2bpp. When this mode is used in Super Mario World or Street Fighter 2, for example, the first background (4bpp) is used as the foreground/play area, the second (4bpp) as the backdrop, and the third (2bpp) as an overlay displaying titles and player statistics.

## Tools

There are several tools available to edit SNES graphics.

General purpose raster graphics editing programs such as GIMP are good, but not being designed for SNES files means there is quite a bit of setting up to save in to the correct file format. Tools such as YY-CHR are made specifically to create graphics for older consoles, and can easily save directly in to a format usable by the SNES. YY-CHR is widely used in the SMW hacking community. Note that YY-CHR supports a variety of formats and you will have to specifically choose 4bpp in the dropdown inside the program to save in to the SNES 16 color format.
