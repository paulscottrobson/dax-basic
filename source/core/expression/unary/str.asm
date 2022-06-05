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
		ld 		a,(ix+0) 					; push next character ^ KWD_TILDE on stack.
		xor		KWD_TILDE
		push 	af
		jr 		nz,_USNotHex 				; if it was a tilde, ski it.
		inc 	ix
_USNotHex:		
		call 	EvaluateIntegerTerm 		; get an integer
		ld 		bc,_USBuffer 				; point to buffer.
		pop 	af 							; get tilde flag back (Z set)
		ld 		a,-10 						; convert signed base 10 int32
		jr 		nz,_USNotHex2
		ld 		a,16
_USNotHex2:		
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
