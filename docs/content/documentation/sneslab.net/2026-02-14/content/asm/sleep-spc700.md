---
title: "SLEEP (SPC700)"
reference_url: https://sneslab.net/wiki/SLEEP_(SPC700)
categories:
  - "ASM"
  - "SPC700"
  - "Other_SPC700_Commands"
  - "One-byte_Instructions"
downloaded_at: 2026-02-14T16:24:17-08:00
cleaned_at: 2026-02-14T17:53:09-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 3) EF 1 byte 3 cycles

Flags Affected N V P B H I Z C . . . . . . . .

**SLEEP** is an SPC700 standby instruction. It hangs the S-SMP until reset.\[2] Nintendo does not want you to use this instruction.\[3]

EI and DI have no effect on the behavior of SLEEP.

No flags are affected.

#### Syntax

```
SLEEP
```

Perhaps SLEEP would have been more useful if the APU supported hardware interrupts.

### See Also

- NOP
- STOP (SPC700)
- WAI

### References

1. Official Super Nintendo development manual on SLEEP: Table C-20 in [Appendix C-10 of Book I](https://archive.org/details/SNESDevManual/book1/page/n235)
2. [https://problemkaputt.de/fullsnes.htm#snesapuspc700cpujumpcontrolcommands](https://problemkaputt.de/fullsnes.htm#snesapuspc700cpujumpcontrolcommands)
3. [Appendix C-1](https://archive.org/details/SNESDevManual/book1/page/n226)
4. anomie: [https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L584](https://github.com/yupferris/TasmShiz/blob/master/spc700.txt#L584)
