---
title: "XCE"
reference_url: https://sneslab.net/wiki/XCE
categories:
  - "ASM"
  - "65c816_additions"
  - "Exchange_Instructions"
  - "One-byte_Instructions"
  - "Implied_Instructions"
  - "Two-cycle_Instructions"
  - "Single_Admode_Mnemonics"
downloaded_at: 2026-02-14T17:19:55-08:00
cleaned_at: 2026-02-14T17:53:43-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **Speed** Implied (type 2) FB 1 byte 2 cycles

Flags Affected mode switching into N V M X D I Z C E emulation . . B . . . E 1 native . . 1 1 . . . E 0

**XCE** is a 65c816 instruction that exchanges the values of the carry and emulation bits. It typically appears soon after the Reset Vector following a CLC, to switch the S-CPU into 65c816 native mode. The carry flag was chosen because:

- it is easy to set and clear (with SEC and CLC)
- it is used less frequently than the negative and zero flags
- it can be tested with BCC and BCS

#### Syntax

```
XCE
```

The low bytes of both index registers (X & Y) are unaffected by a mode change. The high byte B of the accumulator is also unaffected.\[1]

#### Examples

Switching to native mode:

```
CLC
XCE
```

Switching to emulation mode:

```
SEC
XCE
```

When switching to emulation mode to call existing 6502 code, it is recommended to clear the direct page register and point the stack pointer to page one.\[2]

It is generally believed that XCE does not use register renaming, but this is not proven.

### See Also

- XBA
- XCN
- SWAP

### External Links

1. Eyes & Lichty, [page 525](https://archive.org/details/0893037893ProgrammingThe65816/page/525) on XCE
2. lbid, [page 277](https://archive.org/details/0893037893ProgrammingThe65816/page/277)
3. "Exchanges" on [page 102](https://archive.org/details/0893037893ProgrammingThe65816/page/102), lbid
4. Labiak, [page 205](https://archive.org/details/Programming_the_65816/page/n215) on XCE
5. snes9x implementation of XCE: [https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2517](https://github.com/snes9xgit/snes9x/blob/master/cpuops.cpp#L2517)
6. undisbeliever on XCE: [https://undisbeliever.net/snesdev/65816-opcodes.html#xce-exchange-carry-and-emulation-bits](https://undisbeliever.net/snesdev/65816-opcodes.html#xce-exchange-carry-and-emulation-bits)
7. Clark, Bruce. [http://www.6502.org/tutorials/65c816opcodes.html#6.10.4](http://www.6502.org/tutorials/65c816opcodes.html#6.10.4)
