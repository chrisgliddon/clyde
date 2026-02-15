---
title: "LDY"
reference_url: https://sneslab.net/wiki/LDY
categories:
  - "Inherited_from_6502"
  - "Load/Store_Instructions"
downloaded_at: 2026-02-14T13:34:33-08:00
cleaned_at: 2026-02-14T17:52:16-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate A0 2/3 bytes 2 cycles* Absolute AC 3 bytes 4 cycles* Direct Page A4 2 bytes 3 cycles* Absolute Indexed by X BC 3 bytes 4 cycles* Direct Page Indexed by X B4 2 bytes 4 cycles*

Flags Affected N V M X D I Z C N . . . . . Z .

**LDY** (Load Y) is a 65x instruction that loads a value into the Y index register. In immediate addressing only, LDY takes a total of 3 bytes when the index registers are 16 bits wide.

#### Syntax

```
LDY #const
LDY addr
LDY dp
LDY addr, X
LDY dp, X
```

#### Cycle Penalties

- In direct page addressing modes, LDY takes another extra cycle if the low byte of the direct page register is nonzero.

### See Also

- STY
- LDA
- LDX
- TAY
- TXY

### External Links

- Eyes & Lichty, [page 464](https://archive.org/details/0893037893ProgrammingThe65816/page/n490) on LDY
- Labiak, [page 151](https://archive.org/details/Programming_the_65816/page/n161) on LDY
- 7.1 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 96](https://archive.org/details/mos_microcomputers_programming_manual/page/n114) on LDY
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 264](https://archive.org/details/6502UsersManual/page/n277) on LDY
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-74](https://archive.org/details/6502-assembly-language-programming/page/n123) on LDY
- snes9x implementation of LDY: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L817](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L817)
- undisbeliever on LDY: [https://undisbeliever.net/snesdev/65816-opcodes.html#ldy-load-index-register-y-from-memory](https://undisbeliever.net/snesdev/65816-opcodes.html#ldy-load-index-register-y-from-memory)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#LDY](http://www.6502.org/tutorials/6502opcodes.html#LDY)
