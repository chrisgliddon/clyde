VERSION		EQU	1
REVISION	EQU	40
DATE	MACRO
		dc.b	'19.11.95'
	ENDM
VERS	MACRO
		dc.b	'rlfloorsdef.a 1.40'
	ENDM
VSTRING	MACRO
		dc.b	'rlfloorsdef.a 1.40 (19.11.95)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: rlfloorsdef.a 1.40 (19.11.95)',0
	ENDM
