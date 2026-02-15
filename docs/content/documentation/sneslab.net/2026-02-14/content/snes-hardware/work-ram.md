---
title: "Work RAM"
reference_url: https://sneslab.net/wiki/Work_RAM
categories:
  - "SNES_Hardware"
  - "Integrated_Circuits"
  - "ICs_with_unconnected_pins"
  - "Address_Spaces"
downloaded_at: 2026-02-14T17:18:56-08:00
cleaned_at: 2026-02-14T17:54:40-08:00
---

**WRAM** (Work RAM) serves as the SNES' main memory. It is 128K x 8 bits (131,072 bytes) in size, which is exactly two banks. It has part number 21326. \[3] WRAM is located at $7E:0000.\[1]

Even though WRAM has both Address Bus A and Address Bus B connected to it, the chip can only pay attention to one at a time, so WRAM-to-WRAM DMA isn't possible.

WRAM is left intact by a Reset. \[2] But, Nintendo still recommendeds checking to make sure the contents are correct after a reset. \[5] WRAM is DRAM and as such must be refreshed.

### See Also

- ARAM
- VRAM
- OAM

### References

1. [https://problemkaputt.de/fullsnes.htm#snesmemoryworkramaccess](https://problemkaputt.de/fullsnes.htm#snesmemoryworkramaccess)
2. [https://problemkaputt.de/fullsnes.htm#snescontrollersotherinputs](https://problemkaputt.de/fullsnes.htm#snescontrollersotherinputs)
3. [page 1 of Book II](https://archive.org/details/SNESDevManual/book2/page/n404), "Super NES Parts List" in the official Nintendo development manual
4. paragraph 22.3 on [page 2-22-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n97), lbid
5. caution #11: [page 2-24-3 of Book I](https://archive.org/details/SNESDevManual/book1/page/n105)
