---
title: "Windowing"
reference_url: https://sneslab.net/wiki/Windowing
categories:
  - "Video"
  - "Official_Jargon"
downloaded_at: 2026-02-14T17:18:43-08:00
cleaned_at: 2026-02-14T17:55:21-08:00
---

**Windowing** is a feature of S-PPU2. A window clips the left and right part of the viewport off. The unclipped part (the Display Area) is considered outside the window and the clipped part is considered inside.\[2] The SNES supports up to two windows, and they can be combined with each other in various boolean logic operations. With HDMA, the left and right positions of each window can be changed on a scanline basis.

### See Also

- Mosaic
- Color Math

### References

1. [Appendix A-18 of Book I](https://archive.org/details/SNESDevManual/book1/page/n212) of the official Super Nintendo development manual
2. [page 2-27-12 of Book I](https://archive.org/details/SNESDevManual/book1/page/n125), lbid
3. Chapter 6, "Window (Window Mask)" on [page 2-6-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n67), lbid.
