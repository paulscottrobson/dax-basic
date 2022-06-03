; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		random.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Returns random 32 bit integer 
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;								Random unary function
;
; ***************************************************************************************

Unary_Random:	;; [rnd]
		debug
		call 	EvaluateIntegerTerm 		; get the seed/range value.
		exx 								; is it -ve
		bit 	7,h
		exx
		jr 		z,_URDontSeed 				; if so.
		ld 		(RandomSeed),hl 			; update random seed with HL'HL
		exx
		ld 		(RandomSeed+4),hl
		exx
		ld 		c,XTYPE_INTEGER 			; and return new seed.
		ret
_URDontSeed:		

		call	Int32Zero 					; RND(0) doesn't work, no floats.
		jr 		z,_URFail
		push 	hl 							; save range on stack.
		exx
		push 	hl
		exx
		;
		call 	URandomHL 					; get random HL'HL
		exx
		call 	URandomHL
		res 	7,h 						; force it to be +ve
		exx
		;
		exx 								; restore range.
		pop 	de
		exx
		pop 	de
		;
		call 	Int32Modulus 				; now in range 0->n-1 so bump it.
		inc 	hl 							; won't bother with MSB for this
		ld		c,XTYPE_INTEGER
		ret
_URFail:
		ERR_BADVALUE
; ***************************************************************************************
;
; 									Push RNG off zero
;
; ***************************************************************************************

UnaryRandomInitialise:
		ld 		b,16 						; call it 16 times, so it's away from zero.
_URILoop:
		push 	bc
		call 	URandomHL
		pop 	bc
		djnz 	_URILoop
		ret

; ***************************************************************************************
;
;							16 bit random number generator
;
;		from https://wikiti.brandonw.net/index.php?title=Z80_Routines:Math:Random
;		Actual author unspecified.
;
; ***************************************************************************************

URandomHL:
	    ld 		hl,(RandomSeed)
	    ld 		de,(RandomSeed+4)
	    ld 		b,h
	    ld 		c,l
	    add 	hl,hl \ rl e \ rl d
	    add 	hl,hl \ rl e \ rl d
	    inc 	l
	    add 	hl,bc
	    ld 		(RandomSeed),hl
	    ld 		hl,(RandomSeed+4)
	    adc 	hl,de
	    ld 		(RandomSeed+4),hl
	    ex 		de,hl
	    ld 		hl,(RandomSeed+8)
	    ld 		bc,(RandomSeed+12)
	    add 	hl,hl \ rl c \ rl b
	    ld 		(RandomSeed+12),bc
	    sbc 	a,a
	    and 	%11000101
	    xor 	l
	    ld 		l,a
	    ld 		(RandomSeed+8),hl
	    ex 		de,hl
	    add 	hl,bc
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
