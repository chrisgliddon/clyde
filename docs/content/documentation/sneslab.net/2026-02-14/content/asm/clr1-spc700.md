---
title: "CLR1 (SPC700)"
reference_url: https://sneslab.net/wiki/CLR1_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Bit_Operation_Commands"
  - "Read-Modify-Write_Instructions"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T11:21:17-08:00
cleaned_at: 2026-02-14T17:51:33-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Direct Page Bit 12 2 bytes 4 cycles Direct Page Bit 32 2 bytes 4 cycles Direct Page Bit 52 2 bytes 4 cycles Direct Page Bit 72 2 bytes 4 cycles Direct Page Bit 92 2 bytes 4 cycles Direct Page Bit B2 2 bytes 4 cycles Direct Page Bit D2 2 bytes 4 cycles Direct Page Bit F2 2 bytes 4 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**CLR1** is an SPC700 command that clears a bit in a direct page byte. The byte following the opcode determines which byte. The most significant 3 bits of the opcode determines which bit within that byte. In Nintendo's manual, the high nybble of the opcode is called y.

No flags are affected.

#### Syntax

```
CLR1 dip. bit
```

### See Also

- SET1
- TCLR1
- RMB
- dip bit

### External Links

- Official Nintendo documentation on CLR1: Table C-18 in [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234)
- subparagraph 8.2.3.1 of [page 3-8-8](https://archive.org/details/SNESDevManual/book1/page/n186), lbid.
- anomie: [https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L375](https://github.com/yupferris/TasmShiz/blob/8fabc9764c33a7ae2520a76d80ed7220bb939f12/spc700.txt#L375)
