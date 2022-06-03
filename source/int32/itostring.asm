; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		itostring.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Convert integer to string 
;
; ***************************************************************************************
;
; 			Convert HL'HL to ASCIIZ string at BC in base A. A = -ve => Signed
;
; ***************************************************************************************

Int32ToString:
		push 	bc 							; save string start
		push 	de 							; save DE'DE and HL'HL, zero DE
		push 	hl
		ld	 	de,$0000
		exx
		push 	de
		push 	hl
		ld 		de,$000
		exx
		ld 		e,a 						; put base in E
		;
		bit 	7,a 						; -ve base => signed
		jr 		z,_I32TSNotNegative
		neg 								; negate base and put in E
		ld 		e,a
		;
		exx 								; is it -ve ?
		bit 	7,h
		exx
		jr 		z,_I32TSNotNegative
		;
		call 	Int32Negate 				; yes, negate HL'HL
		;
		ld 		a,'-' 						; output a leading minus.
		ld 		(bc),a
		inc 	bc
_I32TSNotNegative:	
		call 	_I32RecursiveConvert 		; convert the integer to a string		
_I32TSExit:
		xor 	a  							; write the end of string code
		ld 		(bc),a 

		exx 								; restore registers and exit.
		pop 	hl
		pop 	de
		exx
		pop 	hl
		pop 	de
		pop 	bc
		ret

_I32RecursiveConvert:
		call 	Int32UDivide 				; unsigned divide. Mod is in A
		push 	af 							; save remainder
		call 	Int32Zero		 			; check result is non zero
		call 	nz,_I32RecursiveConvert 	; if non zero keep dividing
		pop 	af 							; restore remainder
		cp 		10 							; convert 10+ to hex
		jr 		c,_I32NotHex
		add 	a,7
_I32NotHex:
		add 	a,48
		ld 		(bc),a 						; write out to buffer
		inc 	bc
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
