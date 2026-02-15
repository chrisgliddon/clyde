---
title: "Mode 2"
reference_url: https://sneslab.net/wiki/Mode_2
categories:
  - "Tiled_Background_Modes"
  - "Offset_Change_Modes"
  - "Horizontal_Pseudo_512_Mode"
  - "Indirect_Color_Modes"
  - "Double-background_Modes"
downloaded_at: 2026-02-14T15:33:56-08:00
cleaned_at: 2026-02-14T17:55:13-08:00
---

BG Layers Available Layer 2 Layer 1 4bpp 4bpp

**Mode 2** is very similar to Mode 1, except that Layer 3 is sacrificed to support Offset Change Mode instead of being a background. The horizontal resolution is 256 dots.

The eight palettes for BG1 and BG2 are located at CGRAM addresses 0h to 7Fh in Mode 2.\[3] Each of those palettes contains 16 colors.

Background tiles may be 8 by 8 pixels or 16 by 16 pixels in Mode 2.\[2]

Direct Color is unsupported.

Mosaic, interlacing, and windowing are supported.

### See Also

Other Background Modes Mode 0 Mode 1 [Mode 2]() Mode 3 Mode 4 Mode 5 Mode 6 Mode 7

### References

1. [https://nesdoug.com/2022/05/30/other-modes](https://nesdoug.com/2022/05/30/other-modes)
2. [Appendix A-5](https://archive.org/details/SNESDevManual/book1/page/n199) of the official Super Nintendo development manual
3. upper right memory map in [Appendix A-17](https://archive.org/details/SNESDevManual/book1/page/n211), lbid
