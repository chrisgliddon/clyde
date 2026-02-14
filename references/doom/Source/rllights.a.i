VERSION		EQU	1
REVISION	EQU	12
DATE	MACRO
		dc.b	'19.11.95'
	ENDM
VERS	MACRO
		dc.b	'rllights.a 1.12'
	ENDM
VSTRING	MACRO
		dc.b	'rllights.a 1.12 (19.11.95)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: rllights.a 1.12 (19.11.95)',0
	ENDM
