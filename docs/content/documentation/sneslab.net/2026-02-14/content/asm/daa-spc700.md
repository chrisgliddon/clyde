---
title: "DAA (SPC700)"
reference_url: https://sneslab.net/wiki/DAA_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Decimal_Compensation_Commands"
downloaded_at: 2026-02-14T11:33:10-08:00
cleaned_at: 2026-02-14T17:51:41-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator DF 1 byte 3 cycles

Flags Affected N V P B H I Z C N . . . . . Z C

**DAA** (Decimal Adjust for Addition) is an SPC700 instruction that BCD-corrects a sum:

1. If either the carry flag is set or the accumulator exceeds 0x99, add 0x60 to the accumulator and set the carry flag. This corrects the tens column (but perhaps not completely).
2. Then, if either the half-carry flag is set, or the lower nibble of the accumulator exceeds 0x09, add 0x06 to the accumulator. This corrects the ones column and possibly increments the tens column by one.

DAA assumes the value in the accumulator is encoded in binary/hexadecimal (with any value in the range $00 to $FF) because that is what the ADC command can output. But the inputs to ADC are supposed to be in BCD. After DAA, the accumulator value will be in BCD once again where both nybbles are in the range 0 to 9. The SPC700 has no decimal mode, so that is why this command is important when working with decimal data.

#### Syntax

```
DAA
DAA A
```

### See Also

- DAS
- SED
- CLD

### External Links

- Official Super Nintendo development manual on DAA: Table C-14 in [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- [page 3-8-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n180), lbid
- ares source code, SPC700::instructionDecimalAdjustAdd
- anomie: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L409](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L409)
- [http://www.righto.com/2023/01/understanding-x86s-decimal-adjust-after.html?m=1](http://www.righto.com/2023/01/understanding-x86s-decimal-adjust-after.html?m=1)
