---
title: "Super NES Programming/Initialization Tutorial"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/Initialization_Tutorial
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:17:00-08:00
---

Color 00000000 11100000

In this tutorial we cover initializing the Super Nintendo and changing the background to a beautiful shade of green.

## Required Tools

- The [WLA-65816 Macro Assembler](http://www.villehelin.com/wla.html). There are the [binaries for Linux 32 bit](https://www.mediafire.com/file/kgmpa4zqqwunhi2/wla-dx-9.9-bin.tar.gz)
- A SNES emulator, such as [bsnes](http://byuu.org/bsnes/), [Zsnes](http://www.zsnes.com) or [Geiger's debugging version of Snes9x, for windows](https://www.romhacking.net/utilities/241/).
- An initialization routine and a header. The initialization routine is self-explanatory; it's a piece of code that clears/resets system values and sets the SNES up for use. The header contains assembler directives for WLA which do things like define the ROM's name, size, vectors, etc.

## The Tutorial

### Assembler directives

If you decide to put the init routine and the header in separate files, it will be necessary to tell the assembler to include them.

```
.include "Header.inc"
.include "Snes_Init.asm"
VBlank:    ; Needed to satisfy interrupt definition in "header.inc"
    RTI
```

This part can be skipped by putting the header and init code in your main file.

You can find the [ASM-code for the Snes\_Init.asm here on Wikibooks](/wiki/Super_NES_Programming/Initialization_Tutorial/Snes_Init "Super NES Programming/Initialization Tutorial/Snes Init"), and you can find [the header here.](/wiki/Super_NES_Programming/Initialization_Tutorial/header "Super NES Programming/Initialization Tutorial/header")

While not necessary to get this project to work correctly, it should be noted that in order for the VBlank subroutine to actually be called, you would need to enable NMI interrupts as below.

```
lda #$80     ; Set NMI enable bit
sta #$4200
```

### Starting the program

In the header file, the label "`Start`" is declared as the reset vector, so that is where the program shall begin executing:

```
Start:
```

### Initializing the SNES

Most demos reset the SNES to a known state. Since emulators probably start in a known state, it may be unnecessary to reset the state for an emulated ROM. Resetting the SNES, however, may be necessary for the demo to run on actual SNES hardware.

To reset the SNES, we set a number of hardware registers to zero and zero all the bytes in WRAM. Here, we use the initialization macro `Snes_Init` from the file "`Snes_Init.asm`" from the SNES Devkit, which does this for us:

```
    ; Initialize the SNES.
    Snes_Init
```

### Setting the background color

First, we set the accumulator to 8 bits, to modify single bytes of RAM. We do this by setting the appropriate bit in the CPU status register:

```
    sep     #$20        ; Set the A register to 8-bit.
```

#### Step 1: Force VBlank

The SNES refreshes its screen to match the signal output to the television, so knowing how the television updates its image can help you understand how certain special effects are performed in the SNES.

A television displays an image on the screen using an electron beam, which it sweeps across the screen from left to right, one horizontal line at a time from top to bottom. Additionally, television images are *interlaced*, meaning that the television alternates displaying a screenful of all the even-numbered scanlines with a screenful of all the odd-numbered scanlines; each screen of even- or odd-numbered scanlines is called a *field*. An NTSC television (as used in the U.S. and Japan) displays roughly 30 frames per second, while a PAL television (as used everywhere else) displays 25 frames per second. Thus, an NTSC television displays about 60 fields per second, while a PAL television displays 50 fields per second.

Between lines, when the electron beam is being moved from the right end of one scanline to the left beginning of the next scanline, the electron beam is turned off; this is called the *horizontal blank* or *HBlank*. Certain special effects -- like the perspective effects of the Final Fantasy VI airship -- can be performed on the SNES by changing graphics settings during HBlank.

Likewise, between fields, when the electron beam is being moved from the bottom of the screen to the top, the electron beam is turned off; this is called *vertical blank* or *VBlank*. If you update the screen while the electron beam is turned on, the results displayed to the user are unpredictable; they may shear or have other artifacts. Therefore, you want to make all your modifications to the screen during HBlank or VBlank. Since VBlank is much longer than HBlank and covers the whole screen, most updates should be done during VBlank. VBlank occurs once per field, or about 60 times per second on NTSC machines and 50 times per second on PAL machines.

There are two ways to ensure that your code executes during a VBlank:

- Wait for a VBlank non-maskable interrupt (**NMI**).
- Turn off the screen by setting the eighth bit of the Screen Display Register ($2100).

Here, we force VBlank by turning off the screen, using the following code:

```
    lda     #%10000000  ; Force VBlank by turning off the screen.
    sta     $2100
```

#### Step 2: Setting the Background Color

The SNES stores 16-bit colors in the following format:

- `High byte: 0bbbbbgg`
- `Low byte: gggrrrrr`

The color that we will use is `00000000 11100000` (0 blue, 7 green, 0 red) -- a dark green. We set the background color of the screen using the Color Data Register ($2122):

```
   lda     #%11100000  ; Load the low byte of the green color.
   sta     $2122
   lda     #%00000000  ; Load the high byte of the green color.
   sta     $2122
```

#### Step 3: Ending VBlank

We end the VBlank by turning the screen back on and setting the brightness to 15, again using the Screen Display Register ($2100):

```
   lda     #%00001111  ; End VBlank, setting brightness to 15 (100%).
   sta     $2100
```

### Ending the program

Unlike many computer programs, SNES programs aren't really designed to end. SNES games are intended to keep running until the user turns the system off or presses reset. In our case, though, the SNES has done all that we wanted it to do, and now we would like it to sit still and not change anything. We accomplish this with an infinite loop:

```
    ; Loop forever.
Forever:
    jmp Forever
```

If we didn't have this loop at the end, the SNES would start executing any code or data that happened to follow our program, which may make the SNES do something that we didn't intend.

Alternatively, we also could've used the "STP" command. This command stalls the SNES' CPU until the console is reset. The endless loop is a good practice, though, because eventually we'll need a main program loop, and that is what this will become.

## Assembling the ROM

Once we have our program in a file -- let's call it "`Greenspace.asm`" -- we want to assemble it into a ROM image, so that we can run it in an emulator. First, we execute the WLA 65816 assembler to turn the assembly file into an object file:

```
wla-65816 -o Greenspace.obj Greenspace.asm
```

This should create the object file "`Greenspace.obj`".

Then, we need to link the object file into a ROM. The WLA linker requires a link file that lists the files to be linked. We'll make one called "`Greenspace.link`" with the following contents:

```
[objects]
Greenspace.obj 
```

Then, all we need to do is to execute the WLA linker:

```
wlalink Greenspace.link Greenspace.smc
```

This should create the ROM image "`Greenspace.smc`", which we can then run in an emulator.

To make the compile and link steps easier to run repeatedly -- as we might want to do when alternating between editing and testing -- we can put the commands in a [shell script](https://en.wikipedia.org/wiki/en:Shell_script "w:en:Shell script"), "`Greenspace.bat`" in DOS/Windows, or "`Greenspace.sh`" for UNIX.

```
wla-65816 -o Greenspace.obj Greenspace.asm
wlalink Greenspace.link Greenspace.smc
```

If you use UNIX you need to add *#!/bin/bash* as the first line of the file. Under Windows, it's a good idea to add *@echo off* as the first line.

Alternatively, if you are on a UNIX-based platform, it is possible to create a makefile and use the [make](https://en.wikipedia.org/wiki/en:make_%28software%29 "w:en:make (software)") utility. To do this, create a file named "`makefile`".

```
Greenspace.smc: Greenspace.asm Greenspace.link
    wla-65816 -o Greenspace.obj Greenspace.asm
    wlalink Greenspace.link Greenspace.smc
```

After creating this file, simply use the "`make`" command, and "`Greenspace.smc`" will be created.

## Complete source code

```
 ; SNES Initialization Tutorial code
 ; This code is in the public domain.
 
 .include "Header.inc"
 .include "Snes_Init.asm"
 
 ; Needed to satisfy interrupt definition in "Header.inc".
 VBlank:
   RTI
 
 .bank 0
 .section "MainCode"
 
 Start:
     ; Initialize the SNES.
     Snes_Init
 
     ; Set the background color to green.
     sep     #$20        ; Set the A register to 8-bit.
     lda     #%10000000  ; Force VBlank by turning off the screen.
     sta     $2100
     lda     #%11100000  ; Load the low byte of the green color.
     sta     $2122
     lda     #%00000000  ; Load the high byte of the green color.
     sta     $2122
     lda     #%00001111  ; End VBlank, setting brightness to 15 (100%).
     sta     $2100
 
     ; Loop forever.
 Forever:
     jmp Forever
 
 .ends
```

Problems? Seeing default black? Tell us on [the discussion page](/wiki/Talk:Super_NES_Programming/Initialization_Tutorial "Talk:Super NES Programming/Initialization Tutorial").

## Generated ROM file

- [SnesInitializationROM.smc](http://jotaro.com/wikibooks/SnesInitializationROM.smc).
