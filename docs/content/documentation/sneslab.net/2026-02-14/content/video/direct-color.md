---
title: "Direct Color"
reference_url: https://sneslab.net/wiki/Direct_Color
categories:
  - "Video"
  - "Flags"
downloaded_at: 2026-02-14T11:45:59-08:00
cleaned_at: 2026-02-14T17:55:09-08:00
---

**Direct Color** is a display technique that does not use CGRAM. Instead, the colors come directly from VRAM. Direct color is available only on BG1, in the following background modes:

- Mode 3
- Mode 4
- Mode 7

**Direct Select** is the name of the bit that turns direct color on or off. \[3] It lives at bit 0 of CGSWSEL (2130h).

### Colors

This mode gets RGB values from the palette and color number. One tile can use 256 colors, and Layer 1 can use 2041 colors. The color value comes from 3 bits R, 3 bits G, 2 bits B from the pixel value, plus 1 bit from the palette value. However, palette 00 is a transparent color rather than black, pure black cannot be used. And, it is RGB443, pure white cannot be used.

```
YXPbgrTT (YXPCCCTT)
BBGGGRRR (Pixel's value)
```

The final color values are:

```
-BBb00GGGg0RRRr0
```

### See Also

- Indirect Color

### References

1. Chapter 8, "CG Direct Select" on [page 2-8-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n73) of the official Super Nintendo development manual
2. [Appendix A-17](https://archive.org/details/SNESDevManual/book1/page/n211) lbid
3. [page 2-27-16 of Book I](https://archive.org/details/SNESDevManual/book1/page/n129) lbid
4. [Appendix A-5](https://archive.org/details/SNESDevManual/book1/page/n199) lbid

### External Links

1. at least four licensed games using direct color: [https://snes.nesdev.org/wiki/Uncommon\_graphics\_mode\_games#Direct\_Color](https://snes.nesdev.org/wiki/Uncommon_graphics_mode_games#Direct_Color)
2. [https://www.smwcentral.net/?p=viewthread&t=125133&page=1&pid=1625490#p1625490](https://www.smwcentral.net/?p=viewthread&t=125133&page=1&pid=1625490#p1625490)
3. direct color discussed at 4:37 [https://youtu.be/5SBEAZIfDAg?si=QD734cMgjbgNu7fM](https://youtu.be/5SBEAZIfDAg?si=QD734cMgjbgNu7fM)
