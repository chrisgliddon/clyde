VERSION		EQU	1
REVISION	EQU	44
DATE	MACRO
		dc.b	'19.11.95'
	ENDM
VERS	MACRO
		dc.b	'rlcutdef.a 1.44'
	ENDM
VSTRING	MACRO
		dc.b	'rlcutdef.a 1.44 (19.11.95)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: rlcutdef.a 1.44 (19.11.95)',0
	ENDM
