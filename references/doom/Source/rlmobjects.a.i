VERSION		EQU	1
REVISION	EQU	76
DATE	MACRO
		dc.b	'19.11.95'
	ENDM
VERS	MACRO
		dc.b	'rlmobjects.a 1.76'
	ENDM
VSTRING	MACRO
		dc.b	'rlmobjects.a 1.76 (19.11.95)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: rlmobjects.a 1.76 (19.11.95)',0
	ENDM
