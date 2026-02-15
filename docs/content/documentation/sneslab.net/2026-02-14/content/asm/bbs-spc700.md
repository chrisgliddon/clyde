---
title: "BBS (SPC700)"
reference_url: https://sneslab.net/wiki/BBS_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Branching_Commands"
downloaded_at: 2026-02-14T11:00:00-08:00
cleaned_at: 2026-02-14T17:51:11-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Direct Page Bit Relative 03 3 bytes when condition false: 5 cycles

when condition true: 7 cycles

Direct Page Bit Relative 23 3 bytes when condition false: 5 cycles

when condition true: 7 cycles

Direct Page Bit Relative 43 3 bytes when condition false: 5 cycles

when condition true: 7 cycles

Direct Page Bit Relative 63 3 bytes when condition false: 5 cycles

when condition true: 7 cycles

Direct Page Bit Relative 83 3 bytes when condition false: 5 cycles

when condition true: 7 cycles

Direct Page Bit Relative A3 3 bytes when condition false: 5 cycles

when condition true: 7 cycles

Direct Page Bit Relative C3 3 bytes when condition false: 5 cycles

when condition true: 7 cycles

Direct Page Bit Relative E3 3 bytes when condition false: 5 cycles

when condition true: 7 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**BBS** (Branch on Bit Set) is an SPC700 instruction that performs a branch when a bit in the direct page is set. The index to the direct page byte that bit lives in is the first operand byte. Which bit within that byte is a specified by the top 3 bits of the opcode. The target relative address to jump to is the second operand byte. In Nintendo's manual, the high nybble of the opcode is called x.

In assembly source, the two operands appear in the same order that they do in the instruction stream.

No flags are affected.

#### Syntax

```
BBS dp, bit, rel
```

### See Also

- BBC

### References

- Table C-15, [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233) of the official Super Nintendo development manual
- anomie: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L349](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L349)
