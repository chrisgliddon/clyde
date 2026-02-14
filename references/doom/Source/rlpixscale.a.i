VERSION		EQU	1
REVISION	EQU	14
DATE	MACRO
		dc.b	'19.11.95'
	ENDM
VERS	MACRO
		dc.b	'rlpixscale.a 1.14'
	ENDM
VSTRING	MACRO
		dc.b	'rlpixscale.a 1.14 (19.11.95)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: rlpixscale.a 1.14 (19.11.95)',0
	ENDM
