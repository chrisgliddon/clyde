---
title: "DAS (SPC700)"
reference_url: https://sneslab.net/wiki/DAS_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Decimal_Compensation_Commands"
downloaded_at: 2026-02-14T11:33:36-08:00
cleaned_at: 2026-02-14T17:51:41-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator BE 1 byte 3 cycles

Flags Affected N V P B H I Z C N . . . . . Z C

**DAS** (Decimal Adjust for Subtraction) is an SPC700 instruction that BCD-corrects a difference:

1. If either the carry flag is clear or the accumulator exceeds 0x99, subtract 0x60 from the accumulator and clear the carry flag. This corrects the tens column (but perhaps not completely).
2. Then, if either the half-carry flag is clear or the low nibble of the accumulator exceeds 0x09, subtract 0x06 from the accumulator. This corrects the ones column and possibly decrements the tens column by one. Subtracting six effectively maps $F to 9, $E to 8, etc. These hex digits $A to $F can appear in the difference when a borrow occurs.

Before DAS, the value in the accumulator is assumed to be encoded in binary/hexadecimal (with any value in the range $00 to $FF) because that is what the SBC command can output. But the inputs to SBC are supposed to be in BCD. After DAS, the value in the accumulator will be encoded in BCD once again where both nybbles are in the range 0-9. The SPC700 has no decimal mode, so that is why this command is important when working with decimal data.

#### Syntax

```
DAS
DAS A
```

### See Also

- DAA
- SED
- CLD

### External Links

- Official Super Nintendo development manual on DAS: Table C-14 in [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- [page 3-8-2 of Book I](https://archive.org/details/SNESDevManual/book1/page/n180), lbid
- ares source code, SPC700::instructionDecimalAdjustSub
- anomie: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L410](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L410)
