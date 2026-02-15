---
title: "Mode 6"
reference_url: https://sneslab.net/wiki/Mode_6
categories:
  - "Tiled_Background_Modes"
  - "Offset_Change_Modes"
  - "Horizontal_512_Modes"
  - "Indirect_Color_Modes"
  - "Single-background_Modes"
downloaded_at: 2026-02-14T15:35:07-08:00
cleaned_at: 2026-02-14T17:55:17-08:00
---

BG Layers Available Layer 1 4bpp

**Mode 6** is the least frequently used Background Mode. No games use it.\[1]\[4] It is one of the hi-res modes, meaning the horizontal resolution is 512 dots. When interlacing is enabled, the vertical resolution is also doubled.\[1] It supports offset change mode. PVSnesLib currently does not support Mode 6. \[2] Color Math should not be used in Mode 6.\[3]\[7] Tiles are 16 pixels wide and 8 pixels tall in Mode 6.\[5]

The eight palettes for BG1 are located at CGRAM addresses 0h to 7Fh.\[6] Each palette contains 16 colors.

Direct Color is unsupported.\[5]

Mosaic and windowing are supported.

### See Also

Other Background Modes Mode 0 Mode 1 Mode 2 Mode 3 Mode 4 Mode 5 [Mode 6]() Mode 7

### References

1. [https://nesdoug.com/2022/05/30/other-modes](https://nesdoug.com/2022/05/30/other-modes)
2. [https://github.com/alekmaul/pvsneslib/issues/14#issuecomment-698703247](https://github.com/alekmaul/pvsneslib/issues/14#issuecomment-698703247)
3. 7.1 on [page 2-7-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n69) of the official Super Nintendo development manual
4. [https://forums.nesdev.org/viewtopic.php?t=15087](https://forums.nesdev.org/viewtopic.php?t=15087)
5. [Appendix A-5](https://archive.org/details/SNESDevManual/book1/page/n199)
6. bottom left memory map in [Appendix A-17](https://archive.org/details/SNESDevManual/book1/page/n211), lbid
7. subparagraph 19.1 on [page 2-19-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n89)

### External Links

1. demo including Mode 6: [https://forums.nesdev.org/viewtopic.php?p=174494](https://forums.nesdev.org/viewtopic.php?p=174494)
