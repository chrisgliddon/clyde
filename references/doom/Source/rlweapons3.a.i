VERSION		EQU	1
REVISION	EQU	93
DATE	MACRO
		dc.b	'19.11.95'
	ENDM
VERS	MACRO
		dc.b	'rlweapons3.a 1.93'
	ENDM
VSTRING	MACRO
		dc.b	'rlweapons3.a 1.93 (19.11.95)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: rlweapons3.a 1.93 (19.11.95)',0
	ENDM
