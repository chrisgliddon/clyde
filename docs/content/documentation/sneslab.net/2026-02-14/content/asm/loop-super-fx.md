---
title: "LOOP (Super FX)"
reference_url: https://sneslab.net/wiki/LOOP_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "One-byte_Instructions"
  - "Instructions_with_Delay_Slots"
downloaded_at: 2026-02-14T13:36:30-08:00
cleaned_at: 2026-02-14T17:52:20-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 3C 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S . Z

**LOOP** is a Super FX instruction that decrements R12 by one. If the zero flag is set afterwards, R15 is incremented. Otherwise, R13 is stored to R15.

The next instruction after LOOP is already loaded into the pipeline.

The sign flag is set if R12 is negative and cleared otherwise. The ALT0 state is restored.

#### Syntax

```
LOOP
```

#### Example

In this program:

```
00:8014 INC R7
00:8015 INC R6
00:8016 LOOP
00:8017 NOP
00:8018 ADD R4
```

- If R13 is 8014h and R12 is not 0001h, the program jumps to 00:8014h after the NOP.
- If R12 is 0001h, the program does not jump and control falls through to the ADD.

### External Links

- Official Nintendo documentation on LOOP: paragraph 9.54 on [page 2-9-77 of Book II](https://archive.org/details/SNESDevManual/book2/page/n233)
