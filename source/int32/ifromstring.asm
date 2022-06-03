; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		ifromstring.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Convert string to integer.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;			Convert string at (BC) base A (-ve = sign) to number at HL'HL
;			Return first 'bad' character in A, Z flag set if EOS.
;
; ***************************************************************************************

Int32FromString:
 		push 	bc 							; save BC on stack
		exx 								; push DE'DE on the stack
		push 	de
		exx
		push 	de

		ld 		hl,$0000 					; zero HL'HL the result and the DE'DE
		ld 		de,$0000
		exx
		ld 		hl,$0000
		ld 		de,$0000
		exx

		ld 		e,a 						; base in E
		bit 	7,a 						; base -ve e.g. do it signed
		jr 		z,_I32FSNotSigned
		neg 		 						; fix up the base
		ld 		e,a 						; save in E.
		;
		ld 		a,(bc) 						; push first character on the stack.
		push 	af
		cp 		'-' 						; is it a minus ?
		ld 		a,e 						; restore base in A
		jr 		nz,_I32FSMain 				; (the compare above)
		inc 	bc 							; skip over it and start scanning
		jr 		_I32FSMain
_I32FSNotSigned:		
		push 	hl 							; this is a dummy first char, will be zero.
		;
		; 		Main conversion loop.
		; 		
_I32FSMain:		
		ld 		a,(bc) 						; get next character
		cp 		96 							; simple but sufficient L->U
		jr 		c,_I32FSNotLower
		sub 	32
_I32FSNotLower:
		cp 		'0' 						; check in range
		jr 		c,_I32FSExit
		cp 		'9'+1
		jr 		c,_I32FSOkay
		cp 		'A'
		jr 		c,_I32FSExit
		cp 		'F'+1
		jr 		nc,_I32FSExit
		sub 	7 							; hex->decimal mod.
_I32FSOkay:
		sub 	'0' 						; now should be 0-15
		cp 		e 							; fail if >= base
		jr 		nc,_I32FSExit 
		inc 	bc 							; consume character
		push 	de 							; save DE, containing base on stack.
		push 	af 							; save additive on stack
		call 	Int32Multiply 				; result *= base
		pop 	af 							; additive in DE
		ld 		e,a
		call 	Int32Add 					; and add it.
		pop 	de 							; restore DE containing base.
		jr 		_I32FSMain 					; and go round the loop again.

_I32FSExit:
		pop 	af 							; get sign back
		cp 		'-' 						; if -ve negate result
		call 	z,Int32Negate
		ld 		a,(bc) 						; get fail character
		pop 	de 							; restore DE'DE BC
		exx
		pop 	de
		exx
		pop 	bc
		cp 		$0D 						; ends in CR ?
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
