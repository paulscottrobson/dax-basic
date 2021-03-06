; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		chr.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	chr$() implementation ; char code -> string
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;								Chr$() unary function
;
; ***************************************************************************************

Unary_Chr:	;; [chr]
		call 	CheckDollar
		call 	EvaluateIntegerTerm
		ld 		a,l 						; get character
		ld 		c,XTYPE_STRING				; return string at physical address HL
		ld 		hl,_UCBuffer+1 				; write EOS out
		ld 		(hl),13
		dec 	hl
		ld 		(hl),a
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
