---
title: "Super NES Programming/DMA tutorial"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/DMA_tutorial
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:16:39-08:00
---

# What is DMA, and why do we need it

One of the main limitations of the Super NES (apart from the slow memory access times) is the main processor. As already stated in the text on the [memory mapping page](/wiki/Super_NES_Programming/SNES_memory_map "Super NES Programming/SNES memory map"), this was mainly due to the fact that the CPU was supposed to be backward compatible, meaning that in the beginning the SNES was supposed to execute NES ROMs as well as SNES ROMs. For this, the CPU featured a so-called emulation mode.

The processor in the original Nintendo Entertainment System was a [Ricoh 2A03 (NTSC) or Ricoh 2A07 (PAL)](https://en.wikipedia.org/wiki/Ricoh_2A03), which was actually a toned-down [6502](https://en.wikipedia.org/wiki/MOS_Technology_6502). It lacked the binary-coded-decimal number support (which, for a time, was used for floating-point numbers until the [IEEE754](https://en.wikipedia.org/wiki/IEEE_floating_point) specification was published) of the 6502, but was otherwise compatible to the processor. The Super Nintendo Entertainment System was running on a [Ricoh 5A22](https://en.wikipedia.org/wiki/Ricoh_5A22), basically an enhanced version of the [65816](https://en.wikipedia.org/wiki/WDC_65816/65802). This CPU featured the already mentioned emulation mode, which would be able to execute games the same way the NES did. Also, the SNES used the same methods of addressing more memory than the native register size of the CPU (16 bit) suggested by basically using the same methods as with the older NES (bank switching). Note that these methods can be used also with running in emulation mode. Both the 2A03 and the 5A22 had very similar clock speeds:

Console Clock speed for NTSC version Clock speed for PAL version Memory NES 1.79 MHz 1.77 MHz 2048 Bytes (2 KB) SNES 3.58 MHz 3.55 MHz 131072 Bytes (128 KB)

Note that the PAL versions always tend to be a tiny bit slower, as NTSC renders 60 (interleaved half-)frames per second, while PAL only renders 50.

The reason why this page until now covered more about the CPU specifications than about direct access memory - which it will do very soon - is to illustrate the small CPU advantage the SNES had compared to the NES. The SNES had 64 times more memory than the NES, but only 2.5 times more CPU power.

One problem that can slow down a CPU significantly ([even in today's age](https://en.wikipedia.org/wiki/Von_Neumann_architecture#Von_Neumann_bottleneck)) is copying information (bytes) from device A to device B. The CPU is considered to be always faster than the memory it stores the current state in, and waiting for the memory controller to fetch/set the designated byte range can waste several clocks in which - if the CPU is not [out-of-order](https://en.wikipedia.org/wiki/Out-of-order_execution) [superscalar](https://en.wikipedia.org/wiki/Superscalar) - totally blocks the execution of the current program (that is, the game's ROM). Needless to say that the several Ricohs were never meant to be that particular sort of CPU.

Direct memory access is a method whereby memory is dynamically copied to another location independently of the CPU. In any modern computer, DMA is an essential requirement. Relating to the SNES, DMA can be used to quickly copy tile and palette data to the video RAM (also called VRAM), which would otherwise be copied by the slow CPU. Knowledge of DMA is a requirement for creating larger SNES programs, so this tutorial will cover just that.

DMA is used for copying graphics data, such as 8x8 tiles and tile maps, to the VRAM, and palette data to the CGRAM. These locations can only be accessed by reading or writing to certain hardware registers repeatedly (for more information see the [memory mapping](/wiki/Super_NES_Programming/SNES_memory_map "Super NES Programming/SNES memory map") and the [hardware registers](/wiki/Super_NES_Programming/SNES_Hardware_Registers "Super NES Programming/SNES Hardware Registers") page).

# DMA in detail

To understand the way DMA works, we will take a short look into how the SNES handles its memory.

The console basically has three buses which are connected with several devices within it. These three buses are:

1. **Bus A**: a 24-bit-wide address bus, which handles the communication between the CPU, the cartridge (ROM + SRAM), and the main memory (WRAM) - this is the main bus.
2. **Bus B**: an 8-bit-wide address bus, which may be used via special addresses in the main bus' address space (hardware registers) and which connects the APU (audio) and the PPUs (video) with it.
3. an 8-bit-wide data bus, which is controlled by both address buses for sending the data to various locations. This bus is blocked for the CPU whenever you issue one or more DMA processes.

Note that the data bus is really just one byte wide, while the CPU is supplied with various 16-bit registers. That means that one 16-bit register can never be written or read in one bus' cycle clock, but only in two.

The CPU of the SNES contains a DMA controller which supports 8 DMA channels in total. This means that 8 processes of copying chunks from one device to another may be set up and started simultaneously. Each channel can be specifically configured to behave in a certain manner. The channels execute their program, while being the first channel (index 0) with the highest and the eighth channel (index 7) with the lowest priority.

DMA controllers in common PCs can be configured to perform the task they are assigned to in a specific way, which is also called "mode". Also, PC DMA controllers can be used for various other devices, like for all devices connected to the system bus (ISA, PCI, AGP, PCIe).

The SNES supports only one mode, "burst", which basically means that the CPU will halt completely as long as there is at least one DMA process which is not finished yet. The reason for this is that for the transfer both the CPU and the DMA controller use the system bus to communicate with the other devices, but only one device (the master device) can use the system bus at the same time – either the CPU or the controller (more modern controllers offer the opportunity to transfer tiny chunks of data and then give the control of the system bus back to the CPU, immediately requesting the system bus again, so that the CPU may finish its pending operations and then return control of the bus to the controller – or not, if the CPU has to perform lots of memory accesses). Also, the SNES controller can only communicate with either the APU or the PPUs.

The registers of the controller are exposed through the hardware registers from $4200 to $4400 in the system banks $00 – $3F and $80 – $BF. There is a main register which upon writing into will start all DMA transfers it was set to start. Successive registers will contain information for each channel on what the channel is supposed to do, when activated.

# HDMA

While the normal DMA controller can copy the data it was programmed to only in "burst" mode, and this up to 64 KB (one entire bank), the SNES features another method to copy chunks to various devices, which is a little bit like PC DMA controllers work. This kind of DMA is called HDMA (Horizontal Direct Memory Access) and is executed only during H-blank (that is the time it takes for the beam laser to reset to the original position after drawing a line). Since this time span is very very small, only 1 to 4 bytes can be transfered during one H-blank.

# DMA registers

Note: **x** is the index of the channel (indexed by 0 to 7). So basically, 16 bytes of address space are reserved for each channel.

Address Description $420B The main DMA register. When writing a byte into it, the controller will activate the channels according to the bitmask of the byte. For example 73 (0100 1001) will activate channel 6, 3 and 0. $43**x**0 Specifies HOW the channel is supposed to perform the transfer, again using a bitmask (see below for more information). $43**x**1 DMA channel x destination($21xx) $43**x**2 DMA channel x source address offset(low) $43**x**3 DMA channel x source address offset(high) $43**x**4 DMA channel x source address bank $43**x**5 DMA channel x transfer size(low) $43**x**6 DMA channel x transfer size(high)

***NOTE**: This tutorial is incomplete and untested.*

NOTE: A DMA channel's transfer size, when set to #$0000, is read as a transfer of 65536 bytes, **not** 0 bytes.

# some code

## Loading Palettes

Here is a macro for loading a palette data into the CGRAM(the place where palettes are stored):

```
 ;macro for loading palette data into the CGRAM
 ;only use if SIZE is less than 256 bytes
 ;syntax SetPalette LABEL CGRAM_ADDRESS SIZE
 .macro SetPalette
 pha
 php
 
 rep	#$20		; 16bit A
 lda	#\3
 sta	$4305		; # of bytes to be copied
 lda	#\1		; offset of data into 4302, 4303
 sta	$4302
 sep	#$20		; 8bit A
 
 lda	#:\1		; bank address of data in memory(ROM)
 sta	$4304	
 lda	#\2
 sta	$2121		; address of CGRAM to start copying graphics to
 
 stz	$4300		; 0= 1 byte increment (not a word!)
 lda	#$22
 sta	$4301		; destination 21xx   this is 2122 (CGRAM Gate)
 
 lda	#$01		; turn on bit 1 (corresponds to channel 0) of DMA channel reg.
 sta	$420b		;   to enable transfer
 
 plp
 pla
 .endm
```

## Loading VRAM

Here is a macro for loading a data into the VRAM(the place where tiles and tile maps are stored):

```
 ;macro for loading graphics data into the VRAM
 ;only use if SIZE is less than 256 bytes
 ;syntax LoadVRAM LABEL  VRAM_ADDRESS  SIZE
 .macro LoadVRAM

 pha			; save the current accumulator, Y index and status registers for the time the function is executed.
 phy
 php
 
 rep	#$20		; set the accumulator (A) register into 16 bit mode
 sep	#$10		; set the index (X and Y) register into 8 bit mode

 ldy	#$80		;  we will try to write 128 ($80) bytes in one row ...
 sty	$2115		; ... and we will let the PPU let this know.

 lda	#\2		; the controller will get the hardware register ($2118) as location to where to write the data.
 sta	$2116		; but we still need to specify WHERE in VRAM we want to write the data - what we are doing right now.

 lda	#\3		; number of bytes to be sent from the controller.
 sta	$4305

 sep	#$20		; set the accumulator (A) register into 8 bit mode

 lda	#\1		; from where the data is supposed to be loaded from		
 sta	$4302
 
 ldy	#:\1		; from which bank the data is supposed to be loaded from
 sty	$4304

 ldy	#$01		; set the mode on how the channel is supposed to do it's work. 1= word increment
 sty	$4300

 ldy	#$18		; remember that I wrote "the controller will get the hardware register"? This is it. 2118 is the VRAM gate.
 sty	$4301
 
 ldy	#$01		; turn on bit 1 (channel 0) of DMA - that is, start rollin'
 sty	$420b
  
 plp			; Restore the state of all registers before leaving the function.
 ply
 pla
 .endm
```

# External Links

- [Information on the NES's CPU](https://en.wikipedia.org/wiki/Ricoh_2A03)
- [The base processor the 2A03 was built from](https://en.wikipedia.org/wiki/MOS_Technology_6502)
- [The (in)famous IEEE754 specification](https://en.wikipedia.org/wiki/IEEE_floating_point)
- [Informations on the SNES's CPU](https://en.wikipedia.org/wiki/Ricoh_5A22)
- [The base processor the 5A22 was built from](https://en.wikipedia.org/wiki/WDC_65816/65802)
- [The Von Neumann bottleneck, explained](https://en.wikipedia.org/wiki/Von_Neumann_architecture#Von_Neumann_bottleneck)
- [What out-of-order execution means and why it is a good thing ... sometimes](https://en.wikipedia.org/wiki/Out-of-order_execution)
- [How the CPU tries to execute one instruction for several parameters](https://en.wikipedia.org/wiki/Superscalar)

# See Also

- [SNES Memory Informations](/wiki/Super_NES_Programming/SNES_memory_map "Super NES Programming/SNES memory map")
- [SNES hardware registers](/wiki/Super_NES_Programming/SNES_Hardware_Registers "Super NES Programming/SNES Hardware Registers")
