---
title: "ROR (SPC700)"
reference_url: https://sneslab.net/wiki/ROR_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Shift_Rotation_Commands"
downloaded_at: 2026-02-14T16:09:50-08:00
cleaned_at: 2026-02-14T17:52:56-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator 7C 1 byte 2 cycles Direct Page 6B 2 bytes 4 cycles Direct Page Indexed by X 7B 2 bytes 5 cycles Absolute 6C 3 bytes 5 cycles

Flags Affected N V P B H I Z C N . . . . . Z C

**ROR** is an SPC700 instruction that rotates every bit of its operand one bit to the right. The old value of the carry flag is rotated into the most significant bit. The least significant bit is rotated into the carry flag. A total of 9 bits are rotated.

The official manual has the bit shift operators for ROR pointing the wrong way.

#### Syntax

```
ROR A
ROR dp
ROR dp+X
ROR !abs
```

### See Also

- ROL (SPC700)
- LSR (SPC700)
- ROR
- ROR (Super FX)

### External Links

- Official Super Nintendo development manual on ROR: [Appendix C-7 of Book I](https://archive.org/details/SNESDevManual/book1/page/n232)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L554](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L554)
