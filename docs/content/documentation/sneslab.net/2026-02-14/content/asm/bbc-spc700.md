---
title: "BBC (SPC700)"
reference_url: https://sneslab.net/wiki/BBC_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Branching_Commands"
downloaded_at: 2026-02-14T10:59:37-08:00
cleaned_at: 2026-02-14T17:51:11-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Direct Page Bit Relative 13 3 byte when condition is false: 5 cycles

when condition is true: 7 cycles

Direct Page Bit Relative 33 3 byte when condition is false: 5 cycles

when condition is true: 7 cycles

Direct Page Bit Relative 53 3 byte when condition is false: 5 cycles

when condition is true: 7 cycles

Direct Page Bit Relative 73 3 byte when condition is false: 5 cycles

when condition is true: 7 cycles

Direct Page Bit Relative 93 3 byte when condition is false: 5 cycles

when condition is true: 7 cycles

Direct Page Bit Relative B3 3 byte when condition is false: 5 cycles

when condition is true: 7 cycles

Direct Page Bit Relative D3 3 byte when condition is false: 5 cycles

when condition is true: 7 cycles

Direct Page Bit Relative F3 3 byte when condition is false: 5 cycles

when condition is true: 7 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**BBC** (Branch on Bit Clear) is an SPC700 instruction that performs a branch when a bit in the direct page is clear. The index to the direct page byte that bit lives in is the first operand byte. Which bit within that byte is specified by the top 3 bits of the opcode. The target relative address to jump to is the second operand byte. In Nintendo's manual, the high nybble of the opcode is called y.

In assembly source, the two operands appear in the same order that they do in the instruction stream.

No flags are affected.

#### Syntax

```
BBC dp, bit, rel
```

### See Also

- BBS
- BBR

### External Links

- Official Super Nintendo development manual on BBC: Table C-15 [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- anomie: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L340](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L340)
