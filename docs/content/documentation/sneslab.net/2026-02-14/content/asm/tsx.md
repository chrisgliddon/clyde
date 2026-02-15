---
title: "TSX"
reference_url: https://sneslab.net/wiki/TSX
categories:
  - "Inherited_from_6502"
  - "Transfer_Instructions"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
downloaded_at: 2026-02-14T17:00:11-08:00
cleaned_at: 2026-02-14T17:53:33-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) BA 1 byte 2 cycles

Flags Affected N V M X D I Z C N . . . . . Z .

**TSX** (Transfer Stack Pointer to X) is a 65x instruction that transfers the value of the stack pointer to the X index register.

- If X is only 8 bits wide then only the low byte of the stack pointer is transferred.
- Otherwise, all 16 bits are transferred.

TSX always takes two cycles, regardless of whether one or two bytes are transferred.

#### Syntax

```
TSX
```

### See Also

- TXS
- TSC

### External Links

- Eyes & Lichty, [page 516](https://archive.org/details/0893037893ProgrammingThe65816/page/516) on TSX
- Labiak, [page 197](https://archive.org/details/Programming_the_65816/page/n207) on TSX
- 8.9 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 122](https://archive.org/details/mos_microcomputers_programming_manual/page/n141) on TSX
- [B-29](https://archive.org/details/mos_microcomputers_programming_manual/page/n230), lbid.
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 276](https://archive.org/details/6502UsersManual/page/n289) on TSX
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-101](https://archive.org/details/6502-assembly-language-programming/page/n150) on TSX
- snes9x implementation of TSX: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2353](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2353)
