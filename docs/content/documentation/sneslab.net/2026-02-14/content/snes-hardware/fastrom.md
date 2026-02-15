---
title: "FastROM"
reference_url: https://sneslab.net/wiki/FastROM
categories:
  - "SNES_Hardware"
  - "Scene_Slang"
  - "Timing"
downloaded_at: 2026-02-14T12:01:54-08:00
cleaned_at: 2026-02-14T17:54:14-08:00
---

**FastROM** is 3.58 MHz and its ROM access speed is 120ns. It is about 33% faster than SlowROM. FastROM is a property of the ROM chip itself and not the board it is soldered onto.\[2] When the 5A22 is operating at fastROM speed, there are 6 master clock cycles per CPU machine cycles.

FastROM speeds only apply to the upper halves of banks $80-bf and all of banks $c0-ff.\[1]

The SAS cannot use FastROM.\[3] Games which utilize fastrom should indicate this at bit 4 of FFD5 of the cartridge header.\[4]

### See Also

- List of FastROM Games
- 420Dh

### External Links

- [https://gbatemp.net/threads/romhacker-kandowontu-converts-more-than-80-snes-titles-into-fastrom-improving-their-performance.629133](https://gbatemp.net/threads/romhacker-kandowontu-converts-more-than-80-snes-titles-into-fastrom-improving-their-performance.629133)
- "High Speed Required?" checkbox on [page 1-2-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n26) of the official Super Nintendo development manual

### References

1. Near, [https://forums.nesdev.org/viewtopic.php?t=9585](https://forums.nesdev.org/viewtopic.php?t=9585)
2. Bregalad, lbid.
3. caution 3.3.6.1 on [page 1-3-4 of Book II](https://archive.org/details/SNESDevManual/book2/page/n20) of the official Super Nintendo development manual
4. [http://problemkaputt.de/fullsnes.htm#snesmemorycontrol](http://problemkaputt.de/fullsnes.htm#snesmemorycontrol)
