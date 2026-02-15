---
title: "TXS"
reference_url: https://sneslab.net/wiki/TXS
categories:
  - "ASM"
  - "Inherited_from_6502"
  - "Transfer_Instructions"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
downloaded_at: 2026-02-14T17:00:41-08:00
cleaned_at: 2026-02-14T17:53:35-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) 9A 1 byte 2 cycles

Flags Affected N V M X D I Z C . . . . . . . .

**TXS** (Transfer X to Stack Pointer) is a 65x instruction that transfers the value of the X index register to the stack pointer.

- If X is 16 bits wide then all 16 bits are transferred.
- If X is 8 bits wide but the stack pointer is 16 bits wide then X is transferred to the low byte and the high byte of the stack pointer is cleared.
- If both X and the stack pointer are 8 bits wide (aka emulation mode) then 8 bits are transferred

TXS always takes two cycles, regardless of whether one or two bytes are transferred. No flags are affected.

#### Syntax

```
TXS
```

### See Also

- TSX
- TCS
- TXA

### External Links

- Eyes & Lichty, [page 518](https://archive.org/details/0893037893ProgrammingThe65816/page/518) on TXS
- Labiak, [page 199](https://archive.org/details/Programming_the_65816/page/n209) on TXS
- 8.8 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 120](https://archive.org/details/mos_microcomputers_programming_manual/page/n139) on TXS
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 277](https://archive.org/details/6502UsersManual/page/n290) on TXS
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-103](https://archive.org/details/6502-assembly-language-programming/page/n152) on TXS
- snes9x implementation of TXS: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2415](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2415)
