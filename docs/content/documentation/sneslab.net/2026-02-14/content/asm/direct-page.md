---
title: "Direct Page"
reference_url: https://sneslab.net/wiki/Direct_Page
categories:
  - "ASM"
  - "65c816_additions"
downloaded_at: 2026-02-14T11:46:33-08:00
cleaned_at: 2026-02-14T17:51:50-08:00
---

The **Direct Page** (DP) is much like the zeropage on the 6502, but can be moved around to anywhere within the first 64K bank. It is technically, as its namesake, the 256 bytes accessible via **Direct Page Addressing**, and has special handling of wrapping behavior. Colloquial usage of this term will invariably refer to the **Direct Page Register** itself and by extension the group of Direct addressing modes it affects, due to the other addressing modes not being limited to 256 bytes. The wrapping behavior will *always* confine it to Bank 0, but if in emulation mode will also confine it to the zeropage when both DL and DH are zero or a single bank 0 page when DL is zero (see case A of \[2]).

The direct page may overlap the stack.\[4]

There are two ways to relocate the direct page:\[1]

- PLD - pulling the new location off the stack
- TCD - using the accumulator's value as the new location

It is possible to relocate the direct page even in emulation mode, and instructions that used zero page addressing on the 6502 will still add the value of the direct page register in when computing the effective address. Unfortunately TXD, TYD, and TSD do not exist. Neither do TDX or TDY.

On the SPC700, the direct page can only be in one of two places: either coincident with page zero or page one.

### See Also

- PHD
- TDC
- Direct Page Flag
- Direct Page Register
- Direct Page Addressing
- Uppermost Page

### References

1. Eyes & Lichty, [page 198](https://archive.org/details/0893037893ProgrammingThe65816/page/198)
2. Clark, Bruce. [6502 Reference](/mw/index.php?title=6502_Reference&action=edit&redlink=1 "6502 Reference (page does not exist)") 5.1.1, [http://www.6502.org/tutorials/65c816opcodes.html#5.1.1](http://www.6502.org/tutorials/65c816opcodes.html#5.1.1)
3. Clark, Bruce. [6502 Reference](/mw/index.php?title=6502_Reference&action=edit&redlink=1 "6502 Reference (page does not exist)") 5.1.2, [http://www.6502.org/tutorials/65c816opcodes.html#5.1.2](http://www.6502.org/tutorials/65c816opcodes.html#5.1.2)
4. [https://wilsonminesco.com/816myths](https://wilsonminesco.com/816myths)
