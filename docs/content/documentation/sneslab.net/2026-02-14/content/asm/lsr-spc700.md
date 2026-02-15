---
title: "LSR (SPC700)"
reference_url: https://sneslab.net/wiki/LSR_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Shift_Rotation_Commands"
downloaded_at: 2026-02-14T13:37:18-08:00
cleaned_at: 2026-02-14T17:52:21-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator 5C 1 byte 2 cycles Direct Page 4B 2 bytes 4 cycles Direct Page Indexed by X 5B 2 bytes 5 cycles Absolute 4C 3 bytes 5 cycles

Flags Affected N V P B H I Z C N . . . . . Z C

**LSR** (Logical Shift Right) is an SPC700 instruction that shifts all 8 bits of its operand one bit to the right, dividing it by two. The least significant bit is shifted into the carry flag. A zero is shifted into the most significant bit.

The official manual has the bit shift operators for LSR pointing the wrong way.

#### Syntax

```
LSR A
LSR dp
LSR dp+X
LSR !abs
```

LSR is a fast alternative to DIV when dividing by a power of two.

### See Also

- ASL (SPC700)
- LSR

### External Links

- Official Super Nintendo development manual on LSR: [Appendix C-7 of Book I](https://archive.org/details/SNESDevManual/book1/page/n232)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L457](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L457)
