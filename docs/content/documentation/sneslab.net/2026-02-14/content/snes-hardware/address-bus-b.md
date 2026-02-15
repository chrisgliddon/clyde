---
title: "Address Bus B"
reference_url: https://sneslab.net/wiki/Address_Bus_B
categories:
  - "SNES_Hardware"
  - "Traces"
  - "Buses"
downloaded_at: 2026-02-14T10:55:41-08:00
cleaned_at: 2026-02-14T17:54:05-08:00
---

**Address Bus B**, also known as the **SNES bus**, is 8-bits wide on the SNES Motherboard. Its individual address lines are labeled PA0-PA7, which stands for "peripheral address," as in S-CPU peripherals (not SNES peripherals). It is connected to:

- S-CPU pins 51-58
- S-PPU1 pins 5-12
- S-PPU2 pins 17-24
- S-SMP pins 48-51
- WRAM pins 43-47, 50, and 53-54
- Cartridge Slot pins 3, 28-30, 34, and 59-61
- Expansion Port pins 1-8

which is the exact same set of components that the CPU Data Bus is connected to. The SNES bus is drawn in purple in the colorized jwdonal schematic. Some people like to think of Address Bus B as being 16-bits wide, with the high byte being fixed to $21.\[1] An address decoder translates the 65c816's bus addresses into SNES bus addresses.\[4]

### See Also

- Address Bus A

### References

1. [https://forums.nesdev.org/viewtopic.php?p=116505#p116505](https://forums.nesdev.org/viewtopic.php?p=116505#p116505)
2. Figure 2-22-1, "Super NES Functional Block Diagram" on [page 2-22-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n98)
3. paragraph 3.2 on [page 3-3-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n160), lbid.
4. [https://forums.nesdev.org/viewtopic.php?p=195152#p195152](https://forums.nesdev.org/viewtopic.php?p=195152#p195152)
