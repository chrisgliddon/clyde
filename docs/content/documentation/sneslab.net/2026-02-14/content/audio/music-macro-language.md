---
title: "Music Macro Language"
reference_url: https://sneslab.net/wiki/Music_Macro_Language
categories:
  - "Audio"
downloaded_at: 2026-02-14T15:37:20-08:00
cleaned_at: 2026-02-14T17:53:47-08:00
---

**Music Macro Language (MML)** is a method of transcribing musical notation as sequence data, which then gets processed into binary performance data, akin to [MIDI](https://en.wikipedia.org/wiki/MIDI), for a computer to playback. Most popularly, this syntax can be used to create [chiptune music](https://en.wikipedia.org/wiki/Chiptune).

## Syntax

MML has many variations, but the majority of those languages share a similar syntax.

Syntax Description `oX` Set octave for the rest of notes before the next `<`, `>` and `oX`.  
For example, `o6` will set the octave to 6.  
The range is depending on platform. `c`, `d`, `e`, `f`, `g`, `a`, `b` Play a note. Use `+` or `-` after the letter to specify a sharp or flat, respectively.  
A number should appear after the note; this number should denote the note's duration. 1 is a whole note, 2 is a half note, 4 a quarter note, 8 an eighth note, etc.  
If no duration is specified, then the duration will be the value specified by the `l` command. `r` Play a rest. Similar to a normal note, the number after it defines its length. `^` Play a tie (extending pervious note, rest or tie). Similar to a normal note, the number after it defines its length. `<`, `>` Decrease or increase octave by 1. The direction is depending on platform, but both of them should be opposite each other. `lXX` Defining the default length of a note when the length is not specified.  
For example, `l4` will set the default length to a quarter note. `@` Set instrument for a channel. The range is depending on platform. `v` Set channel volume. The range is depending on platform.

## Convert to MML

There are a handful of tools help you convert other sequence formats to MML:

- [PetiteMM](https://github.com/loveemu/petitemm), MIDI to MML command-line converter. [Java](https://www.java.com/en/download/) is required to use this tool.

## MML usage in SNES ROM hacking

There are a handful of tools known to incorporate MML syntax into editing the music for existing SNES games:

- [ZScream Magic](/mw/index.php?title=ZScream_Magic&action=edit&redlink=1 "ZScream Magic (page does not exist)"), for [The Legend of Zelda - A Link to the Past](/mw/index.php?title=The_Legend_of_Zelda_-_A_Link_to_the_Past&action=edit&redlink=1 "The Legend of Zelda - A Link to the Past (page does not exist)")
- AddMusicY, for Yoshi's Island
- AddMusic, for Super Mario World
- [LazyShell](/mw/index.php?title=LazyShell&action=edit&redlink=1 "LazyShell (page does not exist)"), for [Super Mario RPG](/mw/index.php?title=Super_Mario_RPG&action=edit&redlink=1 "Super Mario RPG (page does not exist)")

## See Also

- [I Compared Various MIDI to MML Programs (Japanese)](http://gocha.hatenablog.com/entry/2013/09/02/Midi2MML_Comparison)
