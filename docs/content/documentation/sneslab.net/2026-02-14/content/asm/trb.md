---
title: "TRB"
reference_url: https://sneslab.net/wiki/TRB
categories:
  - "ASM"
  - "Read-Modify-Write_Instructions"
  - "Test-and-Change-Bits_Instructions"
  - "65c02_additions"
downloaded_at: 2026-02-14T16:59:27-08:00
cleaned_at: 2026-02-14T17:53:30-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute 1C 3 bytes 6 cycles* Direct Page 14 2 bytes 5 cycles*

Flags Affected N V M X D I Z C . . . . . . Z .

**TRB** (Test and Reset Bits) is a 65c816 instruction that tests and resets bits using the accumulator. For each set bit in the accumulator, TRB clears the corresponding memory bit.

TRB performs a logical AND (conjunction) and the zero flag is set or cleared to reflect whether the conjunction is zero. The conjunction itself is discarded.

#### Syntax

```
TRB addr
TRB dp
```

#### Cycle Penalties

- In both addressing modes, TRB takes two extra cycles if the accumulator is 16 bits wide.
- In direct page addressing, TRB takes another extra cycle if the low byte of the direct page register is nonzero.

### See Also

- TSB
- BIT
- REP
- TCLR1

### External Links

- Eyes & Lichty, [page 513](https://archive.org/details/0893037893ProgrammingThe65816/page/513) on TRB
- Labiak, [page 194](https://archive.org/details/Programming_the_65816/page/n204) on TRB
- snes9x implementation of TRB: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1338](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1338)
- undisbeliever on TRB: [https://undisbeliever.net/snesdev/65816-opcodes.html#trb-test-and-reset-memory-bits-against-accumulator](https://undisbeliever.net/snesdev/65816-opcodes.html#trb-test-and-reset-memory-bits-against-accumulator)]
