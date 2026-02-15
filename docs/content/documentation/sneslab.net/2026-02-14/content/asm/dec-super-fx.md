---
title: "DEC (Super FX)"
reference_url: https://sneslab.net/wiki/DEC_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Arithmetic_Operation_Instructions"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T11:35:01-08:00
cleaned_at: 2026-02-14T17:51:43-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) En 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S . Z

**DEC** is a Super FX instruction that decrements a register by one. The register selected can be from R0 to R14.

The ALT0 state is restored.

#### Syntax

```
DEC Rn
```

#### Example

Let:

```
R9 = a3f7h
```

After executing DEC R9:

```
R9 = a3f6h
```

### See Also

- INC (Super FX)
- DEC
- DEC (SPC700)
- DEX
- DEY

### External Links

- Official Nintendo documentation on DEC: 9.31 on [page 2-9-43 of Book II](https://archive.org/details/SNESDevManual/book2/page/n199)
