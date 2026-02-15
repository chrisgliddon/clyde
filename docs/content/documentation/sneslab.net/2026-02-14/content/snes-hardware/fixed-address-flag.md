---
title: "Fixed Address Flag"
reference_url: https://sneslab.net/wiki/Fixed_Address_Flag
categories:
  - "SNES_Hardware"
  - "Flags"
downloaded_at: 2026-02-14T12:03:39-08:00
cleaned_at: 2026-02-14T17:54:14-08:00
---

The **Fixed Address Flag** is bit 3 of DMAP (43x0h). It determines whether the A-Bus address used by a GP-DMA changes while the DMA is running.

When set, the A-Bus address is fixed. This is used when clearing VRAM, for example.

When clear, the A-Bus address is automatically incremented either decremented by hardware (depending on the state of the INC/DEC Flag).

### Reference

- [page 2-28-10 of Book I](https://archive.org/details/SNESDevManual/book1/page/n148) of the official Super Nintendo development manual
