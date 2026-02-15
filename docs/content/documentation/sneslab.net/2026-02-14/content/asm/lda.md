---
title: "LDA"
reference_url: https://sneslab.net/wiki/LDA
categories:
  - "Inherited_from_6502"
  - "Load/Store_Instructions"
downloaded_at: 2026-02-14T13:33:36-08:00
cleaned_at: 2026-02-14T17:52:13-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate A9 2/3 bytes 2 cycles* Absolute AD 3 bytes 4 cycles* Absolute Long AF 4 bytes 5 cycles* Direct Page A5 2 bytes 3 cycles* Direct Page Indirect B2 2 bytes 5 cycles* Direct Page Indirect Long A7 2 bytes 6 cycles* Absolute Indexed by X BD 3 bytes 4 cycles* Absolute Long Indexed by X BF 4 bytes 5 cycles* Absolute Indexed by Y B9 3 bytes 4 cycles* Direct Page Indexed by X B5 2 bytes 4 cycles* Direct Page Indexed Indirect by X A1 2 bytes 6 cycles* Direct Page Indirect Indexed by Y B1 2 bytes 5 cycles* Direct Page Indirect Long Indexed by Y B7 2 bytes 6 cycles* Stack Relative A3 2 bytes 4 cycles* Stack Relative Indirect Indexed by Y B3 2 bytes 7 cycles*

Flags Affected N V M X D I Z C N . . . . . Z .

**LDA** (LoaD Accumulator) is a 65x instruction that loads a value into the accumulator. In immediate addressing only, LDA is a total of 3 bytes long when the accumulator is 16 bits wide.

#### Syntax

```
LDA #const
LDA addr
LDA long
LDA dp
LDA (dp)
LDA [dp]
LDA addr, X
LDA long, X
LDA addr, Y
LDA dp, X
LDA (dp, X)
LDA (dp), Y
LDA [dp], Y
LDA sr, S
LDA (sr, S), Y
```

If you want to load zero into the accumulator, TDC may be a better choice, but only if the direct page register is zero.

#### Cycle Penalties

- In all addressing modes, LDA takes one extra cycle when the accumulator is 16 bits wide.
- In direct page addressing modes, LDA takes another extra cycle if the low byte of the direct page register is nonzero.
- In both the Absolute Indexed and the DP Indirect Indexed by Y admodes, LDA takes an extra cycle if adding the index crosses a page boundary.

### See Also

- STA
- LDX
- LDY

### External Links

- Eyes & Lichty, [page 462](https://archive.org/details/0893037893ProgrammingThe65816/page/462) on LDA
- Labiak, [page 149](https://archive.org/details/Programming_the_65816/page/n159) on LDA
- 2.1.1 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 4](https://archive.org/details/mos_microcomputers_programming_manual/page/n19) on LDA
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 263](https://archive.org/details/6502UsersManual/page/n276) on LDA
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-71](https://archive.org/details/6502-assembly-language-programming/page/n120) on LDA
- snes9x implementation of LDA: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L678](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L678)
- undisbeliever on LDA: [https://undisbeliever.net/snesdev/65816-opcodes.html#lda-load-accumulator-from-memory](https://undisbeliever.net/snesdev/65816-opcodes.html#lda-load-accumulator-from-memory)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#LDA](http://www.6502.org/tutorials/6502opcodes.html#LDA)
