---
title: "Super NES Programming/Multijointed Sprite Bosses"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/Multijointed_Sprite_Bosses
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:17:28-08:00
---

Multi-jointed bosses are an efficient, but rarely used, technique to animate cool looking bosses. Unlike most bosses where the entire boss is one sprite, with multi-jointed bosses, every body part is an individual sprite that rotate around each other.

Here is how to program a simple robotic arm:

1\) Draw the sprite for the shoulder, upper arm, elbow, lower arm and hand at 16 equally spaced angles.

2\) Now you need to define 10 registers:

a) shoulder angle

b) elbow angle

c) shoulder angle key frame

d) elbow angle key frame

e) shoulder x

f) shoulder y

g) angle

h) amplitude

i) result x

j) result y

3\) Write a routine that converts between polar coordiantes (angle,amplitude) to rectangular coordinates (x,y).

4\) Write a routine that displays a sprite with the center being defined by resulting rectangular coordinates, with the angle being used to determing the sprite's attributes.

5\) Write a routine that increments the shoulder and elbow angles towards their coorisponding key frame angles.

6\) Now put all this together in one big routine:

\- The bosses AI determines the key frame angles and shoulder coordinates.

\- increment the shoulder and elbow angles towards their coorisponding key frame angles.

\- copy shoulder coordinates to result coordinates

\- copy shoulder angle to angle

\- display 16x16 shoulder sprite

\- set amplitude to 24 pixels

\- convert between polar to rectangular coordinates

\- display 32x32 upper arm sprite

\- convert between polar to rectangular coordinates

\- display 16x16 elbow sprite

\- copy elbow angle to angle

\- convert between polar to rectangular coordinates

\- display 32x32 lower arm sprite

\- convert between polar to rectangular coordinates

\- display 16x16 hand sprite
