---
title: "ld65 Linker Config Patterns"
weight: 40
---

## Our Working 128KB LoROM Config

From `projects/akalabeth/config/lorom128k.cfg`:

```
MEMORY {
    ZEROPAGE:   start = $60,    size = $A0,     type = rw, file = "";
    LORAM:      start = $0200,  size = $1E00,   type = rw, file = "";
    ROM0:       start = $8000,  size = $7FC0,   type = ro, file = %O, fill = yes, fillval = $00;
    ROMHDR:     start = $FFC0,  size = $40,     type = ro, file = %O, fill = yes, fillval = $00;
    ROM1:       start = $018000, size = $8000,  type = ro, file = %O, fill = yes, fillval = $00;
    SRAM:       start = $700000, size = $2000,  type = rw, file = "";
}

SEGMENTS {
    ZEROPAGE:   load = ZEROPAGE, type = zp;
    BSS:        load = LORAM,    type = bss;
    CODE:       load = ROM0,     type = ro;
    RODATA:     load = ROM0,     type = ro;
    HEADER:     load = ROMHDR,   type = ro;
    VECTORS:    load = ROMHDR,   type = ro,  start = $FFE0;
    AUDIODATA:  load = ROM1,     type = ro;
    SRAM_DATA:  load = SRAM,     type = bss;
}
```

## Memory Map Explained

**All `start` values are CPU addresses, not file offsets.**

### Zero Page ($60-$FF)

```
$00-$3F   Hardware / reserved (PPU, DMA, system)
$40-$5D   PPU shadow registers (our convention, from lib/macros.s)
$5E-$5F   Available
$60-$FF   General ZP variables (160 bytes)
```

Start at `$60` because `$00-$3F` is reserved for hardware-related state and `$40-$5D` is our PPU shadow area. The `type = zp` tells ld65 these are zero-page addresses.

### Low RAM ($0200-$1FFF)

```
$0000-$01FF   Stack + direct page (hardware)
$0200-$1FFF   BSS — 7.5 KB for game variables, buffers
```

### ROM Bank 0 ($8000-$FFFF)

```
$8000-$FFBF   CODE + RODATA (32,704 bytes)
$FFC0-$FFDF   ROM header (32 bytes)
$FFE0-$FFFF   Interrupt vectors (32 bytes)
```

In LoROM, each bank maps 32KB of ROM to `$8000-$FFFF`. Bank 0 = CPU addresses `$008000-$00FFFF`.

### ROM Bank 1 ($018000-$01FFFF)

Second 32KB bank. In our config, used for `AUDIODATA` (SPC driver binary).

### SRAM ($700000)

Battery-backed save RAM. LoROM maps SRAM at banks `$70-$7D`, starting at `$700000`.

## LoROM Bank Mapping

| Bank | CPU Range | ROM Offset | Size |
|------|-----------|-----------|------|
| 0 | `$008000-$00FFFF` | `$000000` | 32 KB |
| 1 | `$018000-$01FFFF` | `$008000` | 32 KB |
| 2 | `$028000-$02FFFF` | `$010000` | 32 KB |
| 3 | `$038000-$03FFFF` | `$018000` | 32 KB |

Banks 0-3 are also mirrored at banks `$80-$83` (with FastROM access if MEMSEL is set).

## Scaling to 256KB

Add ROM banks 2 and 3:

```
MEMORY {
    ZEROPAGE:   start = $60,      size = $A0,    type = rw, file = "";
    LORAM:      start = $0200,    size = $1E00,  type = rw, file = "";
    ROM0:       start = $8000,    size = $7FC0,  type = ro, file = %O, fill = yes, fillval = $00;
    ROMHDR:     start = $FFC0,    size = $40,    type = ro, file = %O, fill = yes, fillval = $00;
    ROM1:       start = $018000,  size = $8000,  type = ro, file = %O, fill = yes, fillval = $00;
    ROM2:       start = $028000,  size = $8000,  type = ro, file = %O, fill = yes, fillval = $00;
    ROM3:       start = $038000,  size = $8000,  type = ro, file = %O, fill = yes, fillval = $00;
    SRAM:       start = $700000,  size = $2000,  type = rw, file = "";
}
```

Add corresponding segments as needed (e.g., `GFXDATA`, `MAPDATA`). Update ROM header size byte accordingly.

## Scaling to 512KB

Banks 0-7 (8 × 32KB). Continue the pattern through `$078000`.

## SRAM Configuration

| Header Byte ($FFD8) | Size |
|---------------------|------|
| `$00` | No SRAM |
| `$01` | 2 KB ($800) |
| `$02` | 4 KB ($1000) |
| `$03` | 8 KB ($2000) — our default |
| `$05` | 32 KB ($8000) |

In the linker config, SRAM `size` must match. Our 8KB config:

```
SRAM: start = $700000, size = $2000, type = rw, file = "";
```

The `file = ""` means SRAM is not written to the output file (it's runtime-only).

## Common Segments

| Segment | Purpose | Memory | Notes |
|---------|---------|--------|-------|
| `ZEROPAGE` | Fast-access variables | Zero page | `.exportzp` / `.importzp` required |
| `BSS` | Uninitialized variables | Low RAM | `.res` only, no initial values |
| `CODE` | Executable code | ROM bank 0 | Primary code bank |
| `RODATA` | Constant data (tiles, tables) | ROM bank 0 | Shares space with CODE |
| `HEADER` | ROM header (title, checksums) | `$FFC0` | 32 bytes |
| `VECTORS` | Interrupt vectors | `$FFE0` | NMI, IRQ, Reset addresses |
| `AUDIODATA` | SPC driver binary | ROM bank 1+ | `.incbin` for BRR/driver data |
| `SRAM_DATA` | Save game variables | `$700000` | Battery-backed |

## Gotchas

- **ZP start at $60**: Below `$40` is hardware. `$40-$5F` is PPU shadows. Starting at `$00` or `$40` will collide.
- **CPU addresses, not file offsets**: `start = $8000` means CPU address `$8000`, not byte offset `$8000` in the ROM file.
- **ROM header at $FFC0**: The CPU address. The file offset is `$7FC0` (for bank 0, after subtracting the `$8000` base).
- **`fill = yes`**: Required for ROM banks. Without it, the linker won't pad to full bank size, breaking the binary layout.
- **VECTORS must be at $FFE0**: Use `start = $FFE0` in the segment definition. The header.inc template handles the vector table format.

## See Also

- `projects/akalabeth/config/lorom128k.cfg` — working config
- `lib/header.inc` — parameterized ROM header + vector table
- `lib/macros.s:186-207` — PPU shadow ZP addresses ($40-$5D)
