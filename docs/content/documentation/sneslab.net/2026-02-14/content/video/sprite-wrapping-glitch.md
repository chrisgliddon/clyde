---
title: "Sprite Wrapping Glitch"
reference_url: https://sneslab.net/wiki/Sprite_Wrapping_Glitch
categories:
  - "Video"
downloaded_at: 2026-02-14T16:48:47-08:00
cleaned_at: 2026-02-14T17:55:19-08:00
---

The **Sprite Wrapping Glitch** appears to be a PPU design flaw that can occur under two conditions, according to fullsnes:

- In 224-Line Mode, when a sprite with a height of 64 pixels is located near the lower screen border
- In 239-Line Mode, when a sprite with a height of 32 pixels is located near the lower screen border

The sprite can reappear at the upper screen border.

### See Also

- Mid-Scanline Color Distortion

### Reference

- [https://problemkaputt.de/fullsnes.htm#snesppuspritesobjs](https://problemkaputt.de/fullsnes.htm#snesppuspritesobjs)
