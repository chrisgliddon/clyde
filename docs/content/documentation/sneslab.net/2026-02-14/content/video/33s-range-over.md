---
title: "33's Range Over"
reference_url: https://sneslab.net/wiki/33's_Range_Over
categories:
  - "Video"
downloaded_at: 2026-02-14T10:42:12-08:00
cleaned_at: 2026-02-14T17:55:07-08:00
---

**33's Range Over** is the PPU limitation that it can only render 32 sprites per scanline.

If 33 or more occur on a single scanline, the excess will dropout, and the **OBJ Range Over Flag** (bit 6 of STAT77) will be set. This flag will be cleared at the end of vblank, but not during fblank.

Sprites hidden by windows or other sprites still count towards the total, but sprites completely off-screen do not. Large sprites do not count as multiple smaller sprites.

### See Also

- 35's Time Over
- Object Attribute Memory

### Reference

- paragraph 20.1 on [page 2-20-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n90) of the official Super Nintendo development manual
