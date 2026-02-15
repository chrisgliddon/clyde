---
title: "CACHE (Super FX)"
reference_url: https://sneslab.net/wiki/CACHE_(Super_FX)
categories:
  - "Super_FX"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T11:16:41-08:00
cleaned_at: 2026-02-14T17:51:28-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Implied (type 2) 02 1 byte 3 or 4 cycles 3 or 4 cycles 1 cycle

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**CACHE** is a Super FX instruction that might reset all cache flags. If the cache base register is equal to R15 & 0fff0h, nothing happens. Otherwise, set the cache base register to R15 & 0fff0h and reset all cache flags.

The ALT0 state is restored.

#### Syntax

```
CACHE
```

### See Also

- Cache RAM

### External Links

- Official Nintendo documentation on CACHE: 9.27 on [page 2-9-38 of Book II](https://archive.org/details/SNESDevManual/book2/page/n194)
- cautions for 7.1.1 on [page 2-7-1 of Book II](https://archive.org/details/SNESDevManual/book2/page/n135)
