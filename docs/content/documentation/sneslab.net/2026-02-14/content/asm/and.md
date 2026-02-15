---
title: "AND"
reference_url: https://sneslab.net/wiki/AND
categories:
  - "Inherited_from_6502"
downloaded_at: 2026-02-14T10:48:46-08:00
cleaned_at: 2026-02-14T17:51:06-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Immediate 29 2/3 bytes 2 cycles* Absolute 2D 3 bytes 4 cycles* Absolute Long 2F 4 bytes 5 cycles* Direct Page 25 2 bytes 3 cycles* Direct Page Indirect 32 2 bytes 5 cycles* Direct Page Indirect Long 27 2 bytes 6 cycles* Absolute Indexed by X 3D 3 bytes 4 cycles* Absolute Long Indexed by X 3F 4 bytes 5 cycles* Absolute Indexed by Y 39 3 bytes 4 cycles* Direct Page Indexed by X 35 2 bytes 4 cycles* Direct Page Indexed Indirect by X 21 2 bytes 6 cycles* Direct Page Indirect Indexed by Y 31 2 bytes 5 cycles* Direct Page Indirect Long Indexed by Y 37 2 bytes 6 cycles* Stack Relative 23 2 bytes 4 cycles* Stack Relative Indirect Indexed by Y 33 2 bytes 7 cycles*

Flags Affected N V M X D I Z C N . . . . . Z .

**AND** is a 65x instruction that performs a logical AND. The conjunction is stored in the accumulator. The size of the accumulator determines how much data is ANDed.

#### Syntax

```
AND #const
AND addr
AND long
AND dp
AND (dp)
AND [dp]
AND addr, X
AND long, X
AND addr, Y
AND dp, X
AND (dp, X)
AND (dp), Y
AND [dp], Y
AND sr, S
AND (sr, S), Y
```

#### Cycle Penalties

- In all addressing modes, AND takes one extra cycle when the accumulator is 16 bits wide.
- In direct page addressing modes only, AND takes an extra cycle if the low byte of the direct page register is nonzero.
- In both Absolute Indexed addressing modes and DP Indirect Indexed by Y admodes, AND takes an extra cycle if adding the index crosses a page boundary.

### See Also

- ORA
- EOR
- BIT
- AND (SPC700)
- AND (Super FX)

### External Links

- Eyes & Lichty, [page 425](https://archive.org/details/0893037893ProgrammingThe65816/page/425) on AND
- Labiak, [page 116](https://archive.org/details/Programming_the_65816/page/n126) on AND
- 2.2.4.1 on [MCS6500 Manual](/mw/index.php?title=MCS6500_Manual&action=edit&redlink=1 "MCS6500 Manual (page does not exist)"), [page 20](https://archive.org/details/mos_microcomputers_programming_manual/page/n35) on AND
- [B-3](https://archive.org/details/mos_microcomputers_programming_manual/page/n204), lbid.
- [Carr](/mw/index.php?title=Carr&action=edit&redlink=1 "Carr (page does not exist)"), [page 246](https://archive.org/details/6502UsersManual/page/n259) on AND
- [Leventhal](/mw/index.php?title=Leventhal&action=edit&redlink=1 "Leventhal (page does not exist)"), [page 3-40](https://archive.org/details/6502-assembly-language-programming/page/n89) on AND
- undisbeliever on AND: [https://undisbeliever.net/snesdev/65816-opcodes.html#and-and-accumulator-with-memory](https://undisbeliever.net/snesdev/65816-opcodes.html#and-and-accumulator-with-memory)
- Pickens, John. [http://www.6502.org/tutorials/6502opcodes.html#AND](http://www.6502.org/tutorials/6502opcodes.html#AND)
- Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.1.2.1](http://www.6502.org/tutorials/65c816opcodes.html#6.1.2.1)
