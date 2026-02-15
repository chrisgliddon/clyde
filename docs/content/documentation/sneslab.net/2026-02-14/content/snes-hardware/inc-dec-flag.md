---
title: "INC/DEC Flag"
reference_url: https://sneslab.net/wiki/INC/DEC_Flag
categories:
  - "SNES_Hardware"
  - "Flags"
downloaded_at: 2026-02-14T13:22:32-08:00
cleaned_at: 2026-02-14T17:54:16-08:00
---

The [INC/DEC Flag]() is bit 4 of DMAPx (43x0h). It is operable when a GP-DMA is happening and the Fixed Address Flag is clear.

When clear, the A-Bus addressing serving as the DMA source/target is being automatically incremented. When set, the A-Bus address serving as the DMA source/target is being automatically decremented.

### Reference

- [page 2-28-10 of Book I](https://archive.org/details/SNESDevManual/book1/page/n148) of the official Super Nintendo development manual
