---
title: "CBNE (SPC700)"
reference_url: https://sneslab.net/wiki/CBNE_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Branching_Commands"
downloaded_at: 2026-02-14T11:17:19-08:00
cleaned_at: 2026-02-14T17:51:31-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Direct Page / Program Counter Relative 2E 3 bytes when condition is false: 5 cycles

when condition is true: 7 cycles

Direct Page Indexed by X / Program Counter Relative DE 3 bytes when condition is false: 6 cycles

when condition is true: 8 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**CBNE** (Compare Branch Not Equal) is an SPC700 instruction that performs a comparison between the accumulator and a direct page value and then branches if they are not equal. The direct page index is the first operand and also the first byte immediately following the opcode, and the relative branch offset is the second operand, the second byte following the opcode.\[3]

No flags are affected.

#### Syntax

```
CBNE dp, rel
CBNE dp+X, rel
```

Where rel is given in two's complement.

### See Also

- DBNZ
- BNE (SPC700)

### External Links

1. Official Super Nintendo development manual on CBNE: Table C-15, [Appendix C-8 of book I](https://archive.org/details/SNESDevManual/book1/page/n233)
2. anomie: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L372](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L372)
3. lbid: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L270](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L270)
