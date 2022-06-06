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
		ld 		de,9 						; point to the actual data.
		add 	hl,de 
		;
		; 		Check for arrays. IX points to token after identifier, HL to the array size.
		;
		ld 		a,(ix+0) 					; check next token
		cp 		KWD_LPAREN 					; if (
		call 	z,ArrayLookup 				; array access required.
		ld 		c,XTYPE_INTEGER 			; it's an integer
		set 	CIsReference,c 				; it's an integer reference in UHL.
		xor 	a 							; clear carry and return
		ret
		;
		; 		Variable is not found, can we autocreate it ?
		;
_FVNotFound:		
		ld 		a,(AllowAutoCreate) 		; is auto create on ?
		or 		a
		jr 		z,_FVFail
		ld 		a,(ix+0) 					; not allowed for arrays.
		cp 		KWD_LPAREN 		
		jr 		z,_FVFail
		ld 		hl,4 						; bytes to allocate for data.
		call 	VariableCreate 				; create a new variable.
		jr 		_FVExitReference 			; and exit with HL+9 as a reference

_FVFail:
		ld 		ix,(VarNameStart) 			; restore IX to start of variable name.
		scf
		ret

; ***************************************************************************************
;
;									 Array lookup
;
; ***************************************************************************************

ArrayLookup:
		push 	hl 							; save the array address on the stack.
		call 	EvaluateIntegerTerm 		; evaluate the array index.
		exx 								; check index in 0000-FFFF
		ld 		a,h
		or 		l
		exx
		jr 		nz,_ALBadValue  			; if so, it's a bad value
		ld 		de,$00 						; put HL into DE clearing UDE
		ld 		d,h
		ld 		e,l
		pop 	hl 							; get the array base back
		push 	hl
		ld_ind_hl 							; read the array index maximum
		xor  	a							; subtract maximum from index
		sbc 	hl,de
		jp 		c,_ALBadValue 				; if max < index then error
		ex 		de,hl 						; index back into HL
		inc 	hl 							; add 1, to skip over index count
		add 	hl,hl 						; x 4
		add 	hl,hl
		pop 	de 							; get array base back
		add 	hl,de 						; add offset to it
		ret

_ALBadValue:
		ERR_INDEX
		
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
