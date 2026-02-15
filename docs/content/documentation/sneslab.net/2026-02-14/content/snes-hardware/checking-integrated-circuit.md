---
title: "Checking Integrated Circuit"
reference_url: https://sneslab.net/wiki/Checking_Integrated_Circuit
categories:
  - "SNES_Hardware"
  - "Integrated_Circuits"
downloaded_at: 2026-02-14T11:28:48-08:00
cleaned_at: 2026-02-14T17:54:08-08:00
---

There are two CIC chips: one on the SNES Motherboard and one in the Game Pak. When the power is on, they are sending data streams to each other. If something goes wrong, the CIC in the Control Deck resets the console.

The CIC in the Control Deck has a 4.00 MHz clock, which also clocks the CIC in the Game Pak. \[3]

The CIC's program counter consists of a 3-bit bank and a 7-bit Polynomial Counter.

A CIC chip exists in the [Super Game Boy](/mw/index.php?title=Super_Game_Boy&action=edit&redlink=1 "Super Game Boy (page does not exist)") as well.\[4]

### External Links

1. [https://snescentral.com/chips.php?chiptype=CIC](https://snescentral.com/chips.php?chiptype=CIC)
2. [https://problemkaputt.de/fullsnes.htm#snescartridgeciclockoutchip](https://problemkaputt.de/fullsnes.htm#snescartridgeciclockoutchip)
3. [Page 2-22-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n98) of the official Super Nintendo development manual
4. page 138 of the Game Boy Programming Manual, version 1.1
