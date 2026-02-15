---
title: "Machine Cycle"
reference_url: https://sneslab.net/wiki/Machine_Cycle
categories:
  - "SNES_Hardware"
  - "Official_Jargon"
  - "Inherited_from_6502"
  - "Timing"
downloaded_at: 2026-02-14T14:57:45-08:00
cleaned_at: 2026-02-14T17:54:20-08:00
---

A **Machine Cycle** is one tick of the 5A22. It may be configured to take 6, 8, or 12 master clock cycles. In the SNES scene, we call the 6:1 configuration fastROM and the 8:1 configuration slowROM. The 5A22 decides which configuration to use depending on the address that is on the 65c816's address bus, and clocks the '816 clock input accordingly.

Multiplication takes about 8 machine cycles and division takes about 16.\[3]

### See Also

- Internal Cycle
- STP

### References

1. last bullet point under 13.2 of [page 2-13-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n78) of the official Super Nintendo development manual
2. Figure 3-4-2 "Clear Timing" on [page 3-4-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n161), lbid.
3. 15.2 Absolute Multiplication/Division on [page 2-15-1 on Book I](https://archive.org/details/SNESDevManual/book1/page/n81), lbid.
4. [https://ersanio.gitbook.io/assembly-for-the-snes/deep-dives/cycles](https://ersanio.gitbook.io/assembly-for-the-snes/deep-dives/cycles)
