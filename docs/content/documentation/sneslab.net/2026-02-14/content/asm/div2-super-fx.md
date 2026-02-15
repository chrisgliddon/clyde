---
title: "DIV2 (Super FX)"
reference_url: https://sneslab.net/wiki/DIV2_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Arithmetic_Operation_Instructions"
  - "Two-byte_Instructions"
  - "Expects_Sreg/Dreg_Prearranged"
downloaded_at: 2026-02-14T11:35:50-08:00
cleaned_at: 2026-02-14T17:51:52-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 3D96 2 bytes 6 cycles 6 cycles 2 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . S CY Z

**DIV2** (DIVide by 2) is a Super FX instruction that shifts the value of the source register's bits one place to the right while also leaving the most significant bit unchanged, storing the quotient in the destination register. The source register itself is left unchanged. Unlike ASR, the output becomes zero if the input is 0xFFFF.

The ALT0 state is restored.

The source and destination registers should be specified in advance using WITH, FROM, or TO. Otherwise, R0 serves as the default.

#### Syntax

```
DIV2
```

#### Example

Let:

```
Sreg : R7
Dreg : R2
R7 = 4635h (0100 0110 0011 0101b)
CY = 0
```

After executing DIV2:

```
R7 = 231Ah (0010 0011 0001 1010b)
CY = 1
```

### See Also

- ASL
- ASR
- LSR (Super FX)
- LSR (SPC700)
- LSR
- DIV (SPC700)
- ALT1

### External Links

- Official Nintendo documentation on DIV2: 9.32 on [page 2-9-44 of Book II](https://archive.org/details/SNESDevManual/book2/page/n200)
- example: [page 2-9-45](https://archive.org/details/SNESDevManual/book2/page/n201), lbid.
