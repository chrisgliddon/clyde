---
title: "FROM (Super FX)"
reference_url: https://sneslab.net/wiki/FROM_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Register_Prefix_Instructions"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T12:00:57-08:00
cleaned_at: 2026-02-14T17:51:56-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) Bn 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z . . . . . . .

**FROM** is a Super FX register prefix instruction that specifies the source register. The exception is when the B Flag is set (i.e. a WITH instruction is executed immediately before) in which case a MOVES is executed instead with FROM acting as the source and WTIH as the destination.\[1]

No flags are affected.

#### Syntax

```
FROM Rn
```

#### Example

To set R2 as the source register, run:

```
FROM R2
```

### See Also

- TO (Super FX)
- WITH (Super FX)
- MOVES (Super FX)

### Notes

\[1] The information in the developer manual is actually contradictory. The description of FROM claims the transfer happens from Rn (set by FROM) to Dreg (set by WITH) whereas that of MOVES Rn, Rn' claims to transfer from Rn' (set by WITH) to Rn (set by FROM) instead. According to fullsnes, it's the description of MOVES which is wrong.

### External Links

- Official Nintendo documentation on FROM: 9.34 on [page 2-9-48 of Book II](https://archive.org/details/SNESDevManual/book2/page/n204)
- Official Nintendo documentation on Register Prefixes: [page 2-6-7 of Book II](https://archive.org/details/SNESDevManual/book2/page/n129)
