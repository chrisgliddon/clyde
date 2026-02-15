---
title: "Direct Memory Access"
reference_url: https://sneslab.net/wiki/Direct_Memory_Access
categories:
  - "SNES_Hardware"
  - "ASM"
  - "DMA"
downloaded_at: 2026-02-14T11:46:28-08:00
cleaned_at: 2026-02-14T17:54:11-08:00
---

**DMA** is a hardware feature (standing for Direct Memory Access) that allows copying data from one place to another much faster than the CPU can do by itself. This allows you to make the most of your limited vblank time, letting you copy more graphics to VRAM in a single frame, among other uses.

On the SNES, DMA happens between a device on the A Bus (the cartridge ROM or SRAM, or SNES WRAM) and the B Bus (anything in the $2100-$21FF address range, most notably PPU registers.) It can do both copies and fills, and it can copy from the A bus to the B bus or from the B bus to the A bus. There is a limitation where the SNES cannot use its internal RAM as both the source and destination of a copy - for that your best option is going to be the MVN and MVP 65c816 Instructions.

DMA always happens at SlowROM speed (2.68MHz).\[1]

## DMA channels

The SNES has eight DMA "channels" which can each be configured independently from each other. Channels are more relevant for HDMA, and the important part here is that you just need to choose a channel that's not currently being used for HDMA, then configure it how you like, and initiate the copy.

The DMA channels have their registers in the $4300-$437F range, where $4300-$430f corresponds to the first channel, $4310-$431f corresponds to the second, and so on. Each channel has a configuration register, an A-bus address, a B-bus address, and a length. There are also some additional registers that are only relevant for HDMA.

## DMA channel configuration byte

```
76543210
|| ||+++- B-bus address offset pattern
|| ||     0: 0     1: 01    2: 00    3: 0011  4: 0123  5: 0101
|| ++---- DMA only: 0: increment; 1: fixed; 2: decrement
|+------- HDMA only: 1: indirect mode
+-------- Direction (0: read A-bus write B-bus; 1: read B-bus write A-bus)
```

"Increment", "Decrement" and "Fixed" determine what happens to the A-bus address after each byte copied. "Fixed" will cause it to stay the same, and that's how you do fills. The others will increase or decrease the address by one after each copy.

An important concept to note here is the "offset pattern" selection. You can, for example, configure the DMA to write to the B bus address, then the B bus address plus one, and alternate between those for every byte in the DMA copy. A good reason to want to do this is if you're copying something into VRAM, which has you write to both $2118 and $2119 in order to update a word of VRAM.

## Code example

Here's an example that uses DMA to copy a new column of tile data onto a background layer.

```
  .a16
  ; You must select the VRAM, CGRAM, etc. address yourself using the normal registers for that.
  lda ColumnUpdateAddress
  sta PPUADDR ; $2116
  ; Configure the DMA channel and select the B-bus address.
  ; In this case it will write alternating bytes to $2118 and $2119, which writes to VRAM.
  lda #(<PPUDATA << 8) | DMA_01 | DMA_FORWARD
  sta DMAMODE ; $4300
  ; Write the low 16-bits of the A-bus address.
  lda #ColumnUpdateBuffer
  sta DMAADDR ; $4302
  ; Write the number of bytes to copy. 32 rows * 2 bytes.
  lda #32*2
  sta DMALEN ; $4305

  ; 8-bit accumulator. All the registers after this point are 1 byte in size.
  sep #$20
  .a8
  ; Write the bank byte for the A-bus address.
  ; Bank zero is used because it has access to the first 8KB of RAM, and it can be conveniently written with STZ.
  stz DMAADDRBANK ; $4304

  ; Configure the PPU so that writes increase the address by 32 instead of 1.
  ; This corresponds to moving down one row in the background layer.
  lda #INC_DATAHI|VRAM_DOWN ; $80|$01
  sta PPUCTRL ; $2115

  ; Each of the bits corresponds to a channel.
  ; The least significant bit being set selects the first channel.
  ; You may set multiple bits, and the selected DMA channels will run in order from the first channel to the last.
  lda #%00000001
  sta COPYSTART  ; $420B

  ; Change the PPU back to incrementing the address by 1 on each write as usual.
  lda #INC_DATAHI ; $80
  sta PPUCTRL ; $2115
```

### See Also

- Block Move Addressing

### Reference

1. [https://forums.nesdev.org/viewtopic.php?t=9585](https://forums.nesdev.org/viewtopic.php?t=9585)
