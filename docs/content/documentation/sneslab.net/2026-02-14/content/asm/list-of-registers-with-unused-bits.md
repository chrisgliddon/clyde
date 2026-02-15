---
title: "List of Registers with Unused Bits"
reference_url: https://sneslab.net/wiki/List_of_Registers_with_Unused_Bits
categories:
  - "ASM"
  - "SNES_Hardware"
  - "Registers"
  - "Lists"
downloaded_at: 2026-02-14T13:42:07-08:00
cleaned_at: 2026-02-14T17:52:17-08:00
---

The SNES has several registers which do not use all of their 8 bits. Some of them are:

Common Name Unused Bits INIDISP 4 - 6 OAMADDH 1 - 6 VMAINC 4 - 6 M7SEL 2 - 5 WOBJLOG 4 - 7 TM 5 - 7 TS 5 - 7 TMW 5 - 7 TSW 5 -7 CGSWSEL 2 - 3 SETINI 4 - 5 STAT77 4 STAT78 5 WMADDH 1 - 7 NMITIMEN 1 - 3 & 6 HTIMEH 1 - 7 VTIMEH 1 - 7 MEMSEL 1 - 7 RDNMI 4 - 6 TIMEUP 0 - 6 HVBJOY 1 - 5 STD CTRL 1L 0 - 3 STD CTRL 2L 0 - 3 STD CTRL 3L 0 - 3 STD CTRL 4L 0 - 3 PMON 0

Bits 10-12 of the Offset Change Mode data are unused. \[1]

- SA-1/CIC

### See Also

- [Open Bus](/mw/index.php?title=Open_Bus&action=edit&redlink=1 "Open Bus (page does not exist)")
- MDR
- The Infamous Bit-Of-Confusion

### Reference

1. [Appendix A-13 of Book I](https://archive.org/details/SNESDevManual/book1/page/n207) of the official Super Nintendo development manual
