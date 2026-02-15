---
title: "CLX and SEX"
reference_url: https://sneslab.net/wiki/CLX_and_SEX
categories:
  - "ASM"
  - "Non-Existant_Instructions"
downloaded_at: 2026-02-14T11:22:02-08:00
cleaned_at: 2026-02-14T17:51:35-08:00
---

The 65c816 has no **CLX** instruction to directly clear the x flag. Instead, use REP.

The 65c816 has no SEX instruction either. The Super FX does, but it doesn't set any x flag.

```
SEP #$10
REP #$10
```

### See Also

- SEX (Super FX)
