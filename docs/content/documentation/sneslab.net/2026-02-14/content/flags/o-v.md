---
title: "O/V"
reference_url: https://sneslab.net/wiki/O/V
categories:
  - "Flags"
  - "ASM"
  - "Super_FX"
downloaded_at: 2026-02-14T15:43:58-08:00
cleaned_at: 2026-02-14T17:53:51-08:00
---

**O/V** is the Super FX's overflow flag. It is bit 4 of 3030h.

It is affected by the following instructions:

- ADC Rn
- ADC #n
- ADD Rn
- ADD #n
- CMP Rn
- MERGE
- MOVES
- SBC Rn
- SUB Rn
- SUB #n

It affects the behavior of the following instructions:

- BVC
- BVS
- BGE
- BLT

### See Also

- Sign Flag
- Overflow Flag

### Reference

- 9.3 "Operator Functions" on [page 2-9-2 of Book II](https://archive.org/details/SNESDevManual/book2/page/n158) of the official Super Nintendo development manual
- Table 2-4-2 GSU Status Register Flags on [page 2-4-4 of Book II](https://archive.org/details/SNESDevManual/book2/page/n110), lbid.
