---
title: "Uppermost Page"
reference_url: https://sneslab.net/wiki/Uppermost_Page
categories:
  - "ASM"
  - "SPC700"
  - "Official_Jargon"
downloaded_at: 2026-02-14T17:10:04-08:00
cleaned_at: 2026-02-14T17:53:40-08:00
---

The **Uppermost Page** is the contiguous region of 256 bytes in ARAM with the highest possible address, located at $FF00. It/offsets within it are abbreviated "upage."\[1]

Both TCALL and PCALL utilize it.

The 64-byte SPC700/IPL ROM lives in the uppermost page at FFC0h.\[2] But, reading this 64-byte region only returns ROM data when bit 7 of the CONTROL register (00F1h) is set. If bit 7 is clear, then the IPL ROM is currently unmapped, revealing 64 bytes of normal ARAM underneath which will be mapped and read instead. Writes to this 64 byte region always affect the underlying RAM even if CONTROL's bit 7 is set.

### See Also

- Zero page
- Direct page

### References

1. [Appendix C-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n226) of the official Super Nintendo development manual
2. fullsnes
