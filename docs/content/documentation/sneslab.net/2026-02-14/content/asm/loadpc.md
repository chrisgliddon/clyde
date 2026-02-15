---
title: "loadpc"
reference_url: https://sneslab.net/wiki/loadpc
categories:
  - "ASM"
downloaded_at: 2026-02-14T17:36:39-08:00
cleaned_at: 2026-02-14T17:52:19-08:00
---

**loadpc** (Load Program Counter) is an xkas directive that loads a 24-bit address from a file into the program counter.

### Syntax

```
loadpc filename.xpc [, index]
```

The default index is zero. The address loaded is at file offset index\*4.

### See Also

- savepc
- warnpc
