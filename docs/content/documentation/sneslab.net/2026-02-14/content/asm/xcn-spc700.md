---
title: "XCN (SPC700)"
reference_url: https://sneslab.net/wiki/XCN_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Shift_Rotation_Commands"
downloaded_at: 2026-02-14T17:20:05-08:00
cleaned_at: 2026-02-14T17:53:44-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Accumulator 9F 1 byte 5 cycles

Flags Affected N V P B H I Z C N . . . . . Z .

**XCN** is an SPC700 instruction that swaps the high and low nibbles of the accumulator. Bits 0 to 3 become bits 4 to 7 and vice versa.

#### Syntax

```
XCN
XCN A
```

### See Also

- XBA
- XCE
- SWAP

### External Links

- Official Nintendo documentation on XCN: Table C-10 in [Appendix C-7 of Book I](https://archive.org/details/SNESDevManual/book1/page/n232)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L609](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L609)
