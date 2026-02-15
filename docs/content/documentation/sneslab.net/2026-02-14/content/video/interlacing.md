---
title: "Interlacing"
reference_url: https://sneslab.net/wiki/Interlacing
categories:
  - "Video"
  - "Official_Jargon"
downloaded_at: 2026-02-14T13:28:53-08:00
cleaned_at: 2026-02-14T17:55:10-08:00
---

The SNES supports **interlacing** in all background modes.\[1] It is enabled by setting bit 0 of SETINI (2133h). When enabled in Mode 5 or Mode 6, the vertical resolution is doubled. The space of possible vertical sprite positions will not be doubled. When enabled in the other six background modes, the PPU will draw the same picture for both fields (unless VRAM has been changed in-between).

In interlacing on the SNES, the first field is called "odd" and the second field is called "even."\[2]

For even fields, the electron beam begins scanning at the top-middle of the screen instead of the top-left like in odd fields. For odd fields, it finishes scanning at the middle-bottom instead of the bottom-right like in even fields. \[2]

### References

1. Official Super Nintendo development manual on interlacing: [page 2-18-1 of Book I](https://archive.org/details/SNESDevManual/book1/page/n88)
2. Figure 2-1-2 Scanning Pattern for Interlace on [page 2-1-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n59), lbid
3. [https://nesdoug.com/2022/05/30/other-modes](https://nesdoug.com/2022/05/30/other-modes)
