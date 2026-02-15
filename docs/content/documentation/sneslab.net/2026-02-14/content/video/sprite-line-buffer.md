---
title: "Sprite Line Buffer"
reference_url: https://sneslab.net/wiki/Sprite_Line_Buffer
categories:
  - "SNES_Hardware"
downloaded_at: 2026-02-14T16:48:30-08:00
cleaned_at: 2026-02-14T17:55:19-08:00
---

Note: The information in this overview omits the fetch line limit (which is actually 272 pixels wide or 34 8 pixel wide cells).

The **Sprite Line Buffer** is where sprites are pre-rendered to during hblank before being composited together with the backgrounds. It is 256 pixels wide, and a total of 2304 bits. Internally, it is composed of two 128x9-bit half-line buffers (1152 bits each): one storing even-numbered pixels and the other odd. For each pixel, each half-line buffer stores:

- four bits of color data
- three bits for palette number
- two priority bits

Each of these half-line buffers are clocked at 10.7 MHz (X1/2 divider) during writes and have their own address lines.

### See Also

- 35's Time Over
- 33's Range Over

### References

- [https://forums.nesdev.org/viewtopic.php?p=288520#p288520](https://forums.nesdev.org/viewtopic.php?p=288520#p288520)
- [https://board.zsnes.com/phpBB3/viewtopic.php?p=204966#p204966](https://board.zsnes.com/phpBB3/viewtopic.php?p=204966#p204966)
