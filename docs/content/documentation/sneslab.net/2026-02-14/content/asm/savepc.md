---
title: "savepc"
reference_url: https://sneslab.net/wiki/savepc
categories:
  - "ASM"
downloaded_at: 2026-02-14T17:41:09-08:00
cleaned_at: 2026-02-14T17:53:01-08:00
---

**savepc** (Save Program Counter) is an xkas directive that saves the program counter to a file.

### Syntax

```
savepc filename.xpc [, index]
```

The default index is zero. The address is saved at file offset index\*4.

### See Also

- loadpc
- warnpc
