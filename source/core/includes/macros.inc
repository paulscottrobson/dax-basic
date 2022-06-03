; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		macros.inc
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Standard macros.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;								Set Z flag if HL'HL zero
;
; ***************************************************************************************

#macro checkzero
		ld 		a,h
		or 		l
		exx
		or 		h
		or 		l
		exx
#endmacro

; ***************************************************************************************
;
;								Indirect load of HL to HL, DE to HL
;
; ***************************************************************************************

#ifdef EZ80
#macro ld_ind_hl
	ld 		hl,(hl)
#endmacro
#else
#macro ld_ind_hl
	ld 		a,(hl)
	inc 	hl
	ld 		h,(hl)
	ld 		l,a
#endmacro
#endif

; ***************************************************************************************
;
; 				Indirect store of DE to HL  and increment HL by four.
;
; ***************************************************************************************

#ifdef EZ80
#macro st_de_hl_ind_incr
	ld 		(hl),de
	inc 	hl
	inc 	hl
	inc 	hl
	inc 	hl
#endmacro
#else
#macro st_de_hl_ind_incr
	ld 		(hl),e
	inc 	hl
	ld 		(hl),d
	inc 	hl
	inc 	hl
	inc 	hl
#endmacro
#endif

; ***************************************************************************************
;
;									Break Aquarius or TI84/EZ80
;
; ***************************************************************************************
	
#ifdef EZ80
#macro debug 
	push 	af
	ld 		a,2
	ld 		($FFFFFF),a
	pop 	af
#endmacro
#else
#macro debug 
	halt
#endmacro
#endif

; ***************************************************************************************
;
;								Output address as 16/32 bit depending
;									  (used in vector tables)
;
; ***************************************************************************************

#ifdef EZ80
#macro addr(a)
	.dw 	(a) & $FFFF,(a) >> 16
#endmacro
#else
#macro addr(a)
	.dw 	(a)
#endmacro
#endif

; ***************************************************************************************
;
;									16 bit arithmetic
;
;						HL/DE and HL/BC operations that are always 16 bit.
;								used to shift the HLHL values etc.
;
; ***************************************************************************************

#ifdef EZ80

#macro add_hlde_16
	add.s 	hl,de
#endmacro

#macro adc_hlde_16
	adc.s 	hl,de
#endmacro

#macro add_hlhl_16
	add.s 	hl,hl
#endmacro

#macro adc_hlhl_16
	adc.s 	hl,hl
#endmacro

#macro sbc_hlde_16
	sbc.s 	hl,de
#endmacro

#else 									

#macro add_hlde_16
	add 	hl,de
#endmacro

#macro adc_hlde_16
	adc 	hl,de
#endmacro

#macro add_hlhl_16
	add 	hl,hl
#endmacro

#macro adc_hlhl_16
	adc 	hl,hl
#endmacro

#macro sbc_hlde_16
	sbc 	hl,de
#endmacro

#endif

; ***************************************************************************************
;
;									Changes and Updates
;
; ***************************************************************************************
;
;		Date			Notes
;		==== 			=====
;
; ***************************************************************************************
