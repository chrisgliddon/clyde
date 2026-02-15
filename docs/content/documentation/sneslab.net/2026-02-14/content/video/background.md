---
title: "Background"
reference_url: https://sneslab.net/wiki/Background
categories:
  - "Video"
  - "Official_Jargon"
downloaded_at: 2026-02-14T11:08:06-08:00
cleaned_at: 2026-02-14T17:55:07-08:00
---

A **Background** is a layer of tiles, mapped and possibly scrolled, that usually appears behind the sprite layer. The SNES supports up to four simultaneous backgrounds, conventionally named:

- BG1
- BG2
- BG3
- BG4

throughout the official Super Nintendo development manual. The following table describes which background layers support which capabilities in the various background modes. For an explanation of what the enclosed numerics on the right mean, see the legend below (if a layer does not support that function, the cell is left blank).

Mode # of Layers Displayed Layer # of Tile Dots # of Tile Colors # of Palettes # of Colors Per Layer Function 0 max 4 BG1 8x8 4 8 32 ① ② ③ ⑤ ⑥ ⑦ ⑧ ⑩ BG2 or 4 8 32 ① ② ③ ⑤ ⑥ ⑦ ⑧ ⑩ BG3 16x16 4 8 32 ① ② ③ ⑤ ⑥ ⑦ ⑧ ⑩ BG4 4 8 32 ① ② ③ ⑤ ⑥ ⑦ ⑧ ⑩ 1 max 3 BG1 " 16 8 128 ① ② ③ ⑤ ⑥ ⑦ ⑧ ⑩ BG2 16 8 128 ① ② ③ ⑤ ⑥ ⑦ ⑧ ⑩ BG3 4 8 32 ① ② ③ ⑤ ⑥ ⑦ ⑧ ⑩ 2 max 2 BG1 " 16 8 128 ① ② ③ ⑤ ⑥ ⑦ ⑧ ⑩ ⑪ BG2 16 8 128 ① ② ③ ⑤ ⑥ ⑦ ⑧ ⑩ ⑪ 3 max 2 BG1 " 256 1 256 ① ② ③ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩ BG2 16 8 128 ① ② ③ ⑤ ⑥ ⑦ ⑧ ⑩ 4 max 2 BG1 " 256 1 256 ① ② ③ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩ ⑪ BG2 4 8 32 ① ② ③ ⑤ ⑥ ⑦ ⑧ ⑩ ⑪ 5 max 2 BG1 " 16 8 128 ① ② ③ ⑤ ⑦ ⑧ ⑫ BG2 4 8 32 ① ② ③ ⑤ ⑦ ⑧ ⑫ 6 1 BG1 16x8 16 8 128 ① ② ③ ⑤ ⑦ ⑧ ⑪ ⑫ 7 1 BG1 8x8 256 1 256 ① ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩ EXT BG 1 BG1 8x8 128 1 128 ① ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩

### Legend

① Horizontal/Vertical Scrolling (each layer)

② Horizontal/Vertical Flip (each tile)

③ Mosaic

④ Rotate, Enlarge, Shrink ([affine transformations](https://www.mathworks.com/discovery/affine-transformation.html))

⑤ Window Mask

⑥ Screen Addition/Subtraction

⑦ Fixed Color Addition/Subtraction

⑧ Color Window

⑨ Direct Color

⑩ Horizontal Pseudo 512 Mode

⑪ Offset Change Mode

⑫ Horizontal 512 Mode

### References

1. [Appendix A-5 of Book I](https://archive.org/details/SNESDevManual/book1/page/n199) of the official Super Nintendo development manual
2. Chapter 3, "Background (BG)" on [page 2-3-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n62), lbid
