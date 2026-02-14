;******************************************************************************
; interlock variables (connect SNESAUD to your game)
;******************************************************************************

AUDSWAPSPACE	equ	$2300	;first available byte of APU RAM

;
; The following are offsets from the included ROM of branch instructions to
; the appropriate routine. So, in order to call audcold, you would do
; something like this:
;
;	jsl	SNESAUD+rlaudcold
;
; ...where SNESAUD is a label you put at the ROM inclusion point. I suggest
; that you make a macro to do this, i.e.
;
;	audcall macro name
;		jsl SNESAUD+rl&name
;	endm
;	.
;	.
;	.
;	audcall send_sample_package
;
;

rlaudcold		equ	$0001*3
rlaudinit		equ	$0002*3
rlaudio_frame		equ	$0003*3
rldo_sound_controller	equ	$0004*3
rldo_sound_fx		equ	$0005*3
rldo_music		equ	$0006*3
rlsend_music_package	equ	$0007*3
rlsend_music_module	equ	$0007*3
rlsend_sample_package	equ	$0008*3
rlsend_sample_module	equ	$0008*3
rlaud_do_new_loop	equ	$0009*3    ;FRONT END SUPPORT - DO NOT USE
rlflush_fx_queue	equ	$000a*3
rlflush_command_queue	equ	$000a*3
rlredo_sound_fx 	equ	$000b*3
rlredo_music		equ	$000b*3
rlmidi_event		equ	$000c*3
rlget_passback		equ	$000d*3
rlapu_test		equ	$000e*3    ;FRONT END SUPPORT - DO NOT USE
rlsend_instrument_package equ	$000f*3
rlsend_instrument_module  equ	$000f*3

;
; Variables you need to know about
;
;aud_vbflag		 equ	 AUDRAM+$0000		 ;1 byte or word
;aud_arg4		 equ	 AUDRAM+$0002		 ;1 word

;******************************************************************************
; game-level communication
;******************************************************************************

BMCT_PLAYNOTE		equ	$80+$03

BMCT_SETSTEREO		equ	$80+$20
BMCT_KILLID		equ	$80+$02
BMCT_BREAKLOOP		equ	$80+$13
BMCT_BREAKTONEW 	equ	$80+$14

BMCT_CHANGETEMPO	equ	$80+$10
BMCT_PITCHBEND		equ	$20
BMCT_MUTE		equ	$80+$22
BMCT_TOGGLEPAUSE	equ	$80+$06

BMCT_CHANGEVOLUME	equ	$80+$70
BMCT_CHANGEPAN		equ	$80+$60
BMCT_CHANGETRANSPOSE	equ	$80+$50
BMCT_CHANGEPATCH	equ	$80+$40

