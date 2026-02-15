---
title: "DIV (SPC700)"
reference_url: https://sneslab.net/wiki/DIV_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Multiplication_and_Division_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T11:35:55-08:00
cleaned_at: 2026-02-14T17:51:51-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 1) 9E 1 byte 12 cycles

Flags Affected N V P B H I Z C N V . . H . Z .

**DIV** is an SPC700 instruction that divides the value in YA by the value in the X index register and stores the quotient in the accumulator and the remainder in the Y index register.

DIV is the slowest SPC700 opcode. To divide by a power of two, consider LSR instead.

#### Syntax

```
DIV
```

### See Also

- MUL
- DIV2
- ADC (SPC700)
- SBC (SPC700)

### External Links

- Official Super Nintendo development manual on DIV: Table C-13, [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L426](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L426)
- [https://helmet.kafuka.org/bboard/thread.php?id=228](https://helmet.kafuka.org/bboard/thread.php?id=228)
