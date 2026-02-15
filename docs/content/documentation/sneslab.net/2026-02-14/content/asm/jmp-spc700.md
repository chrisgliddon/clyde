---
title: "JMP (SPC700)"
reference_url: https://sneslab.net/wiki/JMP_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Branching_Commands"
  - "Three-byte_Instructions"
downloaded_at: 2026-02-14T13:30:26-08:00
cleaned_at: 2026-02-14T17:52:10-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute 5F 3 bytes 3 cycles Absolute Indexed by X 1F 3 bytes 6 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**JMP** is an SPC700 instruction that performs an unconditional branch.

With absolute addressing, the SPC jumps to the address specified in the two bytes following the 5F opcode.

With absolute indexed by X addressing, the SPC jumps to the effective address specified by the two bytes following the 1F opcode plus the value in the X index register.

No flags are affected.

#### Syntax

```
JMP !abs
JMP [!abs+X]
```

### See Also

- BRA (SPC700)
- BRA

### External Links

- Official Super Nintendo development manual on JMP: Table C-15, [Appendix C-8 of Book I](https://archive.org/details/SNESDevManual/book1/page/n233)
- anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L454](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L454)
