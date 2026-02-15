---
title: "RAMB (Super FX)"
reference_url: https://sneslab.net/wiki/RAMB_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Bank_Set-up_Instructions"
  - "Two-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T16:04:03-08:00
cleaned_at: 2026-02-14T17:52:51-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 3EDF 2 bytes 6 cycles 6 cycles 2 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**RAMB** is a Super FX instruction that moves the low byte of the source register into RAMBR.

The source register should be specified in advance using WITH or FROM. Otherwise, R0 serves as the default.

The ALT0 state is restored.

#### Syntax

```
RAMB
```

#### Example

Let:

```
Sreg : R3
R3 = 0170h
```

After executing RAMB, the RAM bank register becomes 70h.

### See Also

- ROMB
- ALT2
- SMS
- SM

### External Links

- Official Nintendo documentation on RAMB: 9.73 on [Page 2-9-101 of Book II](https://archive.org/details/SNESDevManual/book2/page/n257)
