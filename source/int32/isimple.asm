; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		isimple.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Simple 32 bit operations
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;								Add DE'DE to HL'HL
;
; ***************************************************************************************

Int32Add:
		zm_add_hlde_16 						; add DE to HL
		exx
		zm_adc_hlde_16 						; add DE' to HL'
		exx
		ret

; ***************************************************************************************
;
;								Sub DE'DE from HL'HL
;
; ***************************************************************************************

Int32Subtract:
		xor 	a 							; clear carry
		zm_sbc_hlde_16  					; subtract DE from HL
		exx
		zm_sbc_hlde_16 						; subtrace DE' from HL'
		exx
		ret

; ***************************************************************************************
;
;								And DE'DE into HL'HL
;
; ***************************************************************************************

Int32And:
		exx
		call 	_I32AndHLDE
		exx
_I32AndHLDE:		
		ld 		a,h
		and 	d
		ld 		h,a
		ld 		a,l
		and 	e
		ld 		l,a
		ret

; ***************************************************************************************
;
;								Or DE'DE into HL'HL
;
; ***************************************************************************************

Int32Or:
		exx
		call 	_I32OrHLDE
		exx
_I32OrHLDE:		
		ld 		a,h
		or 		d
		ld 		h,a
		ld 		a,l
		or 		e
		ld 		l,a
		ret

; ***************************************************************************************
;
;								Xor DE'DE into HL'HL
;
; ***************************************************************************************

Int32Xor:
		exx
		call 	_I32XorHLDE
		exx
_I32XorHLDE:		
		ld 		a,h
		xor 	d
		ld 		h,a
		ld 		a,l
		xor 	e
		ld 		l,a
		ret

; ***************************************************************************************
;
;								 Check if HL'HL zero
;
; ***************************************************************************************

Int32Zero:
		exx
		ld 		a,l
		or 		h
		exx
		or 		l
		or 		h
		ret

; ***************************************************************************************
;
;								Compare HL'HL vs DE'DE
;
; ***************************************************************************************

Int32Compare:
		push 	hl 							; save HL
		xor 	a 							; clear carry
		zm_sbc_hlde_16  					; subtract DE from HL
		exx
		push 	hl 							; save HL'
		zm_sbc_hlde_16 						; subtrace DE' from HL'
		;
		ld 		b,h 						; save most significant byte in B
		jp 		po,_I32CNoOverflow  		; on overflow flip B bit 7 (compare signed trick)
		ld 		a,b
		xor 	$80
		ld 		b,a
_I32CNoOverflow:
		ld 		a,h 						; work out if result is zero
		or 		l
		exx 
		or 		h
		or 		l
		jr 		z,_I32NotPos 				; if zero, return zero.
		;
		exx 								; is B' -ve 	
		bit 	7,b
		exx
		ld 		a,1 						; if B' +ve return 1.
		jr 		z,_I32NotPos
		ld 		a,$FF
_I32NotPos:
		exx
		pop 	hl 							; restore HL'
		exx
		pop 	hl 							; restore HL
		or 		a 							; set flags and exit		
		ret

; ***************************************************************************************
;
;										Negate HL'HL
;
; ***************************************************************************************

Int32Negate:
		xor 	a
		call 	_I32NSubtract
		exx
		call 	_I32NSubtract
		exx
		ret
_I32NSubtract:
		push 	de
		ex 		de,hl
		ld 		hl,$0000
		zm_sbc_hlde_16		
		pop 	de
		ret
		
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
		