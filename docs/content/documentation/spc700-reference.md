---
title: "Super NES Programming/SPC700 reference"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/SPC700_reference
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:18:05-08:00
---

# System Overview

The SPC700 is a Sony coprocessor that coordinates SNES audio. Once it is initialized with data and code sent from the SNES CPU, it manipulates the state of its accompanying digital signal processor (DSP), which produces the output audio.

## SPC700 Overview

The SPC700 has 64KB of memory for code and data. Within this memory are memory-mapped registers, used for communicating with the SNES CPU, the DSP, and three available timers.

The SPC700 has 6 registers:

- A - An 8-bit accumulator
- X & Y - 8-bit index registers
- SP - 8-bit stack pointer
- PC - 16-bit program counter
- PSW - 8-bit "Program Status Word", which stores the status flags

The Y and A registers can be paired together for some operations to form a 16-bit register with Y as the upper byte.

## DSP Overview

The DSP has eight channels, each of which can play a 16-bit sound. Each of the eight channels has separate left and right stereo volume, can be played at different pitches, and can have an Attack-Decay-Sustain-Release (ADSR) envelope applied to it. A white noise source can be set to replace the sampled data on any of the eight channels. Additionally, the DSP can apply an echo to the audio. The 16-bit audio samples are read from the SPC700's 64KB memory space, where they are stored in a packed 4-bit lossily-compressed format.

## SPC700 memory map

- `$0000` - `$00EF` - direct page 0
- `$00F0` - `$00FF` - memory-mapped hardware registers
- `$0100` - `$01FF` - direct page 1
- `$0100` - `$01FF` - potential stack memory
- `$FFC0` - `$FFFF` - IPL ROM

### Direct-page addressing

Many instructions offer an addressing mode that accesses 1-byte memory addresses in the "direct page". This addressing mode yields shorter bytecode which presumably executes faster. The direct page's upper byte is either `$00` or `$01`, corresponding to the P bit in the PSW register.

### The stack

The lower byte of the stack pointer is specified by the SP register; the upper byte is always `$01`. The stack pointer is set to `$01EF` on restart by the IPL ROM and grows downward.

### IPL ROM

On restart, the 64-byte chunk of memory at the end of the 64KB of RAM is initialized to the contents of the IPL ROM, which is where execution starts. The code in the IPL ROM sets the stack pointer to `$01EF`, zeroes the memory from `$0000` to `$00EF`, and then waits for data from the SNES via the input ports.

## SPC700 Registers

Address Description R/W `$00F0` Unknown ? `$00F1` Control W `$00F2` DSP Read/Write Address R/W `$00F3` DSP Read/Write Data R/W `$00F4` Port 0 R/W `$00F5` Port 1 R/W `$00F6` Port 2 R/W `$00F7` Port 3 R/W `$00FA` Timer Setting 0 W `$00FB` Timer Setting 1 W `$00FC` Timer Setting 2 W `$00FA` Timer Counter 0 R `$00FB` Timer Counter 1 R `$00FC` Timer Counter 2 R

### `$00F0` Unknown

Anomie has done some tests with this register. A document on romhacking.net describes it.

### `$00F1` Control

7 6 5 4 3 2 1 0 X X PC32 PC10 X ST2 ST1 ST0

- PC32 - Writing 1 in this bit will zero input for ports 2 and 3
- PC10 - Writing 1 in this bit will zero input for ports 1 and 0
- ST0-2 - These are for starting the timers.

```
 Warning: Writing to this register will always restart/stop all of the timers.
```

### `$00F2`/`$00F3` DSP Registers

Writing to `$00F2` sets the address of the DSP register to access. Writing to `$00F3` changes the value of the register pointed to. Reading from `$00F3` will return the value of the register pointed at. Writing a word to `$00F2` is allowed and it can be used to simultaneously set the address and write a value to the register.

### `$00F4`-`$00F7` Ports

Reading from these ports will give you the values that the SNES set at `$2140`-`$2143`. Values written to these registers will be viewable by the SNES using the same `$2140`-`$2143`. The input of these ports can be cleared using the Control register.

### `$00FA`-`$00FF` Timer Settings

Registers `$00FA`-`$00FC` are used to set the timer rate. Timers 0 & 1 have a resolution of 125 microseconds. Timer 2 has a finer resolution of ~15.6 microseconds. `$00FD`-`$00FF` are 4-bit registers containing the timer overflow count. Here is how the timers operate.

Each timer has an internal counter which is incremented at each clock input. If it equals the number in `$00FA`-`$00FC` (depending on which timer you're using) the corresponding counter register is incremented and the internal counter is reset. The counter registers (`$00FD`-`$00FF`) are 4-bit registers and can be read only. Reading from them will cause them to reset back to zero. If you don't read the counters in the limited time frame then they will overflow and be cleared to zero as well. The timer must be stopped before setting the `$00FA`-`$00FC` registers. To start a timer write to bits 0-2 of the Control register. To stop a timer, reset the bits. Take note that writing to the control register will restart the existing timers.

## DSP Compression Format

The DSP plays a special ADPCM encoded sound format. The sample is made up of a series of 9 byte compression blocks. Each block holds 16 4-bit samples and a 1 byte header. 16-bit samples will get a 9/32 compression ratio, but 8-bit samples must be inflated to 16-bit before compression (giving them only 9/16 compression ratio). The first byte of each block contains the header.

### Header

7 6 5 4 3 2 1 0 Range Filter Loop End

- Range - This is the shift value for the data. It can be 0-12.
- Filter - This selects the filter coefficients used in the decoding process. (see table below)
- Loop -This bit marks the block as one that will be within a loop. The exact function of this bit is unknown, but some commercial SPC samples that I have examined have this bit set for *all* blocks in the sample.
- End - This bit marks the block as the last block in the sample. The DSP channel will terminate or jump to the loop point if it reaches this block.

### Data

Each block contains 8 bytes of sample data (16 signed 4-bit samples). The higher nibble in each byte contains the sample that is to be decoded *before* the one in the lower nibble.

### Decoding Process

Here is an equation to estimate the 16-bit output of the DSP. Let y and z be the last two previously decoded samples. 'a' and 'b' are the filter coefficients selected by bits 2-3 of the header byte.

```
 sample = S + ay + bz
 S is the shifted data:
 S = (4-bit sample) << Range
```

The DSP performs this procedure using minimal basic shifting operations; output accuracy won't be perfect. It also applies Gaussian interpolation to the output.

### Filter Coefficients

Filter# a b 0 0 0 1 15/16 0 2 61/32 -15/16 3 115/64 -13/16

## Further reading

- [https://wiki.superfamicom.org/spc700-reference](https://wiki.superfamicom.org/spc700-reference)
- [https://www.romhacking.net/documents/197/](https://www.romhacking.net/documents/197/)
- [https://www.romhacking.net/documents/191/](https://www.romhacking.net/documents/191/)
