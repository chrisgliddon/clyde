---
title: "Destructive return"
reference_url: https://sneslab.net/wiki/Destructive_return
categories:
  - "ASM"
downloaded_at: 2026-02-14T11:45:28-08:00
cleaned_at: 2026-02-14T17:51:45-08:00
---

A routine with a **destructive return** does not return to the parent routine. Instead, it returns to the parent's parent.

## Example

Imagine that we have three routines: A, B and C. Routine A calls Routine B, which in turn calls Routine C. If Routine C was a normal routine, it would return to Routine B when it's finished. However, if Routine C has a destructive return, it will return directly back to Routine A when it's finished, skipping any code that might be left in Routine B.

## How to do destructive returns

You use stack tricks along with JSR/JSL and RTS/RTL. Assuming you just jumped to a routine with a JSL; JSL pushes 3 bytes to the stack which contains the return address. RTL pulls 3 bytes from the stack as a 24-bits address, then jumps to it which causes the return. However, if you pull those 3 bytes manually before using RTL, it will pull the 3 next available stack bytes, and jump to it, which causes a destructive return.

## SMW's usage

SMW uses destructive returns in the "Execute pointers" subroutines, located at $00:86F9 and $00:871D. SMW also uses it with GetDrawInfo located in bank 1; it uses 2 PLA at $01:A3CB to return from the entire GFX subroutine of a sprite, when the sprite in question is offscreen. Same case with GetDrawInfo in bank 2, at $02:D3E7 and GetDrawInfo in bank 3, at $03:B7CF.
