---
title: "LINK"
reference_url: https://sneslab.net/wiki/LINK
categories:
  - "ASM"
  - "Super_FX"
downloaded_at: 2026-02-14T13:34:59-08:00
cleaned_at: 2026-02-14T17:52:16-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Immediate 9n 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**LINK** is a Super FX instruction that stores the sum of R15 (program counter) and an immediate value (n) into R11. The operand n is the low nybble of the opcode and may be any integer from 1~4.

LINK can be used to store a return address into R11 when jumping to a subroutine.

The ALT0 state is restored.

#### Syntax

```
LINK #n
```

#### Example

Let:

```
R15 : 4368h
```

After executing the following program:

```
4368 LINK #4
4369 IWT R15, #74ffh
436C NOP
436B IBT R1, #12h
```

We have:

```
R11 = 4369h + 2 = 436bh
```

### See Also

- ADD (Super FX)
- ADC (Super FX)

### External Links

- Official Nintendo documentation on LINK: 9.48 on [Page 2-9-68 of Book II](https://archive.org/details/SNESDevManual/book2/page/n224)
