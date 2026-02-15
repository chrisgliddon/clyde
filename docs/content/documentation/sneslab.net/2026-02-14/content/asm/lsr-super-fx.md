---
title: "LSR (Super FX)"
reference_url: https://sneslab.net/wiki/LSR_(Super_FX)
categories:
  - "Super_FX"
  - "Shift_Instructions"
  - "One-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T13:37:22-08:00
cleaned_at: 2026-02-14T17:52:21-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 03 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . 0 CY Z

**LSR** (Logical Shift Right) is a Super FX instruction that shifts all bits of the source register's value to the right one bit while shifting a zero into the most significant bit, storing the result in the destination register. Bit 0 is shifted into CY. The source register itself is left unchanged.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
LSR
```

#### Example

Let:

```
Sreg : R8
Dreg : R0
R8 = b53fh (1011 0101 0011 1111b)
```

After executing LSR:

```
R0 = 5a9fh (0101 1010 1001 1111b)
CY = 1
```

### See Also

- ASR
- DIV2
- LSR
- LSR (SPC700)
- ROR (Super FX)
- ROL (Super FX)
- ROR

### External Links

- Official Nintendo documentation on LSR: 9.55 on [page 2-9-78 of Book II](https://archive.org/details/SNESDevManual/book2/page/n234)
