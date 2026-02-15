---
title: "TO (Super FX)"
reference_url: https://sneslab.net/wiki/TO_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Register_Prefix_Instructions"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T16:59:17-08:00
cleaned_at: 2026-02-14T17:53:29-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 1) 1n 1 byte 3 cycles 3 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z . . . . . . .

**TO** is a Super FX register prefix instruction that specifies the destination register. Any register from R0 to R15 can be specified. The exception is when the B Flag is set (i.e. a WITH instruction is executed immediately before) in which case a MOVE is executed instead with WITH acting as the source and TO as the destination.

No flags are affected.

#### Syntax

```
TO Rn
```

#### Example

Let:

```
R6 = 7106h
R3 = 0028h
```

After executing this program:

```
FROM R6
TO   R4
ADD  R3
```

We have:

```
R4 = 712eh
```

### See Also

- FROM (Super FX)
- WITH (Super FX)
- MOVE (Super FX)

### External Links

- Official Nintendo documentation on TO: 9.89 on [page 2-9-121 of Book II](https://archive.org/details/SNESDevManual/book2/page/n277)
- Official Nintendo documentation on Register Prefixes: [page 2-6-7 of Book II](https://archive.org/details/SNESDevManual/book2/page/n129)
