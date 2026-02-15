---
title: "IWT (Super FX)"
reference_url: https://sneslab.net/wiki/IWT_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Data_Transfer_Instructions"
  - "Three-byte_Instructions"
downloaded_at: 2026-02-14T13:25:09-08:00
cleaned_at: 2026-02-14T17:52:09-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Immediate Fnxxxx 3 bytes 9 cycles 9 cycles 3 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**IWT** (Immediate Word Transfer) is a Super FX instruction that loads two immediate bytes into a register. Any register from R0 to R15 may be specified.

The ALT0 state is restored.

#### Syntax

```
IWT Rn, #xx
```

#### Example

When:

```
IWT R0, #4583h
```

is executed:

```
R0 = 4583h
```

### Trivia

The official Super Nintendo development manual mispells the mnemonic as "ITW" in the opcode diagram.\[1] The low byte of the immediate value is loaded before the high byte.

### See Also

- IBT
- LDA
- LDX
- LDY
- LEA

### External Links

1. Official Nintendo documentation on IWT: 9.43 on [Page 2-9-62 of Book II](https://archive.org/details/SNESDevManual/book2/page/n218)
