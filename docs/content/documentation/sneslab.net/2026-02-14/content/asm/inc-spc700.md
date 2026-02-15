---
title: "INC (SPC700)"
reference_url: https://sneslab.net/wiki/INC_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Addition_and_Subtraction_Commands"
downloaded_at: 2026-02-14T13:22:45-08:00
cleaned_at: 2026-02-14T17:52:04-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator BC 1 byte 2 cycles Direct Page AB 2 bytes 4 cycles Direct Page Indexed by X BB 2 bytes 5 cycles Absolute AC 3 bytes 5 cycles Implied (type 1) 3D 1 byte 2 cycles Implied (type 1) FC 1 byte 2 cycles

Flags Affected N V P B H I Z C N . . . . . Z .

**INC** is an SPC700 instruction that increments its operand by one.

#### Syntax

```
INC A
INC dp
INC dp+X
INC !abs
INC X
INC Y
```

The above are official, but some people prefer alternate mnemonics like:

```
INA
INX
INY
```

### See Also

- INC
- DEC (SPC700)
- INX
- INY
- ADC (SPC700)
- ADC

### External Links

- Official Super Nintendo development manual on INC: [Appendix C-7 of Book I](https://archive.org/details/SNESDevManual/book1/page/n232)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L445](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L445)
