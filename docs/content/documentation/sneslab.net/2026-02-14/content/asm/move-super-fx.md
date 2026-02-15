---
title: "MOVE (Super FX)"
reference_url: https://sneslab.net/wiki/MOVE_(Super_FX)
categories:
  - "ASM"
  - "Super_FX"
  - "Data_Transfer_Instructions"
  - "Macro_Instructions"
  - "Two-byte_Instructions"
downloaded_at: 2026-02-14T13:48:44-08:00
cleaned_at: 2026-02-14T17:52:25-08:00
---

Basic Info **Addressing Mode** **Opcode** **Length** **ROM Speed** **RAM Speed** **Cache Speed** 2n'1n 2 bytes 6 cycles 6 cycles 2 cycles

Flags Affected B ALT1 ALT2 O/V S CY Z 0 0 0 . . . .

**MOVE** is the name of a Super FX instruction and macro instructions that moves the value of a register or immediate value into another register or RAM.

The ALT0 state is restored.

#### Syntax

```
MOVE Rn, Rn'
MOVE Rn, #xx
MOVE Rn, (xx)
MOVE (xx), Rn
```

#### MOVE Rn, Rn'

MOVE Rn, Rn' as a GSU instruction transfers the value from Rn' to Rn. The opcode is strictly speaking an alterantive execution of TO, namely when the B flag is set i.e. a TO is executed immediately after a WITH. The register of WITH Rn' is the source and the register of TO Rn is the destination (for this reason, it is safe to assume that the transfer happens from Sreg to Dreg).

As such, the execution of both codes are identical:

```
; R0 = 52BAh
WITH R0
TO R13
; R13 also is now 52BAh

; R0 = 52BAh
WITH R13,R0
; R13 also is now 52BAh
```

#### Example 1

Let:

```
R14 = 4983h
R8 = 9264h
```

when MOVE R8, R14 is executed:

```
R8 = 4983h
```

#### Example 2

```
MOVE R8, #070h   ; 0070h -> R8  (IBT R8, #070h)
MOVE R8, #0A4h   ; 00a4h -> R8  (IWT R8, #0A4h)
MOVE R8, #-128   ; ff80h -> R8  (IBT R8, #-128)
```

### See Also

- B flag
- MOVES
- MOVEW
- MOVEB
- LM
- LMS
- IBT
- IWT
- MOV

### External Links

- Official Super Nintendo development manual on MOVE: 9.57 on [page 2-9-81 of Book II](https://archive.org/details/SNESDevManual/book2/page/n237)
- Official Super Nintendo development manual on TO: 9.57 on [page 2-9-48 of Book II](https://archive.org/details/SNESDevManual/book2/page/n277)
