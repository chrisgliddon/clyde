---
title: "CALL (SPC700)"
reference_url: https://sneslab.net/wiki/CALL_(SPC700)
categories:
  - "Three-byte_Instructions"
downloaded_at: 2026-02-14T11:16:49-08:00
cleaned_at: 2026-02-14T17:51:29-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute 3F 3 bytes 8 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**CALL** is an SPC700 instruction that calls a subroutine. The current program counter is pushed to the stack (high byte first, then low byte). Then the address following the opcode becomes the new value of the program counter.\[2]

No flags are affected.

#### Syntax

```
CALL !abs
```

### See Also

- TCALL
- PCALL
- RET
- JSR

### External Links

1. Official Nintendo documentation on CALL: Table C-16 in [Appendix C-9 of Book I](https://archive.org/details/SNESDevManual/book1/page/n234)
2. [anomie's spc700 doc](https://www.romhacking.net/documents/197)
