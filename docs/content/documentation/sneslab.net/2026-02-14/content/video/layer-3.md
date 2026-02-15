---
title: "Layer 3"
reference_url: https://sneslab.net/wiki/Layer_3
categories:
  - "Video"
  - "Backgrounds"
downloaded_at: 2026-02-14T13:38:49-08:00
cleaned_at: 2026-02-14T17:55:10-08:00
---

**Layer 3** is one of the Super NES's five hardware layers. It is 2bpp in Mode 0 and Mode 1. In other modes it serves Offset Change Mode.

In more complex games like the *Donkey Kong Country* series or *Super Mario World 2*, this layer was used for backgrounds or special effects. But in *Super Mario World 1*, this layer only controls some very simple things. The status bar, except for your reserve item, is also on this layer. Layer 3 is also used on the title screen, as well as the overworld to create the box that contains the level name and Mario's life count. Finally, the spotlight sprite and message boxes use the layer.

To use Layer 3, just simply click on the blue square with little fish and bubbles inside in Lunar Magic. Setting it to "Water, high and low tides" will cause a tidal effect that was only seen in Mondo in the original game. Setting it to "Water, low tide only" causes a more common effect that was first seen in *Yoshi's Island 4*. Either way, the water isn't actually displayed in LM, so you have to plan around it! The tides are best used with Dolphins, the Porcu-Puff, and the Cheep Cheep at sprite 18 (the one that skips like a stone).

In the Castle 1 tileset, using the "low tides only" option causes a different effect: when used with Sprite 89 (Layer 3 Smash) and Sprite F3 (Slow/Medium/Fast Auto-Scroll), large crushers appear on the screen that will smash Mario down.

Finally, the "Tileset-Specific" option puts a background on Layer 3. For most tilesets, this is a cage with garbled graphics that was intended to be used with the winged cage sprite. But on the Castle 1 tileset, you get windows (these windows are SMW Central's background on the default skin). In Underground 1 and 3, you get rocks (and in the latter, they move left continuously). Underground 2 gives you swimming fish, while Ghost House 1 and 2 give you mist. The windows and rocks should only be used with a blank background.

If you click on the Mario head button in LM, you'll find an option at the bottom that says "Force Layer 3 above all other layers". Click on the checkbox to do just that. However, you should only do it with the tides and goldfish. If you do it with the mist, you'll unintentionally create a hard level by obscuring a lot of things.

There's an editor on SMW Central called Terra Stripe that will let you edit Layer 3. Notable Glitches With Using Layer 3 in SMW

```
   You can't go past screen F when making tides, or things get very garbled from that point forward.
   Placing an Info box in a level with layer 3 enabled isn't recommended, as Layer 3 disappears when you hit it. Don't use this glitch to your advantage. For the tileset-specific options, it just makes the background disappear (not that big of a deal), and it causes the fish to get stuck in Underground 2, but for the tides, it makes them disappear, crippling your level! And finally, using message boxes in a level with the spotlight sprite or the Layer 3 Smash crushers will cause very weird things to happen.
   You can't use mist, fish, or Underground 3 rocks with a vertical level, or you'll sometimes see a "ghost" status bar scrolling left with them!
   Additionally, using interactive Layer 2 with interactive Layer 3 (such as a tide) is not recommended, as they share the same Map16 tile data and thus will definitely interfer with eachother. Layer 2 interaction will fall out and the Layer 3 tiles will override Layer 2.
```

### See Also

Other Layers Backdrop Color Layer 4 [Layer 3]() Layer 2 Layer 1 Sprite BG3 High Prio
