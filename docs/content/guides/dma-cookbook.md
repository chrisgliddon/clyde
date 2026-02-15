---
title: "DMA Cookbook"
weight: 20
---

## Register Summary

All examples use DMA channel 0. For other channels, add `$10 × channel` to each register address.

| Register | Address | Purpose |
|----------|---------|---------|
| `DMAP0` | `$4300` | Transfer mode |
| `BBAD0` | `$4301` | B-bus destination (PPU register low byte) |
| `A1T0L` | `$4302` | Source address low |
| `A1T0H` | `$4303` | Source address high |
| `A1B0` | `$4304` | Source bank |
| `DAS0L` | `$4305` | Transfer size low |
| `DAS0H` | `$4306` | Transfer size high |
| `MDMAEN` | `$420B` | DMA enable (bit 0 = channel 0) |

## Transfer Modes

| Mode | Constant | Pattern | Use Case |
|------|----------|---------|----------|
| `$00` | `DMA_1REG_1W` | Write to one register | CGRAM ($2122) |
| `$01` | `DMA_2REG_1W` | Alternate: reg, reg+1 | VRAM ($2118/$2119) |
| `$02` | `DMA_1REG_2W` | Write same register twice | OAM ($2104) |
| `$08` | `DMA_FIXED` | OR with above: don't increment source | Clear operations |

## Pattern 1: VRAM Upload (Tiles)

From `projects/akalabeth/src/gfx.s:31-55`. Mode `$01` writes alternating bytes to VMDATAL ($2118) and VMDATAH ($2119).

```asm
    SET_A8
    ; Set VRAM destination
    lda #$80
    sta VMAIN               ; Increment after high byte write
    stz VMADDL              ; VRAM word address low
    stz VMADDH              ; VRAM word address high (= $0000)

    ; Configure DMA
    lda #$01                ; Mode: 2-register, 1 write each
    sta DMAP0
    lda #$18                ; B-bus = VMDATAL ($2118)
    sta BBAD0
    lda #<SourceTiles
    sta A1T0L
    lda #>SourceTiles
    sta A1T0H
    lda #^SourceTiles
    sta A1B0
    lda #<TILES_SIZE
    sta DAS0L
    lda #>TILES_SIZE
    sta DAS0H
    lda #$01                ; Enable channel 0
    sta MDMAEN
```

**Key**: VMAIN = `$80` means "increment VRAM address after writing $2119 (high byte)". This is the standard setting for sequential tile/tilemap uploads.

## Pattern 2: CGRAM Upload (Palettes)

From `projects/akalabeth/src/gfx.s:57-74`. Mode `$00` writes sequential bytes to CGDATA ($2122).

```asm
    SET_A8
    stz CGADD               ; Start at palette index 0

    lda #$00                ; Mode: 1-register, 1 write
    sta DMAP0
    lda #$22                ; B-bus = CGDATA ($2122)
    sta BBAD0
    lda #<PaletteData
    sta A1T0L
    lda #>PaletteData
    sta A1T0H
    lda #^PaletteData
    sta A1B0
    lda #<PAL_SIZE
    sta DAS0L
    lda #>PAL_SIZE
    sta DAS0H
    lda #$01
    sta MDMAEN
```

**Note**: CGRAM address auto-increments. Each color = 2 bytes (15-bit BGR). Full palette = 256 colors × 2 = 512 bytes.

## Pattern 3: OAM Upload (Sprites)

Mode `$02` writes two consecutive bytes to the same register (OAMDATA $2104). OAM needs this because each write to $2104 alternates between low/high byte internally.

```asm
    SET_A8
    stz OAMADDL             ; OAM address = 0
    stz OAMADDH

    lda #$02                ; Mode: 1-register, 2 writes
    sta DMAP0
    lda #$04                ; B-bus = OAMDATA ($2104)
    sta BBAD0
    lda #<OamBuffer
    sta A1T0L
    lda #>OamBuffer
    sta A1T0H
    lda #^OamBuffer
    sta A1B0
    lda #$20                ; 544 bytes = $0220
    sta DAS0L
    lda #$02
    sta DAS0H
    lda #$01
    sta MDMAEN
```

**Total OAM size**: 512 bytes (main table) + 32 bytes (size/X-high) = 544 bytes ($0220).

## Pattern 4: Fixed-Source Clear

From `lib/init.s:126-175`. OR mode with `$08` (DMA_FIXED) to repeat the same source byte. Used to zero VRAM, OAM, and CGRAM during init.

### Clear VRAM (64KB)

```asm
    stz VMADDL              ; VRAM address = $0000
    stz VMADDH
    lda #$80
    sta VMAIN

    stz $0000               ; Zero byte at source address
    lda #$09                ; Fixed + 2-register ($08 | $01)
    sta DMAP0
    lda #$18                ; B-bus = VMDATAL
    sta BBAD0
    stz A1T0L               ; Source = $00:0000
    stz A1T0H
    stz A1B0
    stz DAS0L               ; Size = $0000 (wraps to 64KB = $10000)
    stz DAS0H
    lda #$01
    sta MDMAEN
```

### Clear OAM (544 bytes)

```asm
    stz OAMADDL
    stz OAMADDH
    lda #$08                ; Fixed + 1-register ($08 | $00)
    sta DMAP0
    lda #$04                ; B-bus = OAMDATA
    sta BBAD0
    ; source already set to $00:0000
    lda #$20                ; $0220 = 544 bytes
    sta DAS0L
    lda #$02
    sta DAS0H
    lda #$01
    sta MDMAEN
```

### Clear CGRAM (512 bytes)

```asm
    stz CGADD
    lda #$08                ; Fixed + 1-register
    sta DMAP0
    lda #$22                ; B-bus = CGDATA
    sta BBAD0
    ; source already set to $00:0000
    stz DAS0L               ; $0200 = 512 bytes
    lda #$02
    sta DAS0H
    lda #$01
    sta MDMAEN
```

**Trick**: Transfer size `$0000` means 65536 bytes (wraps). For VRAM clear, this fills all 64KB.

## Pattern 5: DMA Queue (NMI Flush)

From `lib/nmi.s:34-39, 122-157`. Game logic queues DMA transfers; NMI flushes them during VBlank.

### Queue Format

Each entry is 7 bytes, stored in BSS:

```
Offset  Field       Maps to
  +0    DMAP        → $4300
  +1    BBAD        → $4301
  +2    SrcL        → $4302
  +3    SrcH        → $4303
  +4    SrcBank     → $4304
  +5    SizeL       → $4305
  +6    SizeH       → $4306
```

```asm
; BSS declarations
DmaQueue:   .res 7 * 8      ; 8 entries max
DmaCount:   .res 1           ; Number of queued entries
```

### Queuing a Transfer (Game Code)

```asm
    ; Example: queue a tilemap upload
    SET_AXY8
    ldx DmaCount
    lda #$01                ; DMAP: 2-reg write (VRAM)
    sta DmaQueue+0,x
    lda #$18                ; BBAD: VMDATAL
    sta DmaQueue+1,x
    lda #<TilemapData
    sta DmaQueue+2,x
    lda #>TilemapData
    sta DmaQueue+3,x
    lda #^TilemapData
    sta DmaQueue+4,x
    lda #<TILEMAP_SIZE
    sta DmaQueue+5,x
    lda #>TILEMAP_SIZE
    sta DmaQueue+6,x
    inc DmaCount
```

**Important**: Set VMAIN and VMADDL/H before queueing, or add them to your queue format. Our NMI doesn't set VRAM address — the caller must set it before the queue is flushed (or set it in force blank before enabling display).

### NMI Flush Logic

```asm
; Inside NmiHandler (lib/nmi.s:122-157)
    lda DmaCount
    beq @no_dma

    SET_XY16
    ldx #$0000
@dma_loop:
    SET_A8
    lda DmaQueue+0,x       ; Copy 7 bytes to DMA channel 0 registers
    sta DMAP0
    lda DmaQueue+1,x
    sta BBAD0
    ; ... (source addr, bank, size) ...
    lda #$01
    sta MDMAEN              ; Fire DMA

    txa                     ; Advance X by 7
    clc
    adc #7
    tax
    dec DmaCount
    bne @dma_loop
```

## Timing Constraints

- DMA transfers **pause the CPU** for the duration of the transfer
- VBlank is ~2273 master cycles on NTSC (~1 scanline = 1364 cycles)
- VBlank window: ~224 scanlines × 0 + ~38 scanlines of VBlank ≈ 13,500 CPU cycles
- **Rule of thumb**: ~6KB of DMA fits comfortably in VBlank. Full VRAM (64KB) requires force blank.

## See Also

- `lib/macros.s:130-156` — DMA register constants and mode constants
- `lib/init.s:126-175` — fixed-source clear patterns
- `lib/nmi.s:122-157` — DMA queue flush
- `projects/akalabeth/src/gfx.s:31-74` — VRAM + CGRAM upload patterns
