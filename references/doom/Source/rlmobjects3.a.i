VERSION		EQU	1
REVISION	EQU	65
DATE	MACRO
		dc.b	'19.11.95'
	ENDM
VERS	MACRO
		dc.b	'rlmobjects3.a 1.65'
	ENDM
VSTRING	MACRO
		dc.b	'rlmobjects3.a 1.65 (19.11.95)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: rlmobjects3.a 1.65 (19.11.95)',0
	ENDM
