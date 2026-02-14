VERSION		EQU	1
REVISION	EQU	1
DATE	MACRO
		dc.b	'19.11.95'
	ENDM
VERS	MACRO
		dc.b	'sightray.a 1.1'
	ENDM
VSTRING	MACRO
		dc.b	'sightray.a 1.1 (19.11.95)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: sightray.a 1.1 (19.11.95)',0
	ENDM
