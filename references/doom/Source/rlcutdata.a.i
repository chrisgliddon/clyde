VERSION		EQU	1
REVISION	EQU	45
DATE	MACRO
		dc.b	'19.11.95'
	ENDM
VERS	MACRO
		dc.b	'rlcutdata.a 1.45'
	ENDM
VSTRING	MACRO
		dc.b	'rlcutdata.a 1.45 (19.11.95)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: rlcutdata.a 1.45 (19.11.95)',0
	ENDM
