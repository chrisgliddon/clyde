VERSION		EQU	1
REVISION	EQU	56
DATE	MACRO
		dc.b	'19.11.95'
	ENDM
VERS	MACRO
		dc.b	'rlceilings.a 1.56'
	ENDM
VSTRING	MACRO
		dc.b	'rlceilings.a 1.56 (19.11.95)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: rlceilings.a 1.56 (19.11.95)',0
	ENDM
