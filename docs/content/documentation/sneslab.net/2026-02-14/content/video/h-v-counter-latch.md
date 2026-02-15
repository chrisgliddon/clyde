---
title: "H/V Counter Latch"
reference_url: https://sneslab.net/wiki/H/V_Counter_Latch
categories:
  - "Video"
  - "Timing"
  - "Registers"
downloaded_at: 2026-02-14T13:15:58-08:00
cleaned_at: 2026-02-14T17:55:10-08:00
---

The **H/V Counter Latch** (SLHV, or Software Latch Horizontal/Vertical) is a dummy read-only S-PPU1 register located at 2137h. Its sole purpose is to cause the PPU to latch the current raster beam position into OPHCT and OPVCT when it is read. The value read is open bus.

### See Also

- H/V Count Timer

### References

- [page 2-11-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n76) of the official Super Nintendo development manual
- 2.3 The Super NES Horizontal/Vertical Counter on [page 4-2-4 of Book II](https://archive.org/details/SNESDevManual/book2/page/n334), lbid
- [https://problemkaputt.de/fullsnes.htm#snespputimersandstatus](https://problemkaputt.de/fullsnes.htm#snespputimersandstatus)
