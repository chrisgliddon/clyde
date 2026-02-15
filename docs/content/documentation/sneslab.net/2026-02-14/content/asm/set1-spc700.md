---
title: "SET1 (SPC700)"
reference_url: https://sneslab.net/wiki/SET1_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Bit_Operation_Commands"
  - "Read-Modify-Write_Instructions"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T16:21:37-08:00
cleaned_at: 2026-02-14T17:53:07-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Direct Page Bit 02 2 bytes 4 cycles Direct Page Bit 22 2 bytes 4 cycles Direct Page Bit 42 2 bytes 4 cycles Direct Page Bit 62 2 bytes 4 cycles Direct Page Bit 82 2 bytes 4 cycles Direct Page Bit A2 2 bytes 4 cycles Direct Page Bit C2 2 bytes 4 cycles Direct Page Bit E2 2 bytes 4 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**SET1** is an SPC700 command that sets a bit in a direct page byte. The byte following the opcode determines which byte. The most significant 3 bits of the opcode determines which bit within that byte. In Nintendo's manual, the high nybble of the opcode is called x and bit 4 of the opcode is always zero.

No flags are affected.

#### Syntax

```
SET1 dip. bit
```

### See Also

- CLR1
- TSET1
- SMB
- dip bit

### External Links

- Official Nintendo documentation on SET1: Table C-18 in [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234)
- subparagraph 8.2.3.1 of [page 3-8-8](https://archive.org/details/SNESDevManual/book1/page/n186), lbid.
- [Appendix C-1](https://archive.org/details/SNESDevManual/book1/page/n226)
- [http://www.ffviman.fr/switch-snes/sf-sound.html](http://www.ffviman.fr/switch-snes/sf-sound.html)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L572](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L572)
