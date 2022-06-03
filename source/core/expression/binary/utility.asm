; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		utility.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Basic mathematics utilities
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;							   Swap B:DE'DE and C:HL'HL
;
; ***************************************************************************************

SwapHLDE:
			ex 		de,hl 					; swap DE'DE and HL'HL
			exx
			ex 		de,hl
			exx
			ld 		a,b 					; swap B & C
			ld 		b,c
			ld 		c,a
			ret

; ***************************************************************************************
;
;						Dereference B:DE'DE and C:HL'HL
;
; ***************************************************************************************

DereferenceBoth:
			bit 	CIsReference,c 			; does C:HL'HL need dereferencing ?
			call 	nz,Dereference 			; Deref C:HL'HL
			bit 	CIsReference,b 			; does DE'DE need dereferencing ?		
			ret 	z
			call 	SwapHLDE 				; swap HL and DE over.
			call 	Dereference 			; dereference what was B:DE'DE
			call 	SwapHLDE 				; swap HL and DE over.
			ret

; ***************************************************************************************
;
;							Type Check C:HL'HL and negate it
;
; ***************************************************************************************

NegateHLHL:	
			bit 	CIsString,c 			; is it a string ?
			jp 		nz,TypeMismatch
			bit 	CIsReference,c 			; reference -> number.
			call 	nz,Dereference 			; if required.
			call 	Int32Negate
			ret