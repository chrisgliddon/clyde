---
title: "Background attribute registers"
reference_url: https://sneslab.net/wiki/Background_attribute_registers
categories:
  - "SNES_Hardware"
  - "Video"
  - "Registers"
downloaded_at: 2026-02-14T11:09:07-08:00
cleaned_at: 2026-02-14T17:54:07-08:00
---

The SNES has four **background attribute registers**, presumably one for each of the four backgrounds. Each of them is connected to a delay circuit that remembers its previous two values.

When a nametable is read, the four attribute bits (three for palette, one for priority) are stored in the corresponding background attribute register.

### References

- [https://board.zsnes.com/phpBB3/viewtopic.php?p=204966#p204966](https://board.zsnes.com/phpBB3/viewtopic.php?p=204966#p204966)
