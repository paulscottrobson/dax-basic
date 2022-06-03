; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		makestring.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Make string from constant address
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;								Str$() unary function
;
; ***************************************************************************************

Unary_MkStr:	;; [$]
		call 	EvaluateIntegerTerm 		; get an integer
		call 	DRConvertHLHLToAddress 		; make to an actual address in (U)HL
		ld 		c,XTYPE_STRING 				; return as string
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
