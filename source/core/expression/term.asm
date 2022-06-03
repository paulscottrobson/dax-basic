; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		term.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Get a term into HL'HLC.
;
; ***************************************************************************************
; ***************************************************************************************

#macro double_hlhl 							; doubles HL'HL
		add_hlhl_16
		exx
		adc_hlhl_16
		exx
#endmacro

; ***************************************************************************************
;
; 								Evaluate a term into HL'HL C
;
; ***************************************************************************************
;
; 		Terms can be:
;
;			<integer> 			42 						not negative
;			&<hex-integer 		&2A 					unary function, but done by hand.
; 			"<text>"			"Hello, world!"			ASCIIZ string.
; 			$ ? ! - <term> 		!42 ?a -7 				special cases - unary functions which have
; 														binary equivalents so are handled differently
; 			<unary> 			len("Hello")			unary functions. Note that ( itself is a 
;														unary function, returning the value in parenthesis.
; 			identifier 			age 					No functions, so this will be a variable
; 														reference of some sort.
;
; ***************************************************************************************

EvaluateTerm:		
		ld 		c,XTYPE_INTEGER 			; set type to integer.
		exx
		ld 		hl,$0000 					; zero HL'HL
		exx
		ld 		hl,$0000		
		;
		ld 		a,(ix+0) 					; get first character.
		cp 		STRING_MARKER 				; is it the string marker ($3F)
		jr 		z,_ETStringMarker 			; if so, do the string code.
		jp 		c,_ETVariable 				; if so it is (at present) a variable $00-$2F
		bit 	7,a 						; is it a token $80-$FF
		jp 		nz,_ETFoundKeyword 
		;
		; 		Remaining option is $40-$7F, which is an integer constant.
		;
_ETIntegerConstant:
		;
_ETIntegerLoop:		
		ld 		a,(ix+0)
		and 	$3F 						; get the actual digit part, 6 bits
		or 		l 							; or into L
		ld 		l,a
		inc 	ix 							; look at next character.
		ld 		a,(ix+0) 					; get next character
		add 	a,$80 						; this will map $40-$7F to $C0-$FF
		cp 		$C0 						; so if < $C0 wasn't $40-$7F
		ret 	c

		double_hlhl 						; multiply HL'HL by 64. Bit wasteful but quickest.
		double_hlhl  						; (could have special code for first time)
		double_hlhl
		double_hlhl
		double_hlhl
		double_hlhl

		jr 		_ETIntegerLoop 				; and get the next part of the integer if there is one.
		;
		; 		Found the $3F string marker.
		;
_ETStringMarker:		
		inc 	ix 							; skip string marker
		inc 	ix 							; skip length, IX now points to ASCIIZ string.
		push 	ix 							; put address in UHL
		pop 	hl
		ld 		de,$0000
		ld 		e,(ix-1) 					; get length to add into DE.
		add 	ix,de
		inc 	ix 							; and skip the zero terminating byte.
		ld 		c,XTYPE_STRING 				; mark it as a string object, address in UHL
		ret
		;
		; 		Found a keyword $80-$FF, check for unary function, then check for & and then the dual use operators.
		;
_ETFoundKeyword:
		inc 	ix 							; skip token, which is in A.
		cp 		KWC_FIRST_UNARY 			; check if level 0 unary function
		jr 		c,_ETNotUnaryFunction0
		cp 		KWC_FIRST_NORMAL 
		jr 		nc,_ETNotUnaryFunction0
		;
		;		Unary group 0
		;
		dispatch(VectorsSet0) 				; set up call address
		jp 		JumpCode 					; and go there.

_ETNotUnaryFunction0:	
		cp 		KWD_MINUS 					; is it -term ?
		jr 		nz,_ETCheckIndirection
		;
		; 		- term
		;
		call 	EvaluateTerm 				; evaluate term
		call 	NegateHLHL 					; negate HLHL type defpendent.
		ret
		;
		;		! ? $ indirection check
		;
_ETCheckIndirection:	
		cp 		KWD_QMARK 					; check if ? ! $
		jr 		z,_ETIndirection
		cp 		KWD_DOLLAR
		jr 		z,_ETIndirection
		cp 		KWD_PLING
		jp 		nz,SyntaxError 				; give up otherwise.
		;
		; 		! ? $ indirection
		;
_ETIndirection:
		push 	af 							; check type of indirection.
		call 	EvaluateTerm 				; get reference value to HL'HL
		call 	DRConvertHLHLtoAddress 		; make it a real physical address in UHL.
		pop 	af 							; get type back
		ld 		c,XTYPE_INTEGER 			; integer ?
		set 	CIsReference,c
		cp 		KWD_PLING
		ret 	z
		set 	CIsByteReference,c 			; byte ?
		cp 		KWD_QMARK
		ret 	z
		ld 		c,XTYPE_STRING 				; otherwise string address.
		ret
		;
		; 		Found an identifier.
		;
_ETVariable:
		ERR_TODO
		ERR_UNKNOWNVAR 						; unknown variable
		
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
