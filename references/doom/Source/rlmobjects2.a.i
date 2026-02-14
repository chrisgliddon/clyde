VERSION		EQU	1
REVISION	EQU	69
DATE	MACRO
		dc.b	'19.11.95'
	ENDM
VERS	MACRO
		dc.b	'rlmobjects2.a 1.69'
	ENDM
VSTRING	MACRO
		dc.b	'rlmobjects2.a 1.69 (19.11.95)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: rlmobjects2.a 1.69 (19.11.95)',0
	ENDM
