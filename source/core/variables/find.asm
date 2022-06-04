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
		ld 		a,(ix+0)					; get first character
		cp 		IDENTIFIER_END 				; check it is an identifier reference.
		jp 		nc,SyntaxError 		

		ld 		a,(ix+1) 					; look at next character, if that is an
		cp 		IDENTIFIER_END 				; integer_type then this is a single letter
		jr 		c,_FVNotSimple 				; integer.
		cp 		KWD_LPAREN 					; could also be a(
		jr 		z,_FVNotSimple
		;
		; 		Code for A-Z fixed integers.
		;
		ld 		hl,(StandardIntegers) 		; point UHL to standard ints on 128 byte boundary
		ld 		a,(ix+0) 					; get the identifier ID
		add 	a,a 						; x4
		add 	a,a
		or 		l 							; Or into address as on 128 byte boundary
		ld 		l,a 						; UHL now points to the variable.
		ld 		c,XTYPE_INTEGER 			; it's an integer
		set 	CIsReference,c 				; it's an integer reference in UHL.
		inc 	ix 							; skip over identifier 
		xor 	a 							; clear carry and return
		ret
		;
		;		Not a standard simple variable.
		;
_FVNotSimple:
		call 	VariableInformation 		; get information about the variable.
		call 	VariableSearchList 			; search the linked list
		jr 		c,_FVNotFound  				
		;
		;		Found variable. Address of record is in HL.
		;
_FVExitReference:		
		ld 		de,10 						; point to the actual data.
		add 	hl,de 
		;
		; 		TODO: Array check code.
		;
		ld 		c,XTYPE_INTEGER 			; it's an integer
		set 	CIsReference,c 				; it's an integer reference in UHL.
		xor 	a 							; clear carry and return
		ret
		;
		; 		Variable is not found, can we autocreate it ?
		;
_FVNotFound:		
		debug

		ld 		a,(AllowAutoCreate) 		; is auto create on ?
		or 		a
		jr 		z,_FVFail
		ld 		a,(ix+0) 					; not allowed for arrays.
		cp 		KWD_LPAREN 		
		jr 		z,_FVFail
		ld 		hl,4 						; bytes to allocate for data.
		call 	VariableCreate 				; create a new variable.
		jr 		_FVExitReference 			; and exit with HL+10 as a reference

_FVFail:
		ld 		ix,(VarNameStart) 			; restore IX to start of variable name.
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
