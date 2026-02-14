VERSION		EQU	1
REVISION	EQU	49
DATE	MACRO
		dc.b	'19.11.95'
	ENDM
VERS	MACRO
		dc.b	'rlenemies3.a 1.49'
	ENDM
VSTRING	MACRO
		dc.b	'rlenemies3.a 1.49 (19.11.95)',13,10,0
	ENDM
VERSTAG	MACRO
		dc.b	0,'$VER: rlenemies3.a 1.49 (19.11.95)',0
	ENDM
