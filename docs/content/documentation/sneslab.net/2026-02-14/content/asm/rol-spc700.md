---
title: "ROL (SPC700)"
reference_url: https://sneslab.net/wiki/ROL_(SPC700)
categories:
  - "Shift_Rotation_Commands"
downloaded_at: 2026-02-14T16:08:16-08:00
cleaned_at: 2026-02-14T17:52:54-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator 3C 1 byte 2 cycles Direct Page 2B 2 bytes 4 cycles Direct Page Indexed by X 3B 2 bytes 5 cycles Absolute 2C 3 bytes 5 cycles

Flags Affected N V P B H I Z C N . . . . . Z C

**ROL** is an SPC700 instruction that rotates every bit of its operand one bit to the left. The most significant bit is rotated into the carry flag. The old value of the carry flag is rotated into the least significant bit. A total of 9 bits are rotated.

#### Syntax

```
ROL A
ROL dp
ROL dp+X
ROL !abs
```

### See Also

- ROR (SPC700)
- ASL (SPC700)
- ROL
- ROL (Super FX)

### External Links

- Official Super Nintendo development manual on ROL: [Appendix C-7 of Book I](https://archive.org/details/SNESDevManual/book1/page/n232)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L549](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L549)
