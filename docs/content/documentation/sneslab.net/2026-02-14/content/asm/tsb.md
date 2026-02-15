---
title: "TSB"
reference_url: https://sneslab.net/wiki/TSB
categories:
  - "ASM"
  - "Read-Modify-Write_Instructions"
  - "Test-and-Change-Bits_Instructions"
  - "65c02_additions"
downloaded_at: 2026-02-14T16:59:43-08:00
cleaned_at: 2026-02-14T17:53:30-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute 0C 3 bytes 6 cycles* Direct Page 04 2 bytes 5 cycles*

Flags Affected N V M X D I Z C . . . . . . Z .

**TSB** (Test and Set Bits) is a 65c816 instruction that tests and sets bits using the accumulator. For each set bit of the accumulator, TSB sets the corresponding memory bit.

TSB performs a logical AND (conjunction) and the zero flag is set or cleared to reflect whether the conjunction is zero. The conjunction itself is discarded.

#### Syntax

```
TSB addr
TSB dp
```

#### Cycle Penalties

- TSB takes two extra cycles if the accumulator is 16 bits wide.
- In direct page addressing, TSB takes another extra cycle if the low byte of the direct page register is nonzero.

### See Also

- TRB
- BIT
- SEP
- TSET1

### External Links

- Eyes & Lichty, [page 514](https://archive.org/details/0893037893ProgrammingThe65816/page/514) on TSB
- Labiak, [page 195](https://archive.org/details/Programming_the_65816/page/n205) on TSB
- snes9x implementation of TSB: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1348](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1348)
- undisbeliever on TSB: [https://undisbeliever.net/snesdev/65816-opcodes.html#tsb-test-and-set-memory-bits-against-accumulator](https://undisbeliever.net/snesdev/65816-opcodes.html#tsb-test-and-set-memory-bits-against-accumulator)]
