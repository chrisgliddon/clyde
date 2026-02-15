---
title: "Memory ②"
reference_url: https://sneslab.net/wiki/Memory_②
categories:
  - "SNES_Hardware"
  - "Address_Spaces"
downloaded_at: 2026-02-14T15:32:21-08:00
cleaned_at: 2026-02-14T17:54:20-08:00
---

**Memory ②** is a region of the 5A22's address space. Memory ② is a total of 6 megabytes (exactly 6,291,456 bytes) in size, spread across:

- the upper half (8000h - FFFFh) of banks 80h - BFh, which is exactly 2,097,152 bytes (2 megabytes spread across 64 banks), and
- all of banks C0h - FFh, which is exactly 4,194,304 bytes (4 megabytes spread across 64 banks)

Thus, when labeled on a memory map, Memory ② forms a concave region; see Figure 2-21-1 of the official Super Nintendo development manual.

### See Also

- Memory ①
- RAM ①
- RAM ②

### References

1. [https://problemkaputt.de/fullsnes.htm#snesmemorycontrol](https://problemkaputt.de/fullsnes.htm#snesmemorycontrol)
2. bottom of [page 2-21-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n93), the left-hand side of the figure
3. [page 2-28-5 of Book I](https://archive.org/details/SNESDevManual/book1/page/n143) of the official Super Nintendo development manual
