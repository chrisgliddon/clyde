---
title: "Break Flag"
reference_url: https://sneslab.net/wiki/Break_Flag
categories:
  - "ASM"
  - "SPC700"
  - "Flags"
  - "Inherited_from_6502"
  - "Condition_Codes"
downloaded_at: 2026-02-14T11:14:18-08:00
cleaned_at: 2026-02-14T17:51:23-08:00
---

Note: This page may be confusing or inaccurate. See the talk page.

The **Break Flag** (B) is bit 4 of the S-SMP's program status word. It discerns between IRQs and BRK.

RETI and POP can modify the break flag.

In emulation mode the 65c816 has a break flag too.\[2] But in native mode it becomes the Index Register Select. PLP can affect the break flag.\[3]

BRK and PHP\[dubious] set the break flag. IRQs, NMIs, and reset clear it.\[1]

There are no dedicated SEB or CLB instructions to set/clear the break flag.

### See Also

- B Flag (Super FX)

### References

1. [https://problemkaputt.de/fullsnes.htm#cpuregistersandflags](https://problemkaputt.de/fullsnes.htm#cpuregistersandflags)
2. Eyes & Lichty, [page 422](https://archive.org/details/0893037893ProgrammingThe65816/page/422), Table 18.2. 65x Flags.
3. [page 486](https://archive.org/details/0893037893ProgrammingThe65816/page/486), lbid.
4. Fragment 18.1 on [page 436](https://archive.org/details/0893037893ProgrammingThe65816/page/436) on BRK, lbid.
5. Clark, Bruce. Register Preservation Using the Stack (and a BRK handler), [http://6502.org/tutorials/register\_preservation.html](http://6502.org/tutorials/register_preservation.html)
