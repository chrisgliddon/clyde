---
title: "DSP Area"
reference_url: https://sneslab.net/wiki/DSP_Area
categories:
  - "SNES_Hardware"
  - "Address_Spaces"
downloaded_at: 2026-02-14T11:42:11-08:00
cleaned_at: 2026-02-14T17:54:11-08:00
---

The **DSP Area** is a region of the 5A22's address space.

### Map Mode 20 (LoROM)

In Mode 20, the DSP Area is 4M in size. It is normally located from 0000h to 8000h in banks 60h - 6Fh. When the program ROM is less than 8M in size, the DSP Area is instead located from 8000h to FFFFh in banks 30h - 3Fh.

### Reference

- [page 2-21-3 of Book I](https://archive.org/details/SNESDevManual/book1/page/n94) of the official Super Nintendo development manual
