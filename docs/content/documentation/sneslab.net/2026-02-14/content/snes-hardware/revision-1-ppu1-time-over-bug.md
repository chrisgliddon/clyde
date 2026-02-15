---
title: "Revision 1 PPU1 Time Over Bug"
reference_url: https://sneslab.net/wiki/Revision_1_PPU1_Time_Over_Bug
categories:
  - "SNES_Hardware"
  - "Video"
downloaded_at: 2026-02-14T16:14:12-08:00
cleaned_at: 2026-02-14T17:54:29-08:00
---

The **Revision 1 PPU1 Time Over Bug** is a hardware problem documented by Nintendo.

### Trigger

All three of the following conditions must be present for the problem to trigger:

- The size of OBJ 0 is 16x16, 32x32, or 64x64
- OBJ 0's horizontal position is 0 through 255
- There are other objects with negative horizontal positions (offscreen)

### Symptom

- The [Time Over Flag](/mw/index.php?title=Time_Over_Flag&action=edit&redlink=1 "Time Over Flag (page does not exist)") becomes set

### See Also

- Revision 1 CPU DMA crash

### References

- [page 2-25-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n112) of the official Super Nintendo development manual
