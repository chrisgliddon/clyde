---
title: "Write-Twice Register"
reference_url: https://sneslab.net/wiki/Write-Twice_Register
categories:
  - "SNES_Hardware"
  - "Registers"
  - "Buffers"
downloaded_at: 2026-02-14T17:19:07-08:00
cleaned_at: 2026-02-14T17:54:41-08:00
---

**Write-twice registers** need to be written to twice before their value is updated. They are 16 bits wide but are mapped to only 8-bits in an address space. The motivation behind write-twice registers is that they prevent glitches caused by software accidentally only updating half of a 16-bit register. This is accomplished via an additional, hidden 8-bit buffer:

- On the first write, the 8-bit value on the CPU Data Bus is written to the hidden buffer, but the contents of the 16-bit register are not updated yet.
- On the second write, both the new 8-bit value on the data bus and the buffered 8-bit value both overwrite the old contents of the 16-bit register simultaneously.

Some examples of write-twice registers are:

- 2104h - OAMDATA - OAM Data Write
- 210Dh - BG1HOFS - BG1 Horizontal Offset / M7HOFS
- 210Eh - BG1VOFS - BG1 Vertical Offset / M7VOFS
- 210Fh - BG2HOFS - BG2 Horizontal Offset
- 2110h - BG2VOFS - BG2 Vertical Offset
- 2111h - BG3HOFS - BG3 Horizontal Offset
- 2112h - BG3VOFS - BG3 Vertical Offset
- 2113h - BG4HOFS - BG4 Horizontal Offset
- 2114h - BG4VOFS - BG4 Vertical Offset
- 211Dh - M7C - Rotation/Scaling Parameter C
- 211Eh - M7D - Rotation/Scaling Parameter D
- 211Fh - M7X - Rotation/Scaling Center Coordinate X
- 2120h - M7Y - Rotation/Scaling Center Coordinate Y
- 2122h - CGDATA - Palette CGRAM Data Write

Fullsnes says a flipflop keeps track of whether we are on the 1st or 2nd access for CGRAM writes.\[2]

### References

1. [https://retrocomputing.stackexchange.com/a/7071](https://retrocomputing.stackexchange.com/a/7071)
2. [https://problemkaputt.de/fullsnes.htm#snesmemorycgramaccesspalettememory](https://problemkaputt.de/fullsnes.htm#snesmemorycgramaccesspalettememory)
