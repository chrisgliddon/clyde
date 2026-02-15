---
title: "LDX"
reference_url: https://sneslab.net/wiki/LDX
categories:
  - "ASM"
  - "Group_Two_Instructions"
  - "Inherited_from_6502"
  - "Load/Store_Instructions"
downloaded_at: 2026-02-14T13:34:28-08:00
cleaned_at: 2026-02-14T17:52:15-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate A2 2/3 bytes 2 cycles* Absolute AE 3 bytes 4 cycles* Direct Page A6 2 bytes 3 cycles* Absolute Indexed by Y BE 3 bytes 4 cycles* Direct Page Indexed by Y B6 2 bytes 4 cycles*

Flags Affected N V M X D I Z C N . . . . . Z .

**LDX** (Load X) is a 65x instruction that loads a value into the X index register. In immediate addressing only, LDX is a total of 3 bytes long when the index registers are 16 bits wide.

#### Syntax

```
LDX #const
LDX addr
LDX dp
LDX addr, Y
LDX dp, Y
```

#### Cycle Penalties

- In direct page addressing modes, LDX takes another extra cycle if the low byte of the direct page register is nonzero.

### See Also

- STX
- LDA
- LDY
- TAX
- TYX
- TSX

### External Links

- Eyes & Lichty, [page 463](https://archive.org/details/0893037893ProgrammingThe65816/page/463) on LDX
- Labiak, [page 150](https://archive.org/details/Programming_the_65816/page/n160) on LDX
- 7.0 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 96](https://archive.org/details/mos_microcomputers_programming_manual/page/n114) on LDX
- [B-18](https://archive.org/details/mos_microcomputers_programming_manual/page/n219), lbid.
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 264](https://archive.org/details/6502UsersManual/page/n277) on LDX
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-72](https://archive.org/details/6502-assembly-language-programming/page/n121) on LDX
- snes9x implementation of LDX: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L772](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L772)
- undisbeliever on LDX: [https://undisbeliever.net/snesdev/65816-opcodes.html#ldx-load-index-register-x-from-memory](https://undisbeliever.net/snesdev/65816-opcodes.html#ldx-load-index-register-x-from-memory)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#LDX](http://www.6502.org/tutorials/6502opcodes.html#LDX)
