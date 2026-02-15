---
title: "Cache RAM"
reference_url: https://sneslab.net/wiki/Cache_RAM
categories:
  - "SNES_Hardware"
  - "Super_FX"
  - "Address_Spaces"
downloaded_at: 2026-02-14T11:26:30-08:00
cleaned_at: 2026-02-14T17:54:08-08:00
---

**Cache RAM** is a region of 512 bytes on the Super FX. Access to it is six times faster than [Game Pak ROM](/mw/index.php?title=Game_Pak_ROM&action=edit&redlink=1 "Game Pak ROM (page does not exist)") or [Game Pak RAM](/mw/index.php?title=Game_Pak_RAM&action=edit&redlink=1 "Game Pak RAM (page does not exist)").1 It is divided into 32 blocks, each block being 16 bytes.2

On the S-CPU, it is mapped to $xx:3100-$xx:32FF ($xx = $00-$3F, $80-$BF).3

### See Also

- CACHE
- LJMP (Super FX)

### References

1. [page 2-6-9 of Book II](https://archive.org/details/SNESDevManual/book2/page/n131) of the official Super Nintendo development manual
2. [page 2-6-10 of Book II](https://archive.org/details/SNESDevManual/book2/page/n132) of the official Super Nintendo development manual
3. Cache RAM Access From The Super NES. [page 2-6-12 of Book II](https://archive.org/details/SNESDevManual/book2/page/n133) of the official Super Nintendo development manual
4. Execution in Cache RAM. [page 2-6-1 of Book II](https://archive.org/details/SNESDevManual/book2/page/n123) of the official Super Nintendo development manual
