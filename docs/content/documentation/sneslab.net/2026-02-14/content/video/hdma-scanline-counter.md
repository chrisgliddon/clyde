---
title: "HDMA Scanline Counter"
reference_url: https://sneslab.net/wiki/HDMA_Scanline_Counter
categories:
  - "Video"
downloaded_at: 2026-02-14T13:17:27-08:00
cleaned_at: 2026-02-14T17:55:10-08:00
---

The **HDMA Scanline Counter** is bits 0-6 of NTRLx (43xAh). Its value is loaded from the high 7 bits of the first byte of an HDMA table automatically. Then, it is decremented by one for every scanline rendered.

### See Also

- Continue Flag

### Reference

- [page 2-28-13 of Book I](https://archive.org/details/SNESDevManual/book1/page/n151) of the official Super Nintendo development manual
