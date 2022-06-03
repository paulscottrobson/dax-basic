; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		expression.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	None
;		Purpose :	Expression evaluation (see evaluate.py)
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
; 						Evaluate expression at IX, precedence level A/0
;
; ***************************************************************************************

EvaluateAtPrecedence0:
		xor 	a 							; base level of precedence and fall through.
EvaluateAtPrecedence:
		push 	af  						; save precedence on stack	
		;
		; 		Get a term into C:HL'HL
		;
		call 	EvaluateTerm 				; get term
		;
		; 		Check if can calculate at this level. Check if a binary operator follows.
		;
		pop 	de 							; precedence level is now in D.
_EAPLoop:
		ld 		a,(ix+0) 					; get next token
		cp 		KWC_FIRST_BINARY	 		; check it is a binary operator and exit otherwise.
		ret 	c
		cp 		KWC_FIRST_UNARY
		ret 	nc
		;
		; 		Get the precedence.
		;
		push 	hl 							; want to use HL
		sub 	KWC_FIRST_BINARY 			; now indexed from zero
		ld 		hl,PrecedenceTable 			; make HL point to the table
		or 		l 							; table is aligned so this works using .block
		ld 		l,a
		ld 		e,(hl)  					; get the precedence
		pop 	hl 							; restore HL
		;
		;		Continue only if prec-level (in D) < operator-precedence (in E)
		;
		ld 		a,d 						; so exit otherwise.
		cp 		e
		ret 	nc

		;
		; 		Push C:HL'HL, Precedence information and operator on the stack.
		;
		push 	de 							; save precedence information.
		;
		ld 		a,(ix+0) 					; save binary operator
		push 	af
		;
		push 	bc 							; save BC (type is in C)
		exx 								; save HL'
		push 	hl
		exx 								
		push 	hl 							; save HL
		;
		inc 	ix 							; skip over binary operator.
		;
		; 		Evaluate the RHS which after this is in HL'HL info in B, left is on the stack.
		;
		ld 		a,e 						; evaluate at the operator precedence level.
		call 	EvaluateAtPrecedence 		; this goes into R
		;
		; 		Restore C:HL'HL off the stack, copying C'HL:HL => B'DE:DE
		;
		ld 		a,c 						; put the second part into A.

		ex 		de,hl 						; pop L back off the stack into HL'HL
		pop 	hl 							; swapping HL into DE
		exx
		ex 		de,hl
		pop 	hl
		exx
		pop  	bc 							; get the type into C
		ld 		b,a 						; B now contains DE'DE type.
		;
		; 		At this point, the left hand side is in C (type) HL'HL and the right hand side
		; 		is in B (type) DE'DE
		;
		pop 	af 							; get operator in A
		;
		; 		Call the binary operator in A.
		;
		push 	de
		push 	hl 							; save DE/HL
		dispatch(VectorsSet0) 				; routine address in DE
		pop 	hl 							; make HL'HL good, restore HL
		pop 	de 							; restore DE
		call 	JumpCode 					; call the routine set up in dispatch.
		;
		pop 	de 							; restore precedence into DE
		;
		jr 		_EAPLoop 					; and go round

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
