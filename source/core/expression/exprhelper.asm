; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		exprhelper.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Expression support functions
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
; 								Evaluate an integer term
;
; ***************************************************************************************

EvaluateIntegerTerm:
		call 	EvaluateTerm
		call 	DeReference
		bit 	CIsString,c
		ret 	z
		jp 		TypeMismatch

; ***************************************************************************************
;
; 								Evaluate a string term
;
; ***************************************************************************************

EvaluateStringTerm:
		call 	EvaluateTerm
		call 	DeReference
		bit 	CIsString,c
		ret 	nz
		jp 		TypeMismatch

; ***************************************************************************************
;
; 						Evaluate and dereference an expression
;
; ***************************************************************************************

EvaluateValue:
		call 	EvaluateAtPrecedence0
		jp 		Dereference

; ***************************************************************************************
;
; 									Evaluate a number
;
; ***************************************************************************************

EvaluateInteger:
		call 	EvaluateValue
		bit 	CIsString,c 				; check string bit is clear
		ret 	z
		jp 		TypeMismatch

; ***************************************************************************************
;
; 									Evaluate an 8 bit integer
;
; ***************************************************************************************

Evaluate8BitInteger:
		call 	EvaluateInteger
		exx  								; check if upper 3 bytes zero
		ld 		a,h
		or 		l
		exx 	
		or 		h
		jp 		nz,BadValue
		ld 		a,l 						; return integer in A
		ret
		
; ***************************************************************************************
;
; 									Evaluate a string
;
; ***************************************************************************************

EvaluateString:
		call 	EvaluateValue
		bit 	CIsString,c 				; check string bit.
		jp 		z,TypeMismatch 				; clear, type mismatch.
		ret

; ***************************************************************************************
;
; 								Return 8/16 bit constant
;
; ***************************************************************************************

Return8BitConstant:
		ld 		hl,$0000 					; put A into HL
		ld 		l,a
Return16BitConstant:
		exx 								; clear HL'
		ld 		hl,0
		exx
		ld 		c,XTYPE_INTEGER 			; return integer value.
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
