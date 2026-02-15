---
title: "Bank"
reference_url: https://sneslab.net/wiki/Bank
categories:
  - "ASM"
downloaded_at: 2026-02-14T11:09:21-08:00
cleaned_at: 2026-02-14T17:51:10-08:00
---

A **Bank** is 256 contiguous pages in the 65c816's address space. This is equivalent to 64K (65,536 bytes).

The first byte of a bank is always located at an address of the form $xx:0000, where xx is the bank number. A colon is commonly used to separate bank numbers from the low 16 bits of the address. A **bank boundary** occurs between byte $FFFF of one bank and byte $0000 of the next.

VRAM and ARAM are technically not addressable from the 5A22 but are both exactly one bank in size, which is why nobody talks about bank switching on them.

WRAM is two banks.

The SNES can address up to 256 banks on address bus A. The data bank register holds the bank number the S-CPU is configured to use. The program bank register tells the 65c816 what bank to fetch the next opcode from.

The direct page and stack are always in bank zero.

### See Also

- PHD
- PLD
- PHK
- Cartridge Bank Switching

### Reference

- Eyes & Lichty, [page 53](https://archive.org/details/0893037893ProgrammingThe65816/page/53)
