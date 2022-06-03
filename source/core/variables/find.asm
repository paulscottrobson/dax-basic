; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		find.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Find a variable.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;		Find variable. If found, return address in (U)HL, type in C and carry clear.
; 		variable information at (IX)
;
;		If not found, create the variable and return as above, otherwise return CS.
;		Don't autocreate arrays.
;
; ***************************************************************************************

FindVariable:
		debug
		ld 		a,(ix+0)					; get first character
		cp 		IDENTIFIER_END 				; check it is an identifier reference.
		jp 		nc,SyntaxError 		

		ld 		a,(ix+1) 					; look at next character, if that is an
		cp 		IDENTIFIER_END 				; integer_type then this is a single letter
		jr 		c,_FVNotSimple 				; integer.

		ld 		hl,(StandardIntegers) 		; point UHL to standard ints on 128 byte boundary
		ld 		a,(ix+0) 					; get the identifier ID
		add 	a,a 						; x4
		add 	a,a
		or 		l 							; Or into address as on 128 byte boundary
		ld 		l,a 						; UHL now points to the variable.
		ld 		c,XTYPE_INTEGER 			; it's an integer
		set 	CIsReference,c 				; it's an integer reference in UHL.
		inc 	ix 							; skip over identifier marker
		inc 	ix
		xor 	a 							; clear carry and return
		ret
		;
		;		Not a standard simple variable.
		;
_FVNotSimple:
		scf
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
