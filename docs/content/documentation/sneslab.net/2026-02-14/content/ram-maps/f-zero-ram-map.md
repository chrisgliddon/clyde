---
title: "F-Zero RAM Map"
reference_url: https://sneslab.net/wiki/F-Zero_RAM_Map
categories:
  - "RAM_Maps"
downloaded_at: 2026-02-14T11:58:55-08:00
cleaned_at: 2026-02-14T17:53:56-08:00
---

Here is a RAM Map for F-Zero that aims to be fairly comprehensible.

##### Data Types

Name Accepted Values Size Description Angle16 0x0000 - 0xBFFF 16-bit An angle with extra fractional precision.

0x0000 = 0 degrees  
0xBFFF ≃ 359.992675781 degrees  
Only the high byte affects the gameplay, the low byte is there just for fractional precision.  
(Each unit increments the real angle value by about 0.00732421875 degrees)

Angle8 0x00 - 0xBF 8-bit An angle without the fractional precision.

0x00 = 0 degrees  
0xBF ≃ 358.125 degrees  
(Each unit increments the real angle value by about 1.875 degrees)

CoordX 0x0000 - 0x1FFF 16-bit X coordinate value. These usually wrap around at 0x1FFF automatically. CoordY 0x0000 - 0x0FFF 16-bit Y coordinate value. These usually wrap around at 0x0FFF automatically.

##### Zero Page (Direct Page)

The Direct Page register (DP) is fixed to #$0000 all the time.

Address Length Type Description $7E0000 ?? bytes Misc. Scratchpad RAM. Used for various purposes, including: temporary storage, subroutine parameters, etc. $7E0034 1 byte Sprites Used in the AI car graphics routine.

How many sprite tiles were needed to draw the AI car.  
Stored to $7E11D0 when the graphics routine ends.

$7E003E 2 bytes Misc. Relevant value picked from the table at 7E:1076. $7E0040 1 byte Flag "Frame done" flag. Set to zero at the start of the main loop.

When NMI happens, it's decremented to #$FF, unless the value was already non-zero (i.e. a lag frame occurred.)  
This is used to make sure the gamestate runs once per frame.

$7E0041 2 bytes Pointer IRQ code pointer.

$8612 - Do nothing;  
$8616 (V-Counter = 18) - Set transparent power bar color, then trigger next IRQ at V-Counter = 28, set IRQ code pointer $863C;  
$863C (V-Counter = 28) - Set "horizon fog" color math settings, then trigger next IRQ at V-Counter = 47, set IRQ code pointer $865A;  
$865A (V-Counter = 47) - Set BG mode to 7, then trigger next IRQ at V-Counter = 86, set IRQ code pointer $8673;  
$8673 (V-Counter = 86) - Set player's shadow/finished rank color, then set the IRQ code pointer to $8612;  
$8691 (V-Counter = $7E0043) - Set BG mode to 7, then set the IRQ code pointer to $8612.

$7E0043 2 bytes IRQ Scanline where the Mode7 BG starts. Used only for IRQ pointer $8691, on the race intro sequence. $7E0045 1 byte Flag When the MSB is set, sound effects won't play. This is used to keep playing the "player wreckage" sounds when $7E0048 &gt;= #$80. $7E0046 4 bytes I/O SPC700 I/O ports. Various values can be written to play music or sound effects. $7E004A 1 byte Misc. Number of cars currently on screen, multiplied by two. (A bit of a mystery still, but seems to be used in a loop that assigns sprite priorities based on their Y position) $7E004B 2 bytes Sprites Index to OAM Table #1 ($7E0200) for routines that print characters/strings on screen. $7E004D 1 byte Sprites Index to OAM Table #2 ($7E0420) for routines that print characters/strings on screen. $7E004E 1 byte Sprites Used for bit-fiddling on OAM Table #2. Used in conjunction with $7E004D. $7E004F 1 byte Hardware mirror Mirror of SNES register $2101. $7E0050 1 byte Flag "Is the game drawing cars" flag. Non-zero = Yes.

This is used to correctly handle OAM DMA.

$7E0051 1 byte Counter "Global" frame counter. Always increments every frame (except lag frames), no matter what.

See also: $7E009A ("in-race" frame counter)

$7E0052 1 byte Misc. Player car type.

#$00 = Blue Falcon; #$01 = Wild Goose; #$02 = Golden Fox; #$03 = Fire Stingray.

$7E0053 1 byte Misc. Current race number.

From #$00 to #$04 in Grand Prix mode.  
From #$00 to #$06 in Practice mode.

$7E0054 3 bytes Misc. Current gamestate (game mode).

The first byte is the "main" gamestate, the second byte is the "sub" gamestate and the third byte is the "sub-sub" gamestate.  
This gamestate stuff is a complicated subject, which I plan to explain in more detail later.

$7E0057 1 byte Misc. Current difficulty setting.

#$00 = Beginner; #$01 = Standard; #$02 = Expert/Master (for Master, the flag at $7E0F3D is set)

$7E0058 1 byte Misc. Practice mode flag.

#$00 = Grand Prix mode; #$01 = Practice Mode

$7E0059 1 byte Misc. Number of spare machines (extra lives). $7E005A 1 byte Misc. Used by most menus as current selected option. $7E005B 1 byte Misc. "Is running pre-recorded race" flag.

#$00 = Player is in control; Other = Pre-recorded race is running.

$7E005C 1 byte Flag A flag related to color math effects.

When == #$00:

- HDMA channels 1 and 3 are disabled;
- $7E009B is stored to $2131;
- $7E0E27 is treated as the red color intensity for color math and it should range from #$00 to #$1F. ($7E0E27 | #$20) is stored to $2132;
- 7E:0E28 is treated as the green color intensity for color math and it should range from #$00 to #$1F. ($7E0E28 | #$40) is stored to $2132;
- 7E:0E29 is treated as the blue color intensity for color math and it should range from #$00 to #$1F. ($7E0E29 | #$80) is stored to $2132;
- IRQ is disabled.

When == #$01:

- HDMA channels 1 and 3 are enabled. Channel 1 is used for Mode7 and BG1 horizon, channel 3 is used for the "horizon fog";
- $212C is set to (#$13 ^ $7E005F);
- $7E0E25 is stored to $2131;
- $2132 is set to #$E0;
- IRQ is enabled to trigger at V-Counter = 18, IRQ code pointer is set to $8616.

When &gt; #$01:

- HDMA channel 1 is enabled. Channel 1 is used for Mode7 and BG1 horizon;
- HDMA channel 3 is disabled;
- $212C is set to #$13;
- IRQ is enabled to trigger at V-Counter = $7E0043, IRQ code pointer is set to $8691.

$7E005D 1 byte Hardware mirror Screen brightness and F-Blank flag. Mirror of SNES register $2100 $7E005E 1 byte Hardware mirror Enabled HDMA channels. Mirror of SNES register $420C $7E005F 1 byte Flag Flags related to shown layers and HUD updating. Format: u--s4321

1 = Hide BG1; 2 = Hide BG2; 3 = Show BG3; 4 = Hide BG4 (unused, F-Zero never uses BG4); s = Hide sprites; - = Unused bit u = Stop updating HUD (rank, timer, score and speedometer)

$7E0060 1 byte Misc. Screen fade type.

#$00 = Not fading; #$01 = Fade-in; Other = Fade-out.

$7E0061 1 byte Misc. Screen fade delay. How many frames it takes to increment/decrement the screen brightness. $7E0062 1 byte Timer Screen fade timer. How many frames until the screen brightness is incremented/decremented. $7E0063 1 byte I/O Controller 1 data (held buttons). Format: axlr----

a = A; x = X; l = L; r = R; - = Unused bits

$7E0064 1 byte I/O Controller 1 data (held buttons). Format: byetUDLR

b = B; y = Y; e = Select; t = Start; U = Up; D = Down; L = Left; R = Right.

$7E0065 1 byte I/O (Seems to be the exact same as $7E0063?) Used more often than $7E0063 $7E0066 1 byte I/O (Seems to be the exact same as $7E0064?) Used more often than $7E0064 $7E0067 1 byte I/O Controller 1 data (pressed buttons on current frame). Format: axlr----

a = A; x = X; l = L; r = R; - = Unused bits

$7E0068 1 byte I/O Controller 1 data (pressed buttons on current frame). Format: byetUDLR

b = B; y = Y; e = Select; t = Start; U = Up; D = Down; L = Left; R = Right.

$7E0069 1 byte I/O Controller 1 data (released buttons on current frame). Format: axlr----

a = A; x = X; l = L; r = R; - = Unused bits

$7E006A 1 byte I/O Controller 1 data (released buttons on current frame). Format: byetUDLR

b = B; y = Y; e = Select; t = Start; U = Up; D = Down; L = Left; R = Right.

$7E006B 1 byte Flag A flag related to windowing effects.

When == #$00:

- $212E and $212F are set to #$00;
- $7E0070 is stored to $2130;
- HDMA channel 2 is disabled.

When == #$01:

- HDMA channel 2 is enabled. Channel 2 is used for windowing effects, such as player's shadow and the big rank number when finishing a race;
- $7E006C is stored to $4322 (16-bit, HDMA channel 2 table address);
- $7E0E20 is stored to $7E0DE3;
- $7E006E is stored to $212E;
- $7E006F is stored to $212F;
- $7E0070 is stored to $2130;
- $7E0071 is stored to $2123;
- $7E0072 is stored to $2124;
- $7E0073 is stored to $2125.

When &gt; #$01:

- $7E006E is stored to $212E;
- $7E006F is stored to $212F;
- $7E0070 is stored to $2130;
- $7E0071 is stored to $2123;
- $7E0072 is stored to $2124;
- $7E0073 is stored to $2125.

$7E006C 2 bytes Pointer Pointer to data for windowing effects (HDMA channel 2). Points to $7E0DD0 while racing, and to $7E0DF0 while showing the big rank number after finishing a race. $7E006E 1 byte Hardware mirror Mirror of SNES register $212E. $7E006F 1 byte Hardware mirror Mirror of SNES register $212F. $7E0070 1 byte Hardware mirror Mirror of SNES register $2130. $7E0071 1 byte Hardware mirror Mirror of SNES register $2123. $7E0072 1 byte Hardware mirror Mirror of SNES register $2124. $7E0073 1 byte Hardware mirror Mirror of SNES register $2125. $7E0074 1 byte Misc. Index to $7E0EA0. Alternates between #$00 and #$10 every frame, to compensate for slowdowns (if it didn't alternate, the Mode7 layer would look jiterry when updating while the game was lagging). $7E0075 2 bytes Hardware mirror BG1 horizontal scroll. Mirror of SNES register $210D. $7E0077 2 bytes Hardware mirror BG1 vertical scroll. Mirror of SNES register $210E. $7E0079 2 bytes Hardware mirror BG2 horizontal scroll. Mirror of SNES register $210F. $7E007B 2 bytes Hardware mirror BG2 vertical scroll. Mirror of SNES register $2110. $7E007D 2 bytes Hardware mirror Mode7 X center. Mirror of SNES register $211F. $7E007F 2 bytes Hardware mirror Mode7 Y center. Mirror of SNES register $2120. $7E0081 1 byte Misc. Mode7 rendering type.

#$00 = No Mode7; #$01 = Perspective effect; Other = Top-down view.

$7E0082 1 byte Misc. This value + #$80 is written to $4342 and $4372. Similarly, this value + #$A0 is written to $4352 and $4362. This updates the Mode 7 rotation through HDMA.

Similar to $7E0074, this address also alternates between #$00 and #$10 every frame to compensate for slowdowns.  
Only used if $7E0081 == #$01.

$7E0083 1 byte Misc. Used after the "course zoom-in" on the race intro. This value is incremented every frame to raise the viewpoint pitch angle. When it reaches #$10, it stops increasing and the cars appear. $7E0084 1 byte Hardware mirror Written to $4347. Only used if 7E:0081 == #$01. $7E0085 1 byte Hardware mirror Written to $4357. Only used if 7E:0081 == #$01. $7E0086 1 byte Hardware mirror Written to $4367. Only used if 7E:0081 == #$01. $7E0087 1 byte Hardware mirror Written to $4377. Only used if 7E:0081 == #$01. $7E0088 2 bytes Hardware mirror Mode7 matrix A and D. Mirror of SNES registers $211B and $211E $7E008A 2 bytes Hardware mirror Mode7 matrix B. Mirror of SNES register $211C $7E008C 2 bytes Hardware mirror Mode7 matrix C. Mirror of SNES register $211D $7E008E 2 bytes Misc. Mode7 scaling. The Mode7 layer shrinks as this value increases. Only used if $7E0081 &gt; #$01 (top-down view) $7E0090 1 byte Misc. Current league.

#$00 = Knight League; #$01 = Queen League; #$02 = King League.

$7E0091 1 byte Empty Empty. Cleared on reset $7E0092 1 byte Misc. Amount of VRAM DMA transfers to perform for the next frame. Used for the $7E0AE0 DMA queue.

Should only range from #$00 to #$04, since the DMA queue has only four entries.  
See also: $7E009F (similar to this one, but for the $7E0420 DMA queue)

$7E0093 1 byte Flag Mode7 tilemap update flag. #$00 = don't update; #$01 = update only horizontally; Other = update both horizontally and vertically $7E0094 2 bytes Misc. VRAM address for horizontal updates on the Mode7 tilemap. $7E0096 2 bytes Misc. VRAM address for vertical updates on the Mode7 tilemap. $7E0098 1 byte Misc. CGRAM update mode. #$00 = don't update CGRAM; #$01 = update CGRAM normally; Other = set the whole background (colors 0-127) to the color at $7E0E26.

When the value is greater than #$01, it decrements until reaching #$01 again. This is used for flashing effects upon car explosions

$7E0099 1 byte Empty Empty. Cleared on reset $7E009A 1 byte Counter "In-race" frame counter. Increments every frame (except lag frames) while racing and the game is unpaused. Cleared on course load

See also: $7E0051 ("global" frame counter)

$7E009B 1 byte Hardware mirror CGADSUB settings. Mirror of SNES register $2131. Only used if $7E005C is zero $7E009C 1 byte Hardware mirror CGADSUB settings. Mirror of SNES register $2131. Used for the "horizon fog" $7E009D 1 byte Hardware mirror CGADSUB settings. Mirror of SNES register $2131. Used for the player's shadow and big finish rank $7E009E 1 byte Flag Flag used to force a visual update on a landmine tile that exploded. Non-zero = update tile at X position $7E0CFA and Y position $7E0CFC $7E009F 1 byte Misc. Amount of VRAM DMA transfers to perform for the next frame. Used for the $7E0420 DMA queue.

This is a bit different from $7E0092, due to the fact that the $7E0420 DMA queue can be interpreted in two different ways.  
When the MSB clear, the DMA queue is interpreted normally (same functionality as the $7E0AE0 DMA queue, but structured differently.)  
When the MSB is set, the DMA queue is interpreted as a "fill with byte," and each entry in the DMA queue occupies four bytes.  
For more information, see the description of $7E0420.

$7E00A0 2 bytes Misc. A copy of the fractional part of the player's X position ($7E0B80), actually unused $7E00A2 2 bytes CoordX Related to camera's X position

(Player's X position, minus #$0200)

$7E00A4 2 bytes Misc. A copy of the fractional part of the player's Y position ($7E0BA0), actually unused $7E00A6 2 bytes CoordY Related to camera's Y position

(Player's Y position, minus #$0200)

$7E00A8 2 bytes CoordX Related to camera's X position

(Value at $7E00A2, plus value at $0AED00 table)

$7E00AA 2 bytes CoordY Related to camera's Y position

(Value at $7E00A6, plus value at $0AED00 table)

$7E00AC 1 byte Angle8 Camera's facing $7E00AD 1 byte Misc. Amount of checkpoints present in the current course $7E00AE 1 byte Misc. High byte of the starting point's X position $7E00AF 1 byte Misc. High byte of the starting point's Y position $7E00B0 2 bytes Pointer 16-bit pointer to bank $7F. Points to the course chunks table (either #$4C00 or #$4E00) $7E00B2 2 bytes Empty Empty. Cleared on reset $7E00B4 2 bytes Misc. Something to do with X position after finishing a race first place, when the camera stops following the AI car. Still not understood $7E00B6 2 bytes Misc. Something to do with X position after finishing a race first place, when the camera fully turns while following the AI car. Still not understood $7E00B8 1 byte Misc. Current screen text. Format: rplLfyws.

r = Reverse; p = Power Down; l = Limit X; L = X laps left; f = Final lap; y = You lost; w = You won/Goal in; s = Special (spaceship, "READY." and "GO!!" sprites)  
Lower bits have more priority.

$7E00B9 1 byte Flag "Push start" text flag. Non-zero = show text $7E00BA 1 byte Misc. Last screen text shown. Used to clear this bit from $7E00B8 when the $7E00BB timer runs out $7E00BB 1 byte Counter Screen text timer. Decrements every frame until reaching zero.

However, when showing "You lost," "You won," or "Goal in," this value is incremented and is not taken into consideration.

$7E00BC 1 byte Misc. Offset to $00AFF8 table (screen text code pointer) for the last shown screen text. This is used so the game knows if the screen text was already being shown or if it needs to be initialized $7E00BD 1 byte Misc. Number of tiles used on the current screen text, multiplied by 8. Used to address OAM.

Note that when the text flashes and goes away temporarily, this value becomes zero

$7E00BE 2 bytes Timer GP ending timer. After finishing the final race of a Grand Prix, this value is set to #$1000. This value is decremented every frame until it reaches #$017C, at which time it is set to #$003B.

When this value is #$003B, the screen starts to fade out. When this value is #$0020, the music starts to fade out.

$7E00C0 1 byte Timer Race timer (minutes) $7E00C1 1 byte Timer Race timer (seconds) $7E00C2 1 byte Timer Race timer (centiseconds) $7E00C3 1 byte Misc. Race finish state. Format: lefcr??h

l = Race lost; e = Exploded; f = Race finished, follows AI car based on finish rank; c = Camera follows AI car indefinitely; ? = Unknown (possibly unused); h = Horizon moves according to camera's X position, not facing

$7E00C4 1 byte Empty Empty. Cleared on reset $7E00C5 1 byte Angle8 Facing of the player's current checkpoint $7E00C6 1 byte Empty Empty. Cleared on reset $7E00C7 1 byte Misc. Player surface flags. Format: irlp----

i = Ice; R = Right-push tile; L = Left-push tile; p = Pit area; - = Unused

$7E00C8 1 byte Misc. Player's invincibility frames $7E00C9 2 byte Misc. Player's machine power. The game actually allows this value to be a negative number, which is very odd $7E00CB 1 byte Empty Empty. Cleared on course load $7E00CC 1 byte Timer How many frames until the spaceship starts to go away. Set to #$10 while on pit areas. Decrements every frame when outside pit areas. When this value is zero, $7E00F3 starts to decrement $7E00CD 1 byte Timer A general purpose timer. Used in a multitude of situations $7E00CE 1 byte Misc. Has four purposes:

- Screen Y position offset for the cars before the race countdown;
- Index to the $0AEF80 (OAM data for the "GO!!" sprites);
- How many lap results are being shown on screen. Also accounts for the "Totals" row;
- Facing sprite of the car being selected in the car select screen.

$7E00CF 1 byte Timer Timer for the player explosion animation. Starts at #$00 and increments every frame until #$30. Used to play effects like flashing colors and etc. $7E00D0 1 byte Misc. Directly related to the "malfunction effect" animation timer ($7E0F3C.) Increments every frame until reaching a certain value when executing the animation (still not fully understood) $7E00D1 1 byte Misc. 16-bit indexer for player data. This is actually the value from $7E0052, multiplied by two $7E00D2 1 byte Misc. Stored to $7E040C. Determines whether to show one or two digits for the current rank. #$00 = Two digits; #$0F = One digit $7E00D3 2 bytes Empty Empty. Cleared on reset $7E00D5 2 bytes Misc. Player turning stage. Increases when turning left, decreases when turning right. Zero means not turning.

When turning left:  
\- Increases until reaching #$0E if not sharp-cornering, if sharp-cornering it's set to #$10. Decreases when not turning left.  
When turning right:  
\- Decreases until reaching #$F2 if not sharp-cornering, if sharp-cornering it's set to #$F0. Increases when not turning right.

Invalid values lead to weird sprite animations and turning speed

$7E00D7 2 bytes Misc. Related to turning stage ($7E00D5) incrementing (if turning left) and decrementing (if turning right) somehow.

Still need to investigate it.

$7E00D9 1 byte Misc. Related to grip/sliding?

#$01 = Gaining almost-instantaneous grip (from blast turning or soft landing.)  
#$02 = Sliding by holding L or R.

$7E00DA 1 byte Counter Counts up from #$00 to #$14 while the player is midair, after the hitting a jump plate.

The first byte of the acceleration table is used if the player is midair and this address is between #$04 and #$13 (inclusive).  
While this value is below #$10 and the player is midair, the player's car is forced to display the jumping animation.

$7E00DB 1 byte Misc. Index to the table with minimum ground distances ($009B7E). Counts up from #$00 to #$06 while the player is accelerating, after starting to accelerate.

Used to make the player's car move upwards a bit when starting to accelerate.  
This value is completelyignored while the player is not accelerating.

$7E00DC 1 byte Misc. Player's car minimum distance from ground. This value is set to #$00 while not accelerating. $7E00DD 1 byte Misc. Current player steer animation:

#$00 to #$04 = Left steering (#$00 is full left steer, #$04 is left steer step 1);  
#$05 = Not steering at all;  
#$06 to #$0A = Right steering (#$06 is right steer step 1, #$0A is full right steer);  
#$80 = Sliding left (holding L);  
#$81 = Sliding right (holding R).

$7E00DE 1 byte Misc. Related to $7E00DD in an unknown way, but also specifies the jumping animation:

#$80 = Jumping animation.

$7E00DF 1 byte Misc. Current sharp cornering ground sparks animation:

#$01 through #$0A = full animation cycle for the sparking (from the left side);  
#$81 through #$8A = full animation cycle for the sparking (from the right side).

$7E00E0 1 byte Misc. Player's sprite animation (overrides $7E00DD)

#$80 through #$89 = Being damaged (collision/guardrails);  
#$40 through #$43 = Damaged by explosive (launched left);  
#$44 through #$47 = Damaged by explosive (launched right);  
#$20 = Sliding left (holding L);  
#$21 = Sliding right (holding R);

$7E00E1 1 byte Misc. Player's thruster fire animation delay. If MSB is set, its brightness ($7E00E2) is reset to #$00. This value is #$00 while not accelerating $7E00E2 1 byte Misc. Player's thruster fire brightness. #$00 = Darkest; #$5D = Brightest. $7E00E3 1 byte Misc. Player's thruster fire animation frame.

#$00 = None; #$01 = Big; #$02 = Medium; #$03 = Small.

$7E00E4 1 byte Timer Player's thruster fire animation timer. $7E00E5 1 byte Misc. Player's thruster fire Y position (relative to player's car) $7E00E6 2 byte Pointer Pointer to the routine that draws the player's thruster fire. $7E00E8 1 byte Timer Guardrail flash timer. Set to #$08 when the player drives over a guardrail (if the value was previously #$00). $7E00E9 1 byte Misc. Used to play guardrail damage and rough landing effects. Also flashes the player's car black.

Decrements every frame. When the low nibble is zero, this value is set to #$00.  
Set to #$8B when playing guardrail damage effects. Set to #$45 when playing rough landing effects.  
When #$8A, the guardrail damage sound effect is played.

$7E00EA 1 byte Empty Empty. Cleared on course load $7E00EB 1 byte Misc. Y position of the first spaceship "light beam". Initialized to #$00 when it's first displayed.

Increases by #$10 every frame until it reaches #$B0, where it resets to #$00 again.

$7E00EC 1 byte Misc. Y position of the second spaceship "light beam". Initialized to #$50 when it's first displayed.

Increases by #$10 every frame until it reaches #$B0, where it resets to #$00 again.

$7E00ED 1 byte Misc. Related to the color of the player's thrusters. Needs research. $7E00EE 1 byte Empty Empty. Cleared on course load $7E00EF 1 byte Misc. Base offset to the turn speed table ($02C9AB) for the player's machine. Loaded directly from the $00FA79 table $7E00F0 1 or 2 bytes Misc. Has three purposes:

- (2 bytes) In the title screen, it acts as a counter for the demo race. It increases every frame, and when it reaches #$0500, the demo race starts playing;
- (1 byte) While in a race, this value controls the power bar graphics somehow.
- (1 byte) Car select confirm option. #$00 = Yes; #$02 = No

$7E00F1 1 byte Misc. Car selection screen transition. #$00 = None; #$01 = Windowing fade in; Other = Windowing fade out. $7E00F2 1 byte Misc. Has two purposes:

In the records menu, it acts as the current selected option:

- #$00 = Mute City I, #$01 = Big Blue, ..., #$0D = Red Canyon II, #$0E = Fire Field, #$0F = Exit.

In a race, this value is set to the track index of the first track in the cup:

- #$00 = Knight, #$05 = Queen, #$0A = King.

$7E00F3 1 byte Misc. How much of the spaceship is currently on screen. Counts up from #$00 to #$23 while in a pit area tile. $7E00F4 1 byte Empty Empty. Cleared on course load $7E00F5 1 byte Timer Road flash timer. Set to #$09 when the player hits a wall (if the value was previously #$00). $7E00F6 1 byte Misc. Unused, but for some reason it's reset to #$00 when unpausing the game. $7E00F7 1 byte Empty Empty. Cleared on course load $7E00F8 2 or 3 bytes Misc. Has multiple purposes:

- (2 bytes) Holds the score gained, in BCD, when finishing a lap;
- (2 bytes) Used to calculate a damage multiplier based on the machine speeds upon a heavy collision;
- (2 bytes) Used a lot in SRAM-related code, as a multipurpose value;
- (3 bytes) During a pre-recorded race, this is a 24-bit pointer to the next action to be executed.

$7E00FA 2 bytes Misc. Used in SRAM-related code as an index to the SRAM buffer.

(Note that during a pre-recorded race, this value is the bank from the pointer at $7E00F8.)

$7E00FC 1 byte Misc. Current lap number being checked for new fastest lap record. $7E00FD 1 byte Empty. Empty. Cleared on course load and when unpausing the game. $7E00FE 2 bytes Pointer Used as a temporary 16-bit pointer in $0086DF and $00AE19.

This is still a work-in-progress! Descriptions will be made clearer as time goes on.

##### $7E0100 and onwards

Address Length Type Description $7E0100 256 bytes Stack Reserved for stack. Hacks can probably use $7E0100-$7E0180 safely as free RAM. $7E0200 512 bytes OAM OAM buffer. 4 bytes per sprite, in the same format as expected by the PPU:

X position, Y position, tile, attributes

$7E0400 32 bytes OAM OAM "hi-table" buffer. 2 bits per sprite, in the same format as expected by the PPU. $7E0420 64 bytes Misc. DMA queue #1, controlled by $7E009F.

This one is a bit complicated, I'll fill up this description later.

$7E0460 32 bytes Empty Potentially empty. Cleared on reset $7E0480 128 bytes Misc. General purpose buffer. $7E0500 512 bytes CGRAM CGRAM buffer. $7E0700 256 bytes CGRAM Original OBJ colors. Used to revert to original colors after $7E0800 is used. $7E0800 256 bytes CGRAM Alternate OBJ colors. Used for color effects on sprites, such as player flashing black. $7E0900 96 bytes CGRAM Contains both original and alternate colors for BG. $7E0960 3\*6 bytes Misc. Race lap times/splits. 6 Entries in total (3 bytes each, same format as $7E00C0-$7E00C2). The last entry is the total race time.

Only calculated after the race ends.

$7E0972 1 byte Misc. Race number character to be printed on screen for the GP end results text $7E0973 1 byte Timer Text wait timer (GP end results, Credits and Master difficulty ending) $7E0974 1 byte Misc. During the GP end results:

- Race number from where to grab lap times and ranks to be printed.

During the Credits screen:

- Index to $02C74F (Credits text data)

During the Master difficulty ending:

- Controls screen brightness somehow

$7E0975 1 byte Misc. During the GP end results:

- Index to $02C6BE (GP end results text data)

During the Master difficuilty ending:

- Index to $039DF1 (Master ending text data)

$7E0976 1 byte Misc. OAM attributes for text printing (GP end results and Master difficulty ending) $7E0977 1 byte Misc. Text X position (GP end results, Credits and Master difficulty ending) $7E0978 1 byte Misc. Text Y position (GP end results and Master difficulty ending) $7E0979 1 byte Empty Empty. Cleared on reset $7E097A 3 bytes Misc. Currently displayed score, in BCD. Counts up until reaching the value at $7E097D. High byte seems to be ignored (is this even a 3-byte value?) $7E097D 3 bytes Misc. Current score, in BCD. High byte seems to be ignored (is this even a 3-byte value?) $7E0980 128 bytes Empty Most likely empty. Cleared on reset $7E0A00 128 bytes Tilemap Race BG3 HUD tilemap.

This is still a work-in-progress! More will be added later, and descriptions will be made clearer as time goes on.
