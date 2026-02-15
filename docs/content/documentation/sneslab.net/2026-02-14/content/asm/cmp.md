---
title: "CMP"
reference_url: https://sneslab.net/wiki/CMP
categories:
  - "ASM"
  - "Group_One_Instructions"
  - "Inherited_from_6502"
  - "Compare_Instructions"
downloaded_at: 2026-02-14T11:22:34-08:00
cleaned_at: 2026-02-14T17:51:38-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate C9 2/3 bytes 2 cycles* Absolute CD 3 bytes 4 cycles* Absolute Long CF 4 bytes 5 cycles* Direct Page C5 2 bytes 3 cycles* Direct Page Indirect D2 2 bytes 5 cycles* Direct Page Indirect Long C7 2 bytes 6 cycles* Absolute Indexed by X DD 3 bytes 4 cycles* Absolute Long Indexed by X DF 4 bytes 5 cycles* Absolute Indexed by Y D9 3 bytes 4 cycles* Direct Page Indexed by X D5 2 bytes 4 cycles* Direct Page Indexed Indirect by X C1 2 bytes 6 cycles* Direct Page Indirect Indexed by Y D1 2 bytes 5 cycles* Direct Page Indirect Long Indexed by Y D7 2 bytes 6 cycles* Stack Relative C3 2 bytes 4 cycles* Stack Relative Indirect Indexed by Y D3 2 bytes 7 cycles*

Flags Affected N V M X D I Z C N . . . . . Z C

**CMP** (Compare) is a 65x instruction that compares the value of the accumulator to something. Internally, this is done via a subtraction, but the difference is discarded. Thus, the purpose of CMP is to setup the flags. The accumulator serves as the minuend and the operand serves as the subtrahend. For example, CMP #6 does "a minus 6" internally. CMP only does unsigned comparisons. In immediate addressing only, CMP is a total of 3 bytes long when the accumulator is 16 bits wide. Unlike SBC, the carry flag does not affect CMP.

If the subtraction required a borrow, the carry flag is cleared (otherwise it is set).

The decimal mode flag has no effect on the behavior of CMP.

#### Syntax

```
CMP #const
CMP addr
CMP long
CMP dp
CMP (dp)
CMP [dp]
CMP addr, X
CMP long, X
CMP addr, Y
CMP dp, X
CMP (dp, X)
CMP (dp), Y
CMP [dp], Y
CMP sr, S
CMP (sr, S), Y
```

CPA is an alternative mnemonic. The 65c816 datasheet mentions an alternative mnemonic "CMA" which might be an alias for "CMP #0".

#### Cycle Penalties

- In all addressing modes, CMP takes an extra cycle when the accumulator is 16 bits wide
- In direct page addressing modes, CMP takes an extra cycle when the low byte of the direct page register is nonzero
- In both Absolute Indexed and DP Indirect Indexed by Y, CMP takes an extra cycle if adding the index crosses a page boundary

### See Also

- CPX
- CPY
- CMP (Super FX)

### External Links

- Eyes & Lichty, [page 445](https://archive.org/details/0893037893ProgrammingThe65816/page/445) on CMP
- Labiak, [page 134](https://archive.org/details/Programming_the_65816/page/n144) on CMP
- 4.2.1 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 45](https://archive.org/details/mos_microcomputers_programming_manual/page/n60) on CMP
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 255](https://archive.org/details/6502UsersManual/page/n268) on CMP
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-56](https://archive.org/details/6502-assembly-language-programming/page/n105) on CMP
- snes9x implementation of CMP: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L304](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L304)
- undisbeliever on CMP: [https://undisbeliever.net/snesdev/65816-opcodes.html#cmp-compare-accumulator-with-memory](https://undisbeliever.net/snesdev/65816-opcodes.html#cmp-compare-accumulator-with-memory)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#CMP](http://www.6502.org/tutorials/6502opcodes.html#CMP)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.2](http://www.6502.org/tutorials/65c816opcodes.html#6.1.1.2)
