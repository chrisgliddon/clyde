---
title: "IBT"
reference_url: https://sneslab.net/wiki/IBT
categories:
  - "ASM"
  - "Super_FX"
  - "GSU_Control_Instructions"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T13:21:49-08:00
cleaned_at: 2026-02-14T17:52:02-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** Immediate Anpp 2 bytes 6 cycles 6 cycles 2 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**IBT** (Immediate Byte Transfer) is a Super FX instruction that loads an immediate byte into the low byte of a specified general register. The register's upper eight bits will be sign-extended (copied) from bit 7, effectively loading a signed 8-bit value.

The ALT0 state is restored.

#### Syntax

```
IBT Rn, #pp
```

where pp may be from -128 to 127. Any of the 16 general registers can be specified.

#### Example

```
IBT R8, #4    ; 0004h -> R8
IBT R8, #-128 ; ff80h -> R8
IBT R8, #0A4h ; ffa4h -> R8
```

#### Trivia

The word "integer" is misspelled in the official manual page for IBT.

### See Also

- IWT
- LDA
- LDX
- LDY

### External Links

- Official Nintendo documentation on IBT: 9.41 on [Page 2-9-60 of Book II](https://archive.org/details/SNESDevManual/book2/page/n216)
