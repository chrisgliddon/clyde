---
title: "LEA"
reference_url: https://sneslab.net/wiki/LEA
categories:
  - "ASM"
  - "Super_FX"
  - "Three-byte_Instructions"
downloaded_at: 2026-02-14T13:34:44-08:00
cleaned_at: 2026-02-14T17:52:16-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Immediate Fnxxxx 3 bytes 9 cycles 9 cycles 3 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**LEA** is a Super FX official macro that loads two immediate bytes into a general register. It is an alias for IWT. It stands for "load effective address."\[2]

The ALT0 state is restored.

#### Syntax

```
LEA Rn, #xx
```

#### Example

After executing LEA R3, #4853h:

```
R3 = 4853h
```

### See Also

- LDA
- IBT

### External Links

- Official Nintendo documentation on LEA: 9.47 on [Page 2-9-67 of Book II](https://archive.org/details/SNESDevManual/book2/page/n223)
- Table 2-2-2 on page 2-2-8 of Book II, lbid.
