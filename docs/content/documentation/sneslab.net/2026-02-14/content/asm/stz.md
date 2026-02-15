---
title: "STZ"
reference_url: https://sneslab.net/wiki/STZ
categories:
  - "ASM"
  - "65c02_additions"
  - "Load/Store_Instructions"
downloaded_at: 2026-02-14T16:40:25-08:00
cleaned_at: 2026-02-14T17:53:22-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Absolute 9C 3 bytes 4 cycles* Direct Page 64 2 bytes 3 cycles* Absolute Indexed by X 9E 3 bytes 5 cycles* Direct Page Indexed by X 74 2 bytes 4 cycles*

Flags Affected N V M X D I Z C . . . . . . . .

**STZ** (Store Zero) is a 65c816 instruction that zeros out memory. The size of the accumulator determines how many zero bytes are written.

STZ has the same effect as STA when the accumulator is zero. It was not available on the original NMOS 6502 and was probably added to the CMOS version in order to make code faster/smaller because zero is such a common value to store.

No flags are affected.

#### Syntax

```
STZ addr
STZ dp
STZ addr, X
STZ dp, X
```

#### Cycle Penalties

- STZ takes one additional cycle if the accumulator is 16 bits wide, in all addressing modes.
- In direct page addressing modes only, STZ takes another additional cycle if the low byte of the direct page register is nonzero.

### See Also

- STX
- STY

### External Links

- Eyes & Lichty, [page 507](https://archive.org/details/0893037893ProgrammingThe65816/page/507) on STZ
- "Storing Zero to Memory," [page 103](https://archive.org/details/0893037893ProgrammingThe65816/page/103), lbid.
- Labiak, [page 188](https://archive.org/details/Programming_the_65816/page/n198) on STZ
- snes9x implementation of STZ: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1317](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L1317)
- undisbeliever on STZ: [https://undisbeliever.net/snesdev/65816-opcodes.html#stz-store-zero-to-memory](https://undisbeliever.net/snesdev/65816-opcodes.html#stz-store-zero-to-memory)
