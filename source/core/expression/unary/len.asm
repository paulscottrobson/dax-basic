; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		len.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	None
;		Purpose :	String Length
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;								Len unary function
;
; ***************************************************************************************

Unary_Len:	;; [len]
		call	EvaluateStringTerm			; Get string address into UHL
		ex 		de,hl 						; put in DE
		call 	UnaryInt32False 			; zero HL'HL
_ULCount:
		ld 		a,(de) 						; next char
		cp 		$20 						; if < space return.
		ret 	c
		inc 	hl 							; bump count and pointer
		inc 	de
		jr 		_ULCount 					; go round again.

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
		