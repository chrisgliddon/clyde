---
title: "VRAM Address Increment High/Low Flag"
reference_url: https://sneslab.net/wiki/VRAM_Address_Increment_High/Low_Flag
categories:
  - "SNES_Hardware"
  - "Flags"
downloaded_at: 2026-02-14T17:13:01-08:00
cleaned_at: 2026-02-14T17:54:38-08:00
---

The **VRAM Address Increment High/Low Flag** is bit 7 of VMAIN (2115h).

It controls when the hardware automatically increments the value of VMDATAL/VMDATAH.

When set, the VRAM address will be incremented after accessing the high byte. When clear, the VRAM address will be incremented before accessing the high byte and after accessing the low byte.

### Reference

- [https://problemkaputt.de/fullsnes.htm#snesmemoryvramaccesstileandbgmap](https://problemkaputt.de/fullsnes.htm#snesmemoryvramaccesstileandbgmap)
- [page 2-27-6 of Book I](https://archive.org/details/SNESDevManual/book1/page/n119) of the official Super Nintendo development manual
