VERSION		EQU	1
REVISION	EQU	30
DATE	MACRO
		dc.b	'19.11.95'
	ENDM
VERS	MACRO
		dc.b	'rltracew.a 1.30'
	ENDM
VSTRING	MACRO
		dc.b	'rltracew.a 1.30 (19.11.95)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: rltracew.a 1.30 (19.11.95)',0
	ENDM
