---
title: "Layer 2"
reference_url: https://sneslab.net/wiki/Layer_2
categories:
  - "Video"
  - "Backgrounds"
downloaded_at: 2026-02-14T13:38:43-08:00
cleaned_at: 2026-02-14T17:55:10-08:00
---

**Layer 2** is one of the Super NES's five hardware layers. In *Super Mario World*, this layer can either contain a background or can supplement Layer 1 with additional level data.

Whether Layer 2 contains level data or an image is determined by what level type it is. Level types 0, A, C, D, E, 11, and 1E use a background on Layer 2, while level types 1, 2, 7, 8, F, and 1F support level data. In addition, on level types 1, 7, and F, no one can interact with the layer.

If Layer 2 is a background, then you need to click on the green leaf icon in Lunar Magic to edit it. That opens the background editor, which you can use in conjunction with the Map16 editor. If Layer 2 is a level, then you can click on the gold rock icon to edit it. Editing a level Layer 2 is exactly the same as editing Layer 1.

### Limitations and weird stuff

Unfortunately, Layer 2 levels can only support 16 screens, and vertical Layer 2 levels can only support 14, compared to the 32/28 that regular levels support. Also, since Layer 2 levels can't have a formal background, they're inherently very bland to look at. Fortunately, if you're in the Castle 1, either Ghost House, or any Underground tileset, you can set Layer 3 to be "tileset-specific", and that will generate a special background. Or, as was done in the beginning of Ludwig's Castle, you can always make your own background.

If you're in the Underground 1 tileset, then anything on Palettes 0-3 will get their palette shifted down by four rows. That's why Donut Plains 2, Valley of Bowser 2, and many other miscellaneous areas looked like they had gold bars in the original game. Those gold bars weren't special objects; they were ordinary ground.

You can't use tides with a Layer 2 level, as that will cause memory overlap glitches. Layer 2 commands

The vast majority of hackers make Layer 2 have level data so they can build a level around any one of these commands. Many of these commands can actually be used in regular levels; in fact, room #4 of Front Door actually did use a "Layer 2 Scroll Range 05" command! That's why the background scrolled in that room.

For most of these commands, you need to go into the "Change Other Properties" dialog box and make Layer 2 have constant scrolling in one direction and no scrolling in the other. Unless otherwise indicated, you can only use these commands with horizontal levels.

```
   Auto-Scroll Special 1: Used only in Donut Plains 2, it's the only auto-scroll option that supports Layer 2. You must set foreground scrolling to "No Vertical or Horizontal Scroll" and Layer 2 scrolling to "H-Scroll: None, V-Scroll: None".
   Layer 2 Smash: Causes objects on Layer 2 to slam down. The "Smash 1" option was used solely in Wendy's Castle, the "Smash 2" option was used only in Valley Fortress, and the "Smash 3" option was only used in room #5 of Front Door.
   Layer 2 Scroll: Causes Layer 2 to move up and down by the specified number of pixels, in decimal. The first option has ranges of 12 and 5. The second option has a range of 8. The third option has a range of 5, and the fourth option has ranges of 6 and 11. For the Layer 2 Scroll Range 12 option, you need to go into the "Modify Main and Midway Entrances" dialog and set the background initial position to BG=00. The fourth option's range of 11 actually says "Layer 2 Scroll Smash Range 11", and is very similar to Layer 2 Smash 1.
   Layer 2 Falls: Can only be used with vertical levels. Layer 2 horizontal and vertical scrolling must be set to none. The sprite will cause Layer 1 to not move.
   Layer 2 Scroll Sideways: Can only be used in vertical levels, and this sprite stops the level from scrolling horizontally, so that you can only build it on the left side. There's a "short" option and a "long" option.
   Layer 2 On/Off Switch: Used in the second section of Ludwig's Castle. This causes Layer 2 to fall if the On/Off flag is set to on, and rise if it's set to off. It'll automatically turn the switch back on once it stops rising. Once Layer 2 quits falling, some glitches will happen. Layer 1 will have a slightly "smashed in" look, and many sound effects will be overwritten with the "Thwomp" sound. If Layer 2 has stopped falling, and you turn the switch off, then an earthquake effect will happen as Layer 2 rises again.
   Fast BG Scroll: Can only be used when Layer 2 is a background. Step on two certain sprites, and Layer 2 will indeed scroll to the left very quickly. Is also in Level C8 as a persistent effect via the Auto-Scroll Special 1-A command.
   Layer 2 Sink: Used in specific areas of Vanilla Dome 1 and Chocolate Secret. There's a "short" and a "long" option, and each one determines the amount of screens that the sinking effect lasts before it resets. This sprite won't work on the very first screen of a level. The third option for this sprite is Layer 2 Rise Up, which was used at the end of Valley of Bowser 2. If you build a level with this option, then the position you place objects in in Lunar Magic represents the highest point that they will rise up to. And finally, there's a Layer 2 Give Some option that's rather useless; it'll only cause Layer 2 to budge slightly when you step on it, then reset. 
```

Layer 2 on the overworld

Main article: Tutorial:Basic Overworld Editing

On the overworld, Layer 2 is used to help make it look pretty and give it life. There are all sorts of tiles you can place on Layer 2, such as grass, rocks, water, waterfalls, level markers, and paths. To access the layer, click on the green hill button in LM's overworld editor. If you click on the green hill with a shiny dot, you'll go into Layer 2 Event Mode instead.

To actually add stuff, click on the rock icon that has only the upper left corner showing (regular) or the green-and-yellow path button (Event Mode). Other information

```
   A-l-e-x-99's Layer 2 tutorial that he constantly forgets to reference whenever he's making Layer 2 levels.
```

### See Also

Other Layers Backdrop Color Layer 4 Layer 3 [Layer 2]() Layer 1 Sprite BG3 High Prio
