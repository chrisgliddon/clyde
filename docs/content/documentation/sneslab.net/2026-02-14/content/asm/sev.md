---
title: "SEV"
reference_url: https://sneslab.net/wiki/SEV
categories:
  - "ASM"
  - "Non-Existant_Instructions"
downloaded_at: 2026-02-14T16:22:08-08:00
cleaned_at: 2026-02-14T17:53:08-08:00
---

SEV (SEt Overflow) is a mnemonic for a non-existant 6502 instruction.

To set the overflow flag, consider using SEP or BIT. Like this:

```
SEP #$40
```

A common way is to use BIT on the address of a byte in ROM that has bit 6 set, like an RTS.\[1]

### See Also

- CLV
- SO

### External Links

1. Clark, Bruce. [http://www.6502.org/tutorials/vflag.html](http://www.6502.org/tutorials/vflag.html)
2. Eyes & Lichty, [page 263](https://archive.org/details/0893037893ProgrammingThe65816/page/263)
