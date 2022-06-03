; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		idivide.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Divide HL'HL by DE'DE and variants
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;								Unsigned integer divide
;
; ***************************************************************************************

Int32UDivide:
		scf
		jp 		_I32UnsignedDivide		

; ***************************************************************************************
;
;							Signed integer divide/Modulus
;
; ***************************************************************************************

Int32SDivide:
		scf
		jr 		_I32SDivide
Int32Modulus:
		xor 	a
_I32SDivide:
		ex 		af,af' 						; push AF'
		push 	af
		ex 		af,af'

		push 	de 							; push DE'DE as we might remove sign
		exx
		push 	de
		exx

		push 	af 							; save flag (CS Divide, CC Modulus) on stack.
		xor 	a 							; clear sign count.
		call 	_I32CheckHLSignSwap
		call 	_I32CheckHLSignSwap
		ex 		af,af' 						; save count in AF'
		pop 	af 							; get/save function flag
		push 	af
		call 	_I32UnsignedDivide 			; do the unsigned divide or modulus
		pop 	af 							; get function back
		jr 		nc,_I32SDExit 				; if modulus don't reapply the sign
		ex 	 	af,af' 						; get count
		bit 	0,a 						; if even do not reapply sign
		call 	nz,Int32Negate 				; if odd, reapply sign.
_I32SDExit:
		exx 								; restore DE'DE
		pop 	de
		exx
		pop 	de
		pop 	af 							; restore AF'	
		ex 		af,af'
		ret


_I32CheckHLSignSwap:
		exx 								; check if HL'HL is negative.
		bit 	7,h
		exx
		jr 		z,_I32CHSPositive 		
		;
		add 	a,1 						; if so increment counter in A
		push 	af  						; negate HL'HL preserving A
		call 	Int32Negate 				
		pop 	af
_I32CHSPositive:
		exx 	 							; swap HL'HL and DE'DE
		ex 		de,hl
		exx		
		ex 		de,hl
		ret

; ***************************************************************************************
;
;		Divide HL'HL by DE'DE. Preserves BC'BC and DE'DE. If CS return carry else 
;		return the modulus. Always returns modulus LSB in A.
;
; ***************************************************************************************

_I32UnsignedDivide:
		push 	bc 							; save BC'BC and DE'DE
		push 	de
		exx
		push 	bc
		push 	de 							
		exx

		push 	af 							; save CS for exit check

		ld 		a,d 						; check if DE = 0
		or 		e
		exx
		or 		d
		or 		e
		exx
		jp 		z,Int32DivZeroHandler 		; if so, error.


		ld 		b,h 						; put Q (divisor) in BC, clear A (result)
		ld		c,l
		ld 		hl,$0000
		exx
		ld 		b,h
		ld		c,l
		ld 		hl,$0000
		exx

		ld 		a,32 						; loop counter
_I32DivideLoop:
		push 	af

		sla 	c 							; shift AQ left : A = HL'HL Q = BC'BC
		rl 		b
		exx
		rl 		c
		rl 		b
		exx
		rl 		l
		rl 		h
		exx
		rl 		l
		rl 		h
		exx

		call 	Int32Subtract 				; A = A - M
		jr 		c,_I32Borrow 				; borrow, failed to subtract.

		inc 	c 							; set the low bit of BC'BC
		jr 		_I32Next

_I32Borrow:
		call 	Int32Add 					; A = A + M
_I32Next:
		pop 	af
		dec 	a
		jr 		nz,_I32DivideLoop		 	; result is in BC'BC, remainder in HL'HL

		pop 	af 							; CS if divide, CC if modulus

		ld 		a,l 						; A has LSB of modulus.
		jr 		nc,_I32Modulus1

		ld  	h,b
		ld 		l,c
		exx
		ld  	h,b
		ld 		l,c
		exx
_I32Modulus1:		
		exx 								; restore BC'BC and DE'DE
		pop 	de
		pop 	bc
		exx
		pop 	de
		pop 	bc
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
		