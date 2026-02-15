---
title: "Continue Flag"
reference_url: https://sneslab.net/wiki/Continue_Flag
categories:
  - "Flags"
  - "SNES_Hardware"
downloaded_at: 2026-02-14T11:30:35-08:00
cleaned_at: 2026-02-14T17:53:50-08:00
---

The **Continue Flag** tells the HDMA controller whether or not to continue transferring data after the first transfer unit in an HDMA table entry has been transferred. It is bit 7 of NTRLx, and like the rest of that register, is loaded from the current HDMA table entry.\[4]

When set, the HDMA controller sends a single transfer unit to the destination every scanline, during hblank.

When clear, the HDMA controller sends a transfer unit to the destination just once, for the first scanline of that entry in the HDMA table, and then does not transfer anything else at least until reaching the Nth next scanline, where N was the initial value of the HDMA Scanline Counter, the bottom 7 bits of NTRLx.

### References

1. [page 2-28-13 of Book I](https://archive.org/details/SNESDevManual/book1/page/n151) of the official Super Nintendo development manual
2. the bit cells labeled "C" in the diagrams are the continue flag: [Appendix B-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n219), lbid
3. [https://wiki.superfamicom.org/grog's-guide-to-dma-and-hdma-on-the-snes](https://wiki.superfamicom.org/grog's-guide-to-dma-and-hdma-on-the-snes)
4. [https://problemkaputt.de/fullsnes.htm#snesdmaandhdmachannel07registers](https://problemkaputt.de/fullsnes.htm#snesdmaandhdmachannel07registers)
