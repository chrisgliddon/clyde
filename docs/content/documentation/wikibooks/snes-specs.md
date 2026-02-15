---
title: "Super NES Programming/SNES Specs"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/SNES_Specs
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:17:55-08:00
---

## Technical specifications

- **Core**
- CPU: Nintendo custom '5A22', believed to be produced by Ricoh; based around a 16-bit CMD/GTE 65c816 (a licensed clone of Western Design Center's 65816). The CPU runs the 65c816-like core with a variable-speed bus, with bus access times determined by addresses accessed, with a maximum theoretical effective clock rate around 3.58 MHz. The SNES/SFC provided the CPU with 128 KB of Work RAM.

<!--THE END-->

- The CPU also contains other support hardware, including:
  
  - for interfacing with controller ports;
  - for generating NMI interrupts on Vertical blanking interval;
  - for generating IRQ interrupts on screen positions;
  - Direct memory access unit, supporting two primary modes, general DMA (for block transfers, at a rate of 2.68MB/second) and Horizontal blanking interval DMA (for transferring small data sets at the end of each scanline, outside of the active display period);
  - multiplication and division registers.

<!--THE END-->

- Cartridge Size Specifications: 2 - 32 Megabits (Mb) which ran at two speeds ('SlowROM' and 'FastROM'). Custom address decoders allow larger sizes, eg. 48 Mb for *Star Ocean* and *Tales of Phantasia*

<!--THE END-->

- **Sound**
  
  - Sound Controller Chip: 8-bit Sony SPC700 CPU (inspired by the 6502) for controlling the Digital signal processor running at an effective clock rate around 1.024 MHz.
  - Main Sound Chip: 8-channel Sony S-DSP with hardware ADPCM decompression, pitch modulation, echo effect with feedback (for reverberation) with 8-tap FIR filter, and ADSR and 'GAIN' (discretely controlled) volume envelopes.
  - Memory Cycle Time: 279 ms
  - Sound RAM: 512 kilobit(Kb) shared between SPC700 and S-DSP.
  - Pulse Code Modulator: 16-bit ADPCM (using 4-bit compressed ADPCM samples, expanded to 15-bit resolution, processed with an additional 4-point Gaussian sound interpolation).
  - Note - while not directly related to SNES hardware, the standard extension for SNES audio subsystem state files saved by emulators is SPC\_sound\_format(.spc), a format used by SPC players.

<!--THE END-->

- **Video**
  
  - Picture Processor Unit: 15-Bit
  - Video RAM: 64 KB of VRAM for screen maps (for 'background' layers) and tile sets (for backgrounds and objects); 512 + 32 bytes of 'OAM' (Object Attribute Memory) for objects; 512 bytes of 'CGRAM' for palette data.
  - Palette: 256 entries; 15-Bit color (BGR555) for a total of 32,768 colors.
  - Maximum colors per layer per scanline: 256.
  - Maximum colors on-screen: 32,768 (using color arithmetic for transparency effects).
  - Resolution: between 256x224 and 512x448. Most games used 256x224 pixels since higher resolutions caused slowdown, flicker, and/or had increased limitations on layers and colors (due to memory bandwidth constraints); the higher resolutions were used for less processor-intensive games, in-game menus, text, and high resolution images.
  - Maximum onscreen objects (sprites): 128 (32 per line, up to 34 8x8 tiles per line).
  - Maximum number of sprite pixels on one scanline: 256. The renderer was designed such that it would drop the *frontmost* sprites instead of the rearmost sprites if a scanline exceeded the limit, allowing for creative clipping effects.
  - Most common display modes: Pixel-to-pixel text mode 1 (16 colors per tile; 3 scrolling layers) and affine mapped text mode 7 (256 colors per tile; one rotating/scaling layer).
