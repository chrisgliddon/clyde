---
title: "COLOR (Super FX)"
reference_url: https://sneslab.net/wiki/COLOR_(Super_FX)
categories:
  - "Plot-related_Instructions"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T11:23:42-08:00
cleaned_at: 2026-02-14T17:51:39-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 4E 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**COLOR** is a Super FX instruction that loads the color register with the low byte of the source register.

The ALT0 state is restored.

#### Syntax

```
COLOR
```

#### Example

Let:

```
Sreg : R6
R6 = 9830h
```

After executing COLOR, the color reg becomes 30h.

### See Also

- PLOT
- RPIX
- LOB
- CMODE

### External Links

- Official Nintendo documentation on COLOR: 9.30 on [Page 2-9-42 of Book II](https://archive.org/details/SNESDevManual/book2/page/n198)
