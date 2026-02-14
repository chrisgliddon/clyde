VERSION		EQU	1
REVISION	EQU	84
DATE	MACRO
		dc.b	'19.11.95'
	ENDM
VERS	MACRO
		dc.b	'rlcolour.a 1.84'
	ENDM
VSTRING	MACRO
		dc.b	'rlcolour.a 1.84 (19.11.95)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: rlcolour.a 1.84 (19.11.95)',0
	ENDM
