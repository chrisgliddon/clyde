---
title: "Super NES Programming/Pointers"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/Pointers
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:17:38-08:00
---

## Required Tools

- The [WLA-65816 Macro Assembler](http://www.villehelin.com/wla.html)
- A SNES [Emulator](/wiki/Super_NES_Programming/SNES_Emulators "Super NES Programming/SNES Emulators")
- An initialization routine and a header.

## Overview

Pointers are an important part of a game or ROM. In the Super Nintendo, these pointers are usually made up of various addresses organized in a specific order. Some examples of pointer tables may include, for example, the list of locations in a ROM of a game's levels, or pointers to where certain sections of code are. A pointer could be related to a file name; C:\\WINDOWS\\explorer.exe, for example, points to the file explorer.exe in the folder WINDOWS.

## Example

Say you have a game with three levels. You've inserted them into your ROM, but you need your game to be able to read the levels. This could be solved by using pointers to the three levels in a table, somewhat like this:

```
 .dl Level_1
 .dl Level_2
 .dl Level_3
```

This table would now contain the addresses in the ROM of level 1, level 2, and level 3. The game could then read from this table and know where to look for those level files.

## db/dw/dl

.dl, .dw, and .db are three assembler directives for WLA-65816. This means that they tell the assembler to do something, in this case they tell it to create a byte, two bytes, or three bytes that together make up an address. .db creates a one-byte number, .dw a two-byte number, and .dl a three-byte number. Note that although they are used for pointers in this tutorial, these three commands can also be used to hold absolute values.

## Accessing the table

In 65816 ASM, tables are relatively easy to access. If you are already familiar with A and X in the 65c816, then this next section should not be a problem for you.

```
             ; This code will read from a table of 3-byte entries.  Load X with the entry you wish to read, and
             ; the code will read that entry for you.
 LDA Table,X ; This is the important part.  Table here refers to a label, and ",X"  means "Plus the value of X".  So,
             ; A is loaded with the value at (The position of Table) + the value of X.
 JMP ETable  ; Jump past the table, otherwise the CPU will attempt to execute it as code, and easily crash.
 Table:      ; This allows the LDA above to find this table.
 .dw Pointer_1
 .dw Pointer_2
 .dw Pointer_3
 ETable:     ; End of the table.  This label is jumped to by JMP, making sure the 65c816 doesn't try to execute
             ; the data as code.
```

This code will take X, and then read from (Table + X) to get a value, and then store that to the Accumulator (A). Note that X would need to be doubled in order to read the correct entry. Having X be one would read from the second byte of the first entry and the first byte of the second entry, which is not the intended operation of the code.
