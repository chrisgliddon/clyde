---
title: "Widescreen"
reference_url: https://sneslab.net/wiki/Widescreen
categories:
  - "Video"
downloaded_at: 2026-02-14T17:18:20-08:00
cleaned_at: 2026-02-14T17:55:21-08:00
---

## Screen

The currently studied aspect ratios for SNES widescreen are the following:

1. 16:9 widescreen. There's an additional 48 columns to the left and right side of the screen. Resolution is 352x224, stretched to simulate the 8:7 pixel aspect ratio.
2. 21:9 widescreen (actually 64:27). There's an additional 96 columns to the left and right side of the screen. Resolution is 448x224, stretched to simulate the 8:7 pixel aspect ratio.
3. 2:1 widescreen. There's an additional 64 columns to the left and right side of the screen. Resolution is 384x224, stretched to simulate the 8:7 pixel aspect ratio.

16:9 (352x224) and 21:9 (448x224) are the most important ones currently.

### Reference table

DAR (display aspect ratio) Numerical DAR SNES internal resolution Extras columns per side Numerical PAR (pixel aspect ratio) Notes 8:7 1.1428 256x224 0 1.0000 Most of the emulators doesn't apply pixel aspect ratio (leaves as 1:1). Keep this value as reference. 4:3 1.3333 256x224 0 1.1667 Real hardware reference. Certain TVs pixel aspect ratio are 1.1428 instead of 1.1667, due of signal interpretation differences. 16:10 1.6000 304x224 24 1.1789 Used to be common on some PC monitors, mostly replaced to 16:9. 16:9 1.7778 352x224 48 1.1313 Most common widescreen nowadays, being the recommended choice. 2:1 2.0000 384x224 64 1.1667 Some smartphones (marketed as 18:9) often uses this aspect ratio and calls it as ultrawide. The 21:9 version can be used keeping in mind a 1:1 PAR. 21:9 2.3703 448x224 96 1.1851 Commonly used on cinema and ultrawide monitors. "21:9" is a marketing term. The real aspect ratio is 64:27 (used by the HDMI standard) and it's used as reference for this table. 24:9 2.6667 512x224 128 1.1667 Maximum widescreen possible. Also known as 8:3. Horizontal scrolling is not really possible, NES-like methods would be needed.

### Comparison with 4:3 standard

The 256x224 SNES screen is not 4:3, but rather 8:7. CRT screens usually stretches the image by multiplying the internal screen width by 8/7 or 7/6, depending on the TV model. 8/7 seems to be more common, while 7/6 gives an perfect 4:3 output, since 8:7 (screen aspect ratio) * 7/6 (pixel aspect ratio) = 4/3 (actual aspect ratio), while 8:7 (screen aspect ratio) * 8/7 (pixel aspect ratio) = 64:49 (more like 4.0000:3.0625). Use the above reference table for clarification.

### Important note

All values consider the NTSC signal as reference. PAL equivalence calculations are not yet available.

## Objects

Since OAM sprite width is 9-bit wide, allowing values between -256 to +255, the internal range is adjusted in a manner the negative range also wraps positively. You can assume the values to range between -128 and +384, which are mapped that way: if unsigned position is greater than or equal to 384, subtract 512 from it. Else, keep value as is.

Sprites that already knows how to handle the left screen boundary (position -1 to -16) can be easily adapted to work with the widescreen range. Otherwise, it's recommended to port the relative screen position to use 16-bit values.

In addition, it doesn't break other emulators, since the additional visible area is implicitly invisible on the SNES hardware specification.

## Windowing

Assume that the windowing internal size is 512 lines long instead of 256 lines long. If you take the windowing calculations based from this perspective, windowing HDMA will work regardless of the aspect ratio being currently used (16:9, 21:9, etc.)

Given that a window is between 00:FF, this means that 00 would be -128 in equivalent absolute position, 80 would be +128 and FF would be +383.

Formula when default PPU is used: f(x) -&gt; x

Formula when widescreen is active: f(x) -&gt; 2\*x - 128

## Emulator

[https://github.com/DerKoun/bsnes-hd](https://github.com/DerKoun/bsnes-hd)

[https://www.reddit.com/r/emulation/comments/bmc9t9/bsneshd\_beta\_5\_bsnes\_1073\_formally\_hd\_mode\_7\_mod](https://www.reddit.com/r/emulation/comments/bmc9t9/bsneshd_beta_5_bsnes_1073_formally_hd_mode_7_mod)
