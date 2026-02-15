---
title: "DBNZ (SPC700)"
reference_url: https://sneslab.net/wiki/DBNZ_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Branching_Commands"
downloaded_at: 2026-02-14T11:34:01-08:00
cleaned_at: 2026-02-14T17:51:42-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Direct Page / Program Counter Relative 6E 3 bytes when condition is false: 5 cycles

when condition is true: 7 cycles

Implied (type 1) / Program Counter Relative FE 2 bytes when condition is false: 4 cycles

when condition is true: 6 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**DBNZ** (Decrement Branch Non-Zero) is an SPC700 instruction that decrements a direct page location or the Y index register and then jumps if that value is nonzero. The direct page index is the first operand and also the first byte immediately following the opcode. The relative branch offset is the second operand, the second byte following the opcode.\[3]

No flags are affected.

#### Syntax

```
DBNZ dp, rel
DBNZ Y, rel
```

Where rel is given in two's complement.

### See Also

- CBNE
- JNZ

### References

1. Official Super Nintendo development manual on DBNZ: Table C-15, [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
2. [anomie's SPC700 doc](https://www.romhacking.net/documents/197)
3. lbid, [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L270](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L270)
