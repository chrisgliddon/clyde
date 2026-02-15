---
title: "ARAM Write Enable Flag"
reference_url: https://sneslab.net/wiki/ARAM_Write_Enable_Flag
categories:
  - "SNES_Hardware"
  - "SPC700"
  - "Flags"
downloaded_at: 2026-02-14T10:50:03-08:00
cleaned_at: 2026-02-14T17:54:06-08:00
---

The **ARAM Write Enable Flag** is bit 1 of the S-SMP's TEST register (00F0h):

- When set, the S-SMP and S-DSP can both read and write to ARAM.
- When clear, they can only read ARAM.

### Reference

- [https://problemkaputt.de/fullsnes.htm#snesapuspc700ioports](https://problemkaputt.de/fullsnes.htm#snesapuspc700ioports)
