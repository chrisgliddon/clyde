---
title: "Super NES Programming/Joypad Input"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/Joypad_Input
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:17:20-08:00
---

Joypads are the SNES' means of input from the user. There can be up to four connected to the system, and there's support for special controllers, too ([mouse](https://en.wikipedia.org/wiki/SNES_Mouse), [Super Scope](https://en.wikipedia.org/wiki/Super_Scope), etc).

***NOTE**: This tutorial is a work-in-progress. I'm still relatively new to the SNES, so please feel free to correct any errors in this document.*

# Joypad Registers

To start off, we'll list the registers that we're going to use:

*Size* *Address* *Official Name* *Description* Byte $4200 NMITIMEN Counter Enable Byte $4212 HVBJOY Status Register Word $4218 CNTRL1L & -H Joypad #1 Status Word $421a CNTRL2L & -H Joypad #2 Status Word $421c CNTRL3L & -H Joypad #3 Status Word $421e CNTRL4L & -H Joypad #4 Status Byte $4016 Joypad #1 Old-Style Status Byte $4017 Joypad #2 Old-Style Status

Now, let's look at them in a bit more depth:

**$4200 - *NMITIMEN* - Counter Enable** *n-vh---j*

This register is most likely a bit familiar to you. If you've done any prior SNES coding, you'll recognize that you've probably used this register to enable a VSync interrupt. For joypad input, we must make sure bit 0 ("j") is set. This tells the SNES that we will be polling the other joypad registers.

For reference, the n-vh---j bits which make up the rest of the byte we'll be loading in to register $4200 are as follows:

*Bit name* *Position* *Description* n 7 Enables/Disables NMI v 5 Enables/Disables an IRQ on a vertical trigger h 4 Enables/Disables an IRQ on a horizontal trigger j 0 The Joypad polling bit

**$4212 - *HVBJOY* - SNES Status Register** *vh-----j*

This register is used to see if certain data is ready to be polled from the SNES. In this case, we only care about bit 0 ("j"). If we poll $4212 and bit 0 is set, then we know that the other SNES joypad registers will contain relevant data. It's usually not so bad if this step is left out, though. In the algorithm I'll be showing later, this check is skipped, but this explanation still exists for completeness.

**$4218/9 through $421e/f - Joypad Status Registers** *hi:bystudlr lo:axlriiii*

These are 16-bit registers that return the button and/or type states for each joypad connected to the SNES. $4218 and $4219 contain joypad 1's data, and joypad 2, 3, and 4 follow. The bits are laid out like this:

**Bit(s)** **Description** *$4219/b/d/f* *(hi)* b B Button y Y Button s Select Button t Start Button u Up D-Pad Button d Down D-Pad Button l Left D-Pad Button r Right D-Pad Button *$4218/a/c/e* *(lo)* a A Button x X Button l L Button r R Button iiii Controller Type ID

Most of these are quite self-explanatory. If a corresponding button's bit is set, then that button is pressed. The only semi-confusing part of this is the mysterious "iiii" bits - these determine which kind of controller is connected to the port. Basically, if they read 0000, then it's a standard SNES controller. Otherwise, it's a custom controller type or corrupted data.

**$4016 and $4017 - Joypad 1 and 2 Old-Style Status**

For these, you'll notice I left out the specific bits of each register. Basically, these work just like reading states from NES. Because of this, I think it's redundant to include that information here, except that bit 0 of $4200 must be clear to do use them this way. These registers can still be useful, though. If you write 0 to $4016, then these two registers can be used to check if joypads 1 and 2 are connected. After writing the 0 (and you only need to write to $4016, not both), reading from the registers will return 0 if not connected, and something else if connected.

# Basic Joypad Read Algorithm

When you initialize:

```
.ENUM $80

	Joy1A	db	;B, Y, Select, Start, Up, Down, Left, Right
	Joy1B	db	;A, X, L, R, iiii-ID
.ENDE

	lda #%10000001	; Enable NMI and Auto Joypad read
	sta NMITIMEN   	; Interrupt Enable Flags
```

In your main game loop (or somewhere appropriate) without checks:

```
	lda CNTRL1L     ; $4218
	sta Joy1A
	lda CNTRL1H     ; $4219
	sta Joy1B
```

However, before reading from the Auto Joypad Read registers, the lowest bit of HVBJOY should be tested to be 0, as the reading process takes some time to finish.
