---
title: "Audio RAM"
reference_url: https://sneslab.net/wiki/Audio_RAM
categories:
  - "SNES_Hardware"
  - "Integrated_Circuits"
  - "Audio"
  - "Address_Spaces"
downloaded_at: 2026-02-14T10:58:21-08:00
cleaned_at: 2026-02-14T17:54:07-08:00
---

There are two **ARAM** chips on the SNES Motherboard, both connected to S-DSP. All accesses from the SPC700 go through the S-DSP. ARAM is a total of 65,536 bytes (or 256 pages, or one bank, or 512 kilobits) in size. ARAM is timeshared between the S-SMP and S-DSP.

According to fullsnes, ARAMs consisting of two Motorola MCM51L832F12 32Kx8 SRAM chips tend to contain a repeating 64-byte pattern of 32 zeros and then 32 FFh's at power up.

ARAM cannot be accessed directly by the 5A22 and it cannot participate in DMA.

### See Also

- WRAM
- VRAM
- ARAM Write Enable Flag
- Uppermost Page

### References

1. subparagraph 22.5.3 on [Page 2-22-3 of Book I](https://archive.org/details/SNESDevManual/book1/page/n99) of the official Super Nintendo development manual
2. subparagraph 1.3.3 on [page 3-1-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n153), lbid.
