# Example makefile for simple 65816 prog

# Assemble to target and create symbol file

assemble:
  asm658 /i /o w-,c+ gg_main,t0:,gg_main

# Assemble to target but don't run

asmnorun:
  asm658 /i /d /o w-,c+ gg_main,t0:,gg_main

# Enter debugger and load symbol file

debug:
  dbug658 gg_main

# Evaluate expression using values from symbol file

evaluate:
  dbug658 /v$(exp) gg_main
