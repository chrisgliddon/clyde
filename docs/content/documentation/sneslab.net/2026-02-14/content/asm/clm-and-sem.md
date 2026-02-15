---
title: "CLM and SEM"
reference_url: https://sneslab.net/wiki/CLM_and_SEM
categories:
  - "ASM"
  - "Non-Existant_Instructions"
downloaded_at: 2026-02-14T11:21:01-08:00
cleaned_at: 2026-02-14T17:51:32-08:00
---

The 65c816 has no **CLM** instruction to directly clear the m flag. Instead, use REP:

```
REP #$20
```

The 65c816 has no **SEM** instruction to directly set the m flag. Instead, use SEP:

```
SEP #$20
```
