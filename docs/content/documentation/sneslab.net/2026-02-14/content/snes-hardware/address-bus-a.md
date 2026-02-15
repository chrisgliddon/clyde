---
title: "Address Bus A"
reference_url: https://sneslab.net/wiki/Address_Bus_A
categories:
  - "SNES_Hardware"
  - "Traces"
  - "Buses"
downloaded_at: 2026-02-14T10:55:35-08:00
cleaned_at: 2026-02-14T17:54:05-08:00
---

**Address Bus A** is the SNES' 24-bit bus. It is drawn in orange in the colorized jwdonal schematic, and its individual address lines are labeled CA0-CA23.

It is connected to:

- S-CPU pins 2-17 and 93-100
- WRAM pins 23-31 and pins 34-42
- Cartridge Slot pins 6-17 and 37-48

It is 24 bits wide because that is how big the 5A22's address space is:

- The high 8 bits are the bank byte
- The middle 8 bits are the page number
- The low 8 bits are the byte number

It can address up to 16 megabytes, which is enough for most games, but some games use cartridge bank switching to address even more.

### See Also

- Address Bus B
- CPU Data Bus

### Reference

1. Figure 2-22-1, "Super NES Functional Block Diagram" on [page 2-22-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n98)
