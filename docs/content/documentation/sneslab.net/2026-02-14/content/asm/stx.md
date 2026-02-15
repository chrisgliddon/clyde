---
title: "STX"
reference_url: https://sneslab.net/wiki/STX
categories:
  - "Inherited_from_6502"
  - "Load/Store_Instructions"
downloaded_at: 2026-02-14T16:40:12-08:00
cleaned_at: 2026-02-14T17:53:19-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute 8E 3 bytes 4 cycles* Direct Page 86 2 bytes 3 cycles* Direct Page Indexed by Y 96 2 bytes 4 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**STX** (Store X) is a 65x instruction that stores the value of the X index register. If X is 16-bit, its high byte is stored to the effective address plus one.

No flags are affected.

#### Syntax

```
STX addr
STX dp
STX dp, Y
```

#### Cycle Penalties

- STX takes one additional cycle when the index registers are 16 bits wide, in all addressing modes.
- In both direct page addressing modes only, STX takes another additional cycle if the low byte of the direct page register is nonzero.

### See Also

- LDX
- STA
- STY
- STZ
- TXA
- TXY
- TXS

### External Links

- Eyes & Lichty, [page 505](https://archive.org/details/0893037893ProgrammingThe65816/page/505), on STX
- Labiak, [page 186](https://archive.org/details/Programming_the_65816/page/n196) on STX
- 7.2 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 97](https://archive.org/details/mos_microcomputers_programming_manual/page/n115) on STX
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 274](https://archive.org/details/6502UsersManual/page/n287) on STX
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-97](https://archive.org/details/6502-assembly-language-programming/page/n146) on STX
- snes9x implementation of STX: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1287](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1287)
- undisbeliever on STX: [https://undisbeliever.net/snesdev/65816-opcodes.html#stx-store-index-register-x-to-memory](https://undisbeliever.net/snesdev/65816-opcodes.html#stx-store-index-register-x-to-memory)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#STX](http://www.6502.org/tutorials/6502opcodes.html#STX)
