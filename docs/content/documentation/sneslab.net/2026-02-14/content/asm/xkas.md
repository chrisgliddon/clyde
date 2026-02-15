---
title: "xkas"
reference_url: https://sneslab.net/wiki/xkas
categories:
  - "ASM"
  - "Assemblers"
downloaded_at: 2026-02-14T17:45:17-08:00
cleaned_at: 2026-02-14T17:53:44-08:00
---

**xkas** (short for cross-knight assembler) is an assembler made for 65c816 ASM code made by Near/byuu. This ASM code can be run by the SNES, which makes it useful for hacking *Super Mario World*, as well as other SNES games. xkas also comes with a patching feature, which allows you to insert the code directly into a ROM with the org command, which designates the location the code will be inserted to.

### History

The version most widely used by hackers of *Super Mario World* (and other SNES games) is version 0.06, which was released on May 3rd, 2007. The most current version does not support many patches that have been made, and, as such, is not recommended for use. Even the creator of xkas himself has recommended that SNES hackers stick with xkas 0.06. (Though this does not necessarily mean he still recommends 0.06 today)

### Usage

xkas's usage is simple:

```
   Back up your rom.
   move xkas.exe, your rom, and the patch to the same folder.
       A better approach is to just add the xkas directory to your PATH environment variable. 
   open cmd.exe (command prompt) and navigate to that folder with the cd and ls commands.
   start xkas by typing: xkas.exe (patch name).asm (rom name).smc 
```

If nothing appears and you are prompted to enter a command again, patching was a success. This, however, only means the code was inserted properly, not that the code works. This is why back ups are important Branches of the xkas line

In addition to the original Xkas, which must be run through the command prompt, there have been several other versions of it made to make patching easier.

```
   Xkas GUI by Noobish Noobsicle: This is probably the most popular alternate version of Xkas. In the latest version, it can even find and set freespace for you. NOTE: DUE TO BUGS, USAGE IS NOT RECOMMENDED
   Xkas Simple
   A 99% xkas 0.06 compatible assembler (as well as disassembler) is a planned feature of RexIDE. The author of RexIDE believes creating a new assembler is a better choice than simply using xkas in RexIDE because xkas is hard to maintain and would be difficult to properly and completely integrate it into RexIDE.
   csxkas by Spel Werdz Rite: A version of xkas written in C# with GUI and command-line functionality.
   swrxkas by Spel Werdz Rite: Custom xkas that patches 4x faster than the original 
```

### Alternatives to xkas

```
   Asar, a 65c816 and SPC700 assembler by Alcaro; an intended replacement for xkas.
   xa, a 6502 and 65c816 cross-assembler by Cameron Kaiser. Includes the dxa disassembler as well.
```
