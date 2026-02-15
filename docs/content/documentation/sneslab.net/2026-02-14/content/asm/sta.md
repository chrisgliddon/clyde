---
title: "STA"
reference_url: https://sneslab.net/wiki/STA
categories:
  - "ASM"
  - "Group_One_Instructions"
  - "Inherited_from_6502"
  - "Load/Store_Instructions"
downloaded_at: 2026-02-14T16:39:23-08:00
cleaned_at: 2026-02-14T17:53:11-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute 8D 3 bytes 4 cycles* Absolute Long 8F 4 bytes 5 cycles* Direct Page 85 2 bytes 3 cycles* Direct Page Indirect 92 2 bytes 5 cycles* Direct Page Indirect Long 87 2 bytes 6 cycles* Absolute Indexed by X 9D 3 bytes 4 cycles* Absolute Long Indexed by X 9F 4 bytes 5 cycles* Absolute Indexed by Y 99 3 bytes 4 cycles* Direct Page Indexed by X 95 2 bytes 4 cycles* Direct Page Indexed Indirect by X 81 2 bytes 6 cycles* Direct Page Indirect Indexed by Y 91 2 bytes 5 cycles* Direct Page Indirect Long Indexed by Y 97 2 bytes 6 cycles* Stack Relative 83 2 bytes 4 cycles* Stack Relative Indirect Indexed by Y 93 2 bytes 7 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**STA** (Store Accumulator) is a 65x instruction that stores the value of the accumulator. If the accumulator is 16 bits wide, its low byte is stored at the effective address and its high byte is stored at the effective address plus one.

No flags are affected.

#### Syntax

```
STA addr
STA long
STA dp
STA (dp)
STA [dp]
STA addr, X
STA long, X
STA addr, Y
STA dp, X
STA (dp, X)
STA (dp), Y
STA [dp], Y
STA sr, S
STA (sr, S), Y
```

If you are trying to store zero somewhere, consider STZ instead.

#### Cycle Penalties

- In all addressing modes, STA takes one extra cycle when the accumulator is 16 bits wide.
- In direct page addressing modes, STA takes another extra cycle if the low byte of the direct page register is nonzero.

### See Also

- LDA
- STX
- STY

### External Links

- Eyes & Lichty, [page 503](https://archive.org/details/0893037893ProgrammingThe65816/page/503) on STA
- Labiak, [page 184](https://archive.org/details/Programming_the_65816/page/n194) on STA
- 2.1.2 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 5](https://archive.org/details/mos_microcomputers_programming_manual/page/n20) on STA
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 273](https://archive.org/details/6502UsersManual/page/n286) on STA
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-96](https://archive.org/details/6502-assembly-language-programming/page/n145) on STA
- snes9x implementation of STA: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1219](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1219)
- undisbeliever on STA: [https://undisbeliever.net/snesdev/65816-opcodes.html#sta-store-accumulator-to-memory](https://undisbeliever.net/snesdev/65816-opcodes.html#sta-store-accumulator-to-memory)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#STA](http://www.6502.org/tutorials/6502opcodes.html#STA)
