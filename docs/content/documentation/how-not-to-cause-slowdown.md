---
title: "Super NES Programming/How NOT to cause slowdown"
reference_url: https://en.wikibooks.org/wiki/Super_NES_Programming/How_NOT_to_cause_slowdown
categories:
  - "Book:Super_NES_Programming"
downloaded_at: 2026-02-13T20:16:53-08:00
---

Here are techniques to avoid having your game lag:

1. Using the direct page for object handling. For most computer systems, object handling is done by copying the object's variables to and from "local" memory to calculate the object's next onscreen position. On the SNES's 65816, on the other hand, the direct page register can point wherever you want, so you can set it to point at an object's variables. Sadly, because this feature wasn't on many CPUs, most SNES programmers didn't use it, and did the slower block copying.
2. Semi-unrolled loops. These are loops where the job is done twice per repetition. When in a loop, the CPU uses up a number of cycles counting down and jumping. With semi-unrolled looping, the CPU takes half the time it normally takes to count down and jump. It is almost as efficient as a fully unrolled loop, but with much less effort.
3. Inlining a subroutine. If there is a subroutine that is called in a tight loop, you can gain performance by replacing the "jsr" with a copy of the subroutine code. Calling a subroutine takes 12 cycles: 6 to jump, 6 to return.
