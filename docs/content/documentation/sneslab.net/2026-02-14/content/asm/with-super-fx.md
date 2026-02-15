---
title: "WITH (Super FX)"
reference_url: https://sneslab.net/wiki/WITH_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Register_Prefix_Instructions"
downloaded_at: 2026-02-14T17:17:21-08:00
cleaned_at: 2026-02-14T17:53:42-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 2n\[1] 1 byte 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 1 . . . . . .

**WITH** is an undocumented\[dubious] (WITH is mentioned on pages 2-2-8 and 2-6-7 of Book II the Nintendo documentation) Super FX instruction that sets the register specified by the operand as both the source register and destination register. It also sets the B flag which makes it a prefix instruction, more specifically for TO and FROM which act like MOVE and MOVES, respectively, with WITH carrying the source and the modified opcode the destination.

### Notes

\[1]The opcode lacks a dedicated description in the developer manual, this information comes from fullsnes instead. Furthermore, one can deduce that WITH is this opcode in that it's explicitely mentioned to be the first byte of the MOVE opcode which **is** documented in the manual.

### See Also

- TO (Super FX)
- FROM (Super FX)
- B Flag
- MOVE (Super FX)
- MOVES (Super FX)
- XOR (Super FX)

### References

- *Comprehensive Super FX ASM Guide*, part C (Basic operations): [https://www.smwcentral.net/?p=viewthread&t=81548](https://www.smwcentral.net/?p=viewthread&t=81548)
- Official Nintendo documentation on Register Prefixes: [page 2-6-7 of Book II](https://archive.org/details/SNESDevManual/book2/page/n129)
- fullsnes, SNES Cart GSU-n CPU JMP and Prefix Opcodes: [https://problemkaputt.de/fullsnes.txt](https://problemkaputt.de/fullsnes.txt)
