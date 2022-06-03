; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		str.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	str$() implementation ; int -> string
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;								Str$() unary function
;
; ***************************************************************************************

Unary_Str:	;; [str]
		call 	CheckDollar
		call 	EvaluateIntegerTerm 		; get an integer
		ld 		bc,_USBuffer 				; point to buffer.
		ld 		a,-10 						; convert signed base 10 int32
		call 	Int32ToString 				
		ld 		hl,_USBuffer 				; string address.
		ld 		c,XTYPE_STRING				; return string at physical address HL
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