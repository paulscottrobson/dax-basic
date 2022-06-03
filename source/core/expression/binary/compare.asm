; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		compare.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Comparison code
;
; ***************************************************************************************
; ***************************************************************************************

#macro compare_equals(n)
		call 	CompareBaseCode
		cp 		n
		jr 		z,UnaryInt32True
		jr 		UnaryInt32False
#endmacro

#macro compare_not_equals(n)
		call 	CompareBaseCode
		cp 		n
		jr 		nz,UnaryInt32True
		jr 		UnaryInt32False
#endmacro

; ***************************************************************************************
;
; 								Return True/False
;
; ***************************************************************************************

UnaryInt32True:	
		ld 		a,255
		jr 		_Int32Logical
UnaryInt32False: 
		xor 	a
_Int32Logical:
		ld 		l,a 						; copy A to H L H' L'
		ld 		h,a
		exx
		ld 		l,a
		ld 		h,a
		exx
		ld 		c,XTYPE_INTEGER 			; return as integer
		ret

; ***************************************************************************************
;
; 										> = < (compare == value)
;
; ***************************************************************************************

ALUCompareEqual: 			;; [=]
		compare_equals(0)

ALUCompareLess: 			;; [<]
		compare_equals($FF)

ALUCompareGreater: 			;; [>]
		compare_equals(1)

; ***************************************************************************************
;
; 										> = < (compare <> value)
;
; ***************************************************************************************

ALUCompareNotEqual: 		;; [<>]
		compare_not_equals(0)

ALUCompareLessEqual: 		;; [<=]
		compare_not_equals(1)

ALUCompareGreaterEqual: 	;; [>=]
		compare_not_equals($FF)

; ***************************************************************************************
;
; 							Compare two values, return $FF,0,1
;
; ***************************************************************************************

CompareBaseCode:
		call 	DereferenceBoth 			; dereference both L & R

		ld 		a,b 						; check if both string.
		and 	c
		bit 	CIsString,a 
		jp 		nz,StringCompare

		ld 		a,b 						; check if either is string
		or 		c
		bit 	CIsString,a 
		jp 		z,Int32Compare 				; if not do as integer

		ERR_BADTYPE 						; trying to do int<str>comparison
;
;		Compare (HL) - (DE), String comparison.
;
StringCompare:
		ld 		a,(de) 						; note compares are backwards
		cp 		(hl)
		jr 		c,_SCGreater 				; so < returns +1
		jr 		nz,_SCLess
		inc 	de 							; keep going, <$20 match.
		inc 	hl
		cp 		' '
		jr 		nc,StringCompare
		ret

_SCLess:
		ld 		a,$FF
		ret
_SCGreater:
		ld 		a,1
		ret

		ERR_TODO()

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
