---
title: "Object Attribute Memory"
reference_url: https://sneslab.net/wiki/Object_Attribute_Memory
categories:
  - "SNES_Hardware"
downloaded_at: 2026-02-14T15:46:40-08:00
cleaned_at: 2026-02-14T17:54:25-08:00
---

**Object Attribute Memory**, also known as **OAM**, is a chunk of memory in S-PPU1\[3] that stores the data about the sprite tiles to draw onto screen. It contains 128 "sprite slots", each slot requiring 4 bytes in the main table and two additional bits stored separately in a smaller table towards the end of the OAM.

## Primary (low) table

The **primary table**, or **lowoam** in scene slang, starts at OAM address 0x000 and, as previously stated, each slot is 4 bytes big, meaning that the second slot starts at 0x004, the third at 0x008, etc. The entire primary table is 0x200 bytes big.

The first byte of each slot is the X coordinate of the upper left corner of the sprite. The second byte is the Y coordinate. The third byte is the lower 8 bits of the tile number and the fourth is the YXPPCCCT data.

## Secondary (high) table

The **secondary table**, or **hioam** in scene slang, starts at OAM address 0x200 and is merely 32 bytes large.

The first byte contains the two extra bits for slots 0-3, the second byte for 4-7, etc. The order within each byte is "lower slot at lower bits", meaning that the two lowest bits in the first byte are thus the extra bits for slot 0.

Of the two extra bits, the lowest is the 9th bit of the X position (which allows sprites to be shown partially outside the left edge of the screen. The highest of the two bits is the size bit. In SMW, this means that setting this to 0 makes it an 8x8 sprite while 1 makes it a 16x16 sprite.

### See Also

- CGRAM
- VRAM

### References

1. [https://forums.nesdev.org/viewtopic.php?p=138336#p138336](https://forums.nesdev.org/viewtopic.php?p=138336#p138336)
2. "Object Data" on [Appendix A-3](https://archive.org/details/SNESDevManual/book1/page/n197) of Book I of the official Super Nintendo development manual
3. [https://forums.nesdev.org/viewtopic.php?p=279840#p279840](https://forums.nesdev.org/viewtopic.php?p=279840#p279840)
