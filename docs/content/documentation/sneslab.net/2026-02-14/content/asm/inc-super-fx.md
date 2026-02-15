---
title: "INC (Super FX)"
reference_url: https://sneslab.net/wiki/INC_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Arithmetic_Operation_Instructions"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T13:22:49-08:00
cleaned_at: 2026-02-14T17:52:04-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) Dn 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S . Z

**INC** is a Super FX instruction that increments a register by one. Any register from R0 to R14 can serve as the operand.

The ALT0 state is restored.

#### Syntax

```
INC Rn
```

#### Example

Let:

```
R12 = 65b1h
```

After executing INC R12:

```
R12 = 65b2h
```

### See Also

- DEC (Super FX)
- INC
- INC (SPC700)
- INX
- INY

### External Links

- Official Nintendo documentation on INC: 9.42 on [Page 2-9-61 of Book II](https://archive.org/details/SNESDevManual/book2/page/n217)
