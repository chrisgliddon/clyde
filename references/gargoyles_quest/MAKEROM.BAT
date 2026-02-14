ECHO OFF



ECHO DID YOU RESET THE DEBUG_ON FLAG ???



PAUSE
asm658 /p /i /o c+,w- gg_main,gg
cksum gg.bin
