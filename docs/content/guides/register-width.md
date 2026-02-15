---
title: "Register Width Cheat Sheet"
weight: 10
---

## Processor Status Flags

The 65816 has two flags that control register width:

| Flag | Bit | Controls | SEP sets (8-bit) | REP clears (16-bit) |
|------|-----|----------|-------------------|----------------------|
| **M** | 5 (`#$20`) | Accumulator (A) width | `sep #$20` | `rep #$20` |
| **X** | 4 (`#$10`) | Index (X, Y) width | `sep #$10` | `rep #$10` |

Both at once: `sep #$30` (all 8-bit), `rep #$30` (all 16-bit).

## Our Macros (lib/macros.s)

```asm
.macro SET_A8           ; sep #$20 + .a8
.macro SET_A16          ; rep #$20 + .a16
.macro SET_XY8          ; sep #$10 + .i8
.macro SET_XY16         ; rep #$10 + .i16
.macro SET_AXY16        ; rep #$30 + .a16 + .i16
.macro SET_AXY8         ; sep #$30 + .a8 + .i8
```

Each macro includes both the CPU instruction AND the ca65 assembler directive. Always use these — never raw `sep`/`rep` without matching `.a8`/`.i16` etc.

## ca65 Assembler Directives

ca65 tracks register width at **assembly time** to know how many bytes to emit for immediate operands:

| Directive | Effect |
|-----------|--------|
| `.a8` | A is 8-bit — `lda #$xx` = 2 bytes |
| `.a16` | A is 16-bit — `lda #$xxxx` = 3 bytes |
| `.i8` | X/Y are 8-bit — `ldx #$xx` = 2 bytes |
| `.i16` | X/Y are 16-bit — `ldx #$xxxx` = 3 bytes |

## Which Instructions Are Affected

**By M flag (accumulator width):**
- `lda #imm`, `adc #imm`, `sbc #imm`, `and #imm`, `ora #imm`, `eor #imm`, `cmp #imm`, `bit #imm`
- All memory operations through A (loads/stores transfer full A width)

**By X flag (index width):**
- `ldx #imm`, `ldy #imm`, `cpx #imm`, `cpy #imm`
- Index register transfers and comparisons

**Never affected (always 8-bit operand):**
- `sep #imm`, `rep #imm` — always 1-byte immediate
- `brk`, `cop` — 1-byte signature
- All branch instructions — 1-byte relative offset

## The Critical Gotcha

**`.i8`/`.i16` are FILE-SCOPED and LINEAR in ca65.** They carry across `.proc` boundaries.

```asm
.proc FuncA
    SET_AXY16           ; .i16 in effect
    ldx #$1234          ; assembles as 3 bytes ✓
    rts
.endproc

.proc FuncB             ; ca65 still thinks .i16!
    ldx #$00            ; assembles as 3 bytes (LDX #$0000)
    ; but if CPU is actually in 8-bit index mode,
    ; CPU reads 2 bytes, next byte becomes the NEXT OPCODE
    ; → instruction stream misaligned → total RAM corruption
    rts
.endproc
```

### What Happens When You Get It Wrong

1. ca65 emits wrong number of bytes for immediate operand
2. CPU reads different number of bytes than assembled
3. Every subsequent instruction is misaligned by 1 byte
4. CPU executes garbage → writes garbage to RAM
5. **Symptom**: ZP filled with repeating 4-byte pattern, PC at $0000-$00FF

### The Rule

**Every `.proc` that uses `ldx #imm` or `ldy #imm` MUST explicitly set register width at entry.**

```asm
.proc MyFunction
    SET_AXY8            ; ALWAYS declare width at entry
    ; ... safe to use ldx #imm, ldy #imm ...
    rts
.endproc
```

## Quick Reference: Common Patterns

| Pattern | Required Width | Macro |
|---------|---------------|-------|
| `lda #$80` / `sta INIDISP` | A=8-bit | `SET_A8` |
| `lda #$0000` / `sta $00,x` | A=16-bit | `SET_A16` or `SET_AXY16` |
| `ldx #$0000` (loop counter) | X=16-bit | `SET_XY16` or `SET_AXY16` |
| DMA register setup | A=8-bit | `SET_A8` |
| PPU shadow writes | A=8-bit | `SET_A8` |
| Function entry (safe default) | All=8-bit | `SET_AXY8` |

## See Also

- [65816 instructions]({{< ref "/documentation/sneslab.net/2026-02-14/content/asm/65c816-instructions" >}}) — full instruction set reference
- `lib/macros.s:11-41` — macro source
