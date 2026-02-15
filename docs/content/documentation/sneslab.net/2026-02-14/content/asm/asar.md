---
title: "Asar"
reference_url: https://sneslab.net/wiki/Asar
categories:
  - "ASM"
  - "Assemblers"
downloaded_at: 2026-02-14T10:57:58-08:00
cleaned_at: 2026-02-14T17:51:07-08:00
---

Asar (not asar) is a 65c816, SPC700, and Super FX assembler made by Alcaro. Asar is an intended replacement for xkas.

## Usage

Asar is more user-friendly than xkas. It can be run two ways:

- Double-click Asar.
  
  - You will be prompted for the name of the patch. Enter (or copy-paste) the path to a patch you want to apply.
  - You will be prompted for the name of your ROM. Enter (or copy-paste) the path to the ROM you want to apply the patch to.
- Run it from the command line, like xkas.
  
  - &gt;asar \[Path to patch] \[Path to ROM]

## Features

Asar has many features which make life easier.

- freecode and freedata automatically find freespace for you. The difference is that freedata prefers ROM areas where RAM mirrors don't exist, while freecode refuses to put anything there.
- autoclean automatically detects where a JSL, JML, or dl in a ROM points to and deletes its RATS tag when you re-apply a patch. This prevents freespace leaks.
- arch assembles for another architecture. Valid values are the following:
  
  - 65816 is the default, the one you want in most circumstances
  - spc700-raw assembles SPC700 code. Acts as you'd expect; org $0010 stores to PC 0x0010 in the "ROM". Don't mix it with 65816 code, it won't make sense.
  - spc700-inline also assembles SPC700 code. However, org is weirder here: It doesn't edit where it'll store the data; instead, it implements the standard upload system (16bit length, then location). It also adds a terminator at the end. If you're uploading an SPC engine, you can set the entry point with "startpos $1234". The location in the ROM is where the surrounding 65816 code tells it to be.
  - superfx assembles code for the Super FX chip.

## Additional Libraries

Asar comes with the following library:

- asar.dll; wrappers for C and C# are included with the library.

This library allows programmers to use Asar from their code without calling an external application.
