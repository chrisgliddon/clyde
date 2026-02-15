---
title: "DEC (SPC700)"
reference_url: https://sneslab.net/wiki/DEC_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Addition_and_Subtraction_Commands"
downloaded_at: 2026-02-14T11:34:54-08:00
cleaned_at: 2026-02-14T17:51:42-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator 9C 1 byte 2 cycles Direct Page 8B 2 bytes 4 cycles Direct Page Indexed by X 9B 2 bytes 5 cycles Absolute 8C 3 bytes 5 cycles Implied (type 1) 1D 1 byte 2 cycles Implied (type 1) DC 1 byte 2 cycles

Flags Affected N V P B H I Z C N . . . . . Z .

**DEC** is an SPC700 instruction that decrements its operand by one.

#### Syntax

```
DEC A
DEC dp
DEC dp+X
DEC !abs
DEC X
DEC Y
```

The above are official, but some people prefer alternate mnemonics like:

```
DEA
DEX
DEY
```

### See Also

- DEC
- INC (SPC700)
- DEX
- DEY
- SBC (SPC700)
- SBC

### External Links

- Official Super Nintendo development manual on DEC: [Appendix C-7 of Book I](https://archive.org/details/SNESDevManual/book1/page/n232)
- anomie: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L415](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L415)
