---
title: "Super R-Type RAM Map"
reference_url: https://sneslab.net/wiki/Super_R-Type_RAM_Map
categories:
  - "RAM_Maps"
downloaded_at: 2026-02-14T16:55:55-08:00
cleaned_at: 2026-02-14T17:53:56-08:00
---

Address Size Type Description $7E:004C 2 bytes Flow If #$0080 is set, run the game, otherwise wait for NMI. $7E:004E 2 bytes Flow 16-bit frame counter, incremented every time the NMI runs. $7E:0050 2 bytes Flow 16-bit frame counter, incremented every time the game logic runs. $7E:0080 1 byte PPU $2100 register mirror $7E:0082 1 byte CPU $4200 register mirror, only written once because $4200 is always #$81 $7E:00F4 1 byte PPU Copy of PPU status flag, $213E $7E:0700 Unknown $7E:1580 Unknown $7E:1832 Unknown Seems to be a group related to BG 0 $7E:1836 2 bytes PPU BG 0 X position $7E:1838 2 bytes PPU BG 0 Y position $7E:1862 Unknown Seems to be a group related to BG 1 $7E:1866 2 bytes PPU BG 1 X position $7E:1868 2 bytes PPU BG 1 Y position $7E:1892 Unknown Seems to be a group related to BG 2 $7E:1896 2 bytes PPU BG 2 X position $7E:1898 2 bytes PPU BG 2 Y position $7E:1902 128 bytes Each entry has 8 bytes. $7E:2200 512 bytes OAM OAM table $7E:2400 32 bytes OAM OAM attribute table $7E:24A0 1024 bytes VRAM Unknown data that is transferred to VRAM $7E:2F60 512 bytes Palette CGRAM $7E:8000 32768 bytes Empty Unused data, initialized at reset. $7F:0000 65536 bytes Empty Unused data, not even initialized.
