; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		zmacros.inc
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Standard macros. All are prefixed with zm_
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;									16 bit arithmetic
;
;						HL/DE and HL/BC operations that are always 16 bit.
;								used to shift the HLHL values etc.
;
; ***************************************************************************************

#ifdef EZ80

#macro zm_add_hlde_16
	add.s 	hl,de
#endmacro

#macro zm_adc_hlde_16
	adc.s 	hl,de
#endmacro

#macro zm_add_hlhl_16
	add.s 	hl,hl
#endmacro

#macro zm_adc_hlhl_16
	adc.s 	hl,hl
#endmacro

#macro zm_sbc_hlde_16
	sbc.s 	hl,de
#endmacro

#else 									

#macro zm_add_hlde_16
	add 	hl,de
#endmacro

#macro zm_adc_hlde_16
	adc 	hl,de
#endmacro

#macro zm_add_hlhl_16
	add 	hl,hl
#endmacro

#macro zm_adc_hlhl_16
	adc 	hl,hl
#endmacro

#macro zm_sbc_hlde_16
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
