*******************************************************************************
*									      *
* PROJECT:     SLICK/Audio						      *
*									      *
* Authors:     David O'Riva                                                   *
*									      *
* File Description:							      *
*									      *
*	Example 65816 game audio driver 				      *
*									      *
*									      *
*******************************************************************************
seg main

;******************************************************************************
;				  DATA
;******************************************************************************

spc700rom:	incrom s700aud\s700aud.rom


		.16bita
		lda	#AUDRAM 		;offset of 65816 ram page
						; see the manual for more info
auddrv:
		incrom snesaud\snesaud.rom


snd_directory:	;group #0		;a directory of different ROM groups
		dd	snd_music1	; this directory is used by
		dd	snd_instru1	; "aud_downloadgroup" below.  You will
		dd	snd_samples1	; probably want to change this - it's
		;group #1		; not nearly as flexible as it should
		dd	snd_music2	; be.
		dd	snd_instru2
		dd	snd_samples2


;******************************************************************************
;				  CODE
;******************************************************************************


;******************************************************************************
; aud_coldstart - audio cold start
;
;	Downloads the basic driver.  Uses the data found at "spc700rom" above.
;
;     ENTRY:	nothing
;
;      EXIT:	nothing
;
; DESTROYED:	a,x,y
;
;------------------------------------------------------------------------------
xproc aud_coldstart

		php
		on16
;ÖÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·
;º cold boot the drivers						      º
;ÓÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ½
		ldx	#<spc700rom
		lda	#^spc700rom
		audcall audcold

		ldx	#BMCT_SETSTEREO 	;the driver defaults to stereo,
		ldy	#1 ;flag value		; but we're gonna set it here
		lda	#0 ;ignored		; anyway
		audcall do_sound_controller

		lda	#1			;force it through now
		audcall flush_fx_queue

		plp
		rts
endproc



;******************************************************************************
; aud_warmstart -
;
;
;     ENTRY:	nothing
;
;      EXIT:	nothing
;
; DESTROYED:	a,x,y
;
;------------------------------------------------------------------------------
xproc aud_warmstart

		php
		on16

; Currently, there is no way to do a true "warm restart" of the drivers, so
; we just do a "kill all sound" controller, and force it down NOW.
; Then, we call a routine to reset the audio RAM back to a startup state.
; The driver is not re-sent.

		ldx	#BMCT_KILLID
		ldy	#0ff			;global ID
		lda	#0
		audcall do_sound_controller
		lda	#9			;force it through
		audcall flush_fx_queue

		audcall audinit 		;clear RAM
		plp
		rts

endproc



;******************************************************************************
; aud_waitforvblank - audio backfilled-frame downloads
;
;
;     ENTRY:	a = AUDFRAME flags:
;			bit 0 - if set, ignore frame sync,
;					force all pending events through NOW
;
;			bit 7 - if set, ignore frame sync,
;					x = # of bytes to send (16 bit)
;
;			NOTE: These two modes are mutually exclusive.
;			      Combining them will give unpredictable results.
;
;			bit 1 - if set, exit early if there is nothing to do
;
;
;      EXIT:	a = audio driver state:
;		    bit 0 = NMI occurred during or before this routine
;		    bit 7 = if set, download is in progress
;
; DESTROYED:	a,x,y
;
;------------------------------------------------------------------------------
xproc16 aud_waitforvblank

; Note: normally you would just stick this call somewhere in your game code

		audcall audio_frame
		rts

endproc


;******************************************************************************
; aud_updatequeue -
;
;
;     ENTRY:	a = flags: bit 0 set - flush it out NOW, wait as long as
;				       necessary for APU sync
;			       1 set - if there is passback info, get it NOW
;			       3 set - allow passback information
;			       7 set - X = time to wait for APU before failing
;
;
;      EXIT:	cc: call succeeded, queue (if any) has been flushed
;
;		cs: call failed due to: a) couldn't sync in given time
;					b) routine was re-entered
;					c) package download in progress
;
; DESTROYED:	a,x,y
;
;------------------------------------------------------------------------------
xproc16 aud_updatequeue

; Note: normally you would just stick this call somewhere in your game code

		audcall flush_fx_queue
		sec
		rts

endproc


;******************************************************************************
; aud_startsong - starts a song
;
;	There isn't really any difference between songs and sound effects, but
; this routine starts a song with reasonable default values and a much less
; complex setup.  See "aud_starteffect" below for the full list of arguments
; than can be applied to a song.
;
;	This routine sets up the following conditions in addition to the ones
; specified in the entry arguments:
;
;		Default pan (i.e. as set in the front end)
;		No tempo offset
;		No transposition
;
;
;     ENTRY:	a (high byte)  = game ID #
;		a (low byte)   = volume
;					$00 = minimum volume
;					$7f = maximum volume
;		x (low byte)  = song package #
;
;      EXIT:
;
; DESTROYED:	y
;
;------------------------------------------------------------------------------
xproc16 aud_startsong

		pha
		phx

		xba
		pha
		txa
		ply
		and	#$00ff
		ora	#$8000
		tax
		lda	#$0000
		jsr	aud_starteffect

		plx
		pla
		rts
endproc



;******************************************************************************
; aud_starteffect - starts a sound effect
;
;
;     ENTRY:	x (low byte)  = song package #
;		x (high byte) = pan controller value
;					$00 = hard left
;					$7f = hard right
;					$80 = use defaults
;					$81-$ff = undefined
;		y (low byte)  = game ID
;					used to reference the song later on
;					$00-$df = normal
;					$e0-$ff = background music
;					read the manual for more information
;		y (high byte) = volume
;					$00 = minimum volume
;					$7f = maximum volume
;		a (low byte)  = transpose
;					-128 to +127 semitones
;		a (high byte) = tempo adjustment
;					-128 to +128 BPM
;
;      EXIT:
;
; DESTROYED:	a,x,y
;
;------------------------------------------------------------------------------
xproc16 aud_starteffect

		audcall do_music
		rts

endproc



;******************************************************************************
; aud_dopitchbend - changes the pitch of a playing piece of music
;
;	Changes the MIDI pitchbend controller value for ALL playing streams in
; the specified piece of music.  Granularity is 1/256 of a semitone.  Roughly
; true pitch in the bend is maintained by linear interpolation of pitch values
; between semitones; there will be minor distortion in chords, but it should
; be unnoticable to most ears.
;
;	The pitch bend value is in 1/256ths of a semitone; that is, if X=0, no
; bend will occur, if X=$100, pitch will bend up 1 semitone, and if X=$ff00,
; pitch will bend down 1 semitone.
;
;	This controller OVERRIDES any existing MIDI pitch bend within the
; streams.
;
;     ENTRY:	a = game ID of song to bend
;		x = signed 13 bit pitchbend controller value (will be chopped)
;			range is -16 semitones to +15.99 semitones
;
;      EXIT:
;
; DESTROYED:	a,x,y
;
;------------------------------------------------------------------------------
xproc16 aud_dopitchbend

		pha
		txa				;get pitch val in A
		and	#$01fff 		;chop off excess bits
		tay				;Ylow = low 8 bits
		xba				;Alow = high 5 bits
		ora	#BMCT_PITCHBEND 	;stuff in the controller mask
		and	#$000ff 		;clear high byte of a
		tax				;X = controller + data
		tya
		ply				;Y = ID to apply it to
		audcall do_sound_controller
		rts
endproc



;******************************************************************************
; aud_dovolume - changes the volume of a playing song
;
;	This controller is seperate from the various MIDI controllers, and
; may be changed with no fear of destroying or altering the song.  This
; controller takes effect IMMEDIATELY, on all currently playing notes and all
; future notes.
;
;
;     ENTRY:	a = game ID of song to change volume of
;		x = new volume ($00-$7f)
;
;      EXIT:
;
; DESTROYED:	a,x,y
;
;------------------------------------------------------------------------------
xproc aud_dovolume

		php
		on16
		tay
		txa
		ldx	#BMCT_CHANGEVOLUME
		audcall do_sound_controller
		plp
		rts
endproc

;******************************************************************************
; aud_dopan - changes the stereo position of a playing song
;
;	This controller overrides the MIDI pan controller, and may interfere
; with stereo effects in the playing song. This controller takes effect
; IMMEDIATELY, on all currently playing notes and all future notes.
;
;     ENTRY:	a = game ID of song to change pan of
;		x = new pan: $00 = hard left
;			     $7f = hard right
;
;      EXIT:
;
; DESTROYED:	a,x,y
;
;------------------------------------------------------------------------------
xproc aud_dopan

		php
		on16
		tay
		txa
		ldx	#BMCT_CHANGEPAN
		audcall do_sound_controller
		plp
		rts
endproc



;******************************************************************************
; aud_killsong - stops a playing song
;
;
;     ENTRY:	a = game ID of song to kill
;
;      EXIT:
;
; DESTROYED:
;
;------------------------------------------------------------------------------
xproc aud_killsong

		php
		on16
		ldx	#BMCT_KILLID
		tay
		lda	#0
		audcall do_sound_controller
		plp
		rts

endproc


;******************************************************************************
; aud_downloadgroup - starts downloading modules
;
;	This routine starts the download process for a sample, instrument and
; MIDI module (see snd_directory at the top of this file).
;
; ***				     * * *
;
; NOTE: The download DOES NOT happen when you call this routine!  It is just
;	queued up to be performed, possibly in many small pieces, by the
;	audio frame routine.
;
; ***				     * * *
;
;     ENTRY:	a = group number to download
;
;      EXIT:
;
; DESTROYED:
;
;------------------------------------------------------------------------------
xproc aud_downloadgroup

		php
		on16
		and	#0ff		;multiply a by 12 to make an offset
		sta	temp1		;into the directory
		asl
		adc	temp1
		asl
		asl
		sta	temp1
		tax
;ÖÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·
;º send samples 							      º
;ÓÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ½
		lda	#0			;stuff the fourth argument into
		sta	AUDRAM+2		;  sound RAM
		ldx	temp1			;get the directory index back
		lda	>8+snd_directory,x	;get offset of sample package
		tay				;  into Y
		lda	>0a+snd_directory,x	;get bank of sample package in A
		ldx	temp2
;		 ldx	 #-2			 ;send it to the first available
		audcall send_sample_package	;  address
;ÖÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·
;º send instruments							      º
;ÓÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ½
		lda	#0			;stuff the fourth argument into
		sta	AUDRAM+2		;  sound RAM
		ldx	temp1			;get the directory index back
		lda	>4+snd_directory,x	;get offset of inst package
		tay				;  into Y
		lda	>6+snd_directory,x	;get bank of inst package in A
		ldx	#-1			;send it to the next available
		audcall send_instrument_package ;  address
;ÖÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·
;º send MIDI								      º
;ÓÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ½
		lda	temp2
		cmp	#-2
if ne
		lda	#2			;stuff the fourth argument into
else
		lda	#1
endif
		sta	AUDRAM+2		;  sound RAM
		ldx	temp1			;get the directory index back
		lda	>snd_directory,x	;get offset of MIDI package
		tay				;  into Y
		lda	>2+snd_directory,x	;get bank of MIDI package in A
		ldx	#-1			;send it to the next available
		audcall send_music_package	;  address
;ÖÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ·
;º Done 								      º
;ÓÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ½
		plp
		rts

endproc


