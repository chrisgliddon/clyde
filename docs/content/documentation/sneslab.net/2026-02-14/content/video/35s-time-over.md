---
title: "35's Time Over"
reference_url: https://sneslab.net/wiki/35's_Time_Over
categories:
  - "Video"
downloaded_at: 2026-02-14T10:42:18-08:00
cleaned_at: 2026-02-14T17:55:07-08:00
---

**35's Time Over** is the PPU limitation that it only has time to fetch 34 8x8 sprite tiles per scanline. If time runs out, only 32 (not 34) sprites (which must satisfy 33's Range Over as well) will be displayed; the rest will dropout.

If this limit is hit, the **OBJ Time Overflow Flag** (bit 7 of STAT77) will be set. This flag will be cleared at the end of vblank, but not during fblank.

Sprites that are not displayed on the Display Area (presumably ones hidden by windows or background layers) do not count towards the 35's Time Over limitation.

### See Also

- 33's Range Over
- Object Attribute Memory

### Reference

- paragraph 20.2 on [page 2-20-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n90) of the official Super Nintendo development manual
