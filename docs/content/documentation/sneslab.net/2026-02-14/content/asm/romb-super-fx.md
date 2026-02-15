---
title: "ROMB (Super FX)"
reference_url: https://sneslab.net/wiki/ROMB_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Bank_Set-up_Instructions"
  - "Two-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T16:08:37-08:00
cleaned_at: 2026-02-14T17:52:56-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 3FDF 2 bytes 6 cycles 6 cycles 2 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**ROMB** is a Super FX instruction that moves the low byte of the source register into ROMBR.

The source register should be specified in advance using WITH or FROM. Otherwise, R0 serves as the default.

The ALT0 state is restored.

#### Syntax

```
ROMB
```

#### Example

Let:

```
Sreg : R5
R5 = 0046h
```

After executing ROMB, the ROMBR becomes 46h.

### See Also

- RAMB
- ALT3

### External Links

- Official Nintendo documentation on ROMB: 9.75 on [Page 2-9-104 of Book II](https://archive.org/details/SNESDevManual/book2/page/n260)
