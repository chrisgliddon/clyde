---
title: "STY"
reference_url: https://sneslab.net/wiki/STY
categories:
  - "ASM"
  - "Group_Three_Instructions"
  - "Inherited_from_6502"
  - "Load/Store_Instructions"
downloaded_at: 2026-02-14T16:40:19-08:00
cleaned_at: 2026-02-14T17:53:20-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute 8C 3 bytes 4 cycles* Direct Page 84 2 bytes 3 cycles* Direct Page Indexed by X 94 2 bytes 4 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**STY** (Store Y) is a 65x instruction that stores the value of the Y index register. If Y is 16-bit, its high byte is stored to the effective address plus one.

No flags are affected.

#### Syntax

```
STY addr
STY dp
STY dp, X
```

#### Cycle Penalties

- STY takes one additional cycle when the index registers are 16 bits wide, in all addressing modes.
- In both direct page addressing modes only, STY takes another additional cycle if the low byte of the direct page register is nonzero.

### See Also

- LDY
- STA
- STX
- STZ
- TYA
- TYX

### External Links

- Eyes & Lichty, [page 506](https://archive.org/details/0893037893ProgrammingThe65816/page/506) on STY
- Labiak, [page 187](https://archive.org/details/Programming_the_65816/page/n197) on STY
- 7.3 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 97](https://archive.org/details/mos_microcomputers_programming_manual/page/n115) on STY
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 274](https://archive.org/details/6502UsersManual/page/n287) on STY
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-98](https://archive.org/details/6502-assembly-language-programming/page/n147) on STY
- snes9x implementation of STY: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1302](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1302)
- undisbeliever on STY: [https://undisbeliever.net/snesdev/65816-opcodes.html#sty-store-index-register-y-to-memory](https://undisbeliever.net/snesdev/65816-opcodes.html#sty-store-index-register-y-to-memory)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#STY](http://www.6502.org/tutorials/6502opcodes.html#STY)
