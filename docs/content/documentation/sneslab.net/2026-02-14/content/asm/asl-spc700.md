---
title: "ASL (SPC700)"
reference_url: https://sneslab.net/wiki/ASL_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Shift_Rotation_Commands"
downloaded_at: 2026-02-14T10:50:20-08:00
cleaned_at: 2026-02-14T17:51:08-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator 1C 1 byte 2 cycles Direct Page 0B 2 bytes 4 cycles Direct Page Indexed by X 1B 2 bytes 5 cycles Absolute 0C 3 bytes 5 cycles

Flags Affected N V P B H I Z C N . . . . . Z C

**ASL** (Arithmetic Shift Left) is an SPC700 instruction that shifts all 8 bits of its operand one bit to the left, more or less multiplying it by two. A zero is shifted into the least significant bit. The most significant bit is shifted into the carry flag.

#### Syntax

```
ASL A
ASL dp
ASL dp+x
ASL !abs
```

### See Also

- LSR (SPC700)
- ASL

### External Links

- Official Super Nintendo development manual on ASL: [Appendix C-7 of Book I](https://archive.org/details/SNESDevManual/book1/page/n232)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L335](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L335)
