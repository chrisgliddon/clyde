---
title: "Program Bank Register"
reference_url: https://sneslab.net/wiki/Program_Bank_Register
categories:
  - "SNES_Hardware"
  - "Registers"
  - "Bank_Registers"
downloaded_at: 2026-02-14T16:00:23-08:00
cleaned_at: 2026-02-14T17:54:27-08:00
---

The **Program Bank Register** (PBR or K) tells the 65c816 which bank to fetch the next opcode from. It is 8 bits wide and is cleared to zero on reset.\[2] PHK pushes it onto the stack, but there is no PLK to pull it.

PBR is affected only by these intructions (and hardware [interrupts](/mw/index.php?title=interrupt&action=edit&redlink=1 "interrupt (page does not exist)") which also zero it):\[4]

- RTI
- RTL
- JML
- JSL
- JMP absolute long
- COP (zeros it)
- BRK (zeros it)

Note that as of 2025, COP and BRK are still missing from the official list in \[4].

Incrementing the program counter past FFFFh does not affect PBR.\[4]

There is also a program bank register on the GSU.\[1] It can be used to specify any mapped bank address.\[3]

### See Also

- Data Bank Register
- LJMP

### References

1. paragraph 4.5 on [page 2-4-5 of Book II](https://archive.org/details/SNESDevManual/book2/page/n111)
2. section 2.9 on page 7 of 65c816 datasheet, [https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf](https://westerndesigncenter.com/wdc/documentation/w65c816s.pdf)
3. Figure 2-3-2 Super FX Memory Map on [page 2-3-4 of Book II](https://archive.org/details/SNESDevManual/book2/page/n106)
4. section 3.4 Program Address Space of 65c816 datasheet (COP and BRK are omitted here, but they are mentioned in section 7.11.1 and 7.11.2)
5. Eyes & Lichty, [page 53](https://archive.org/details/0893037893ProgrammingThe65816/page/53)
