---
title: "NOT (Super FX)"
reference_url: https://sneslab.net/wiki/NOT_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Logical_Operation_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T15:41:37-08:00
cleaned_at: 2026-02-14T17:52:33-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 4F 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S . Z

**NOT** is a Super FX instruction that calculates the 1's complement of the source register and stores the inversion in the destination register.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
NOT
```

#### Example

Let:

```
Sreg : R9
Dreg : R13
R9 = b764h (1011 0111 0110 0100b)
```

After executing NOT:

```
R13 = 489bh (0100 1000 1001 1011b)
```

### See Also

- XOR (Super FX)
- OR (Super FX)
- EOR
- NOTC

### External Links

- Official Nintendo documentation on NOT: 9.69 on [Page 2-9-96 of Book II](https://archive.org/details/SNESDevManual/book2/page/n252)
