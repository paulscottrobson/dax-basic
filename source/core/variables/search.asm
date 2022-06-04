; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		search.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		4th June 2022
;		Reviewed :	No
;		Purpose :	Search for a variable in the selected linked list.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;		Search for variable as set up by VariableInfo. Returns CC/UHL=Record success
;		CS if failed.
;
; ***************************************************************************************

VariableSearchList:
		ld 		hl,(VarHashListPtr)			; first link.
		;
		;		Follow pointer to next record, check if zero. First time round it is
		;		the address of the hash record
		;
_VSLLoop:
		ld_ind_hl 							; follow link
		;
		push 	hl 							; 24 bit check if zero ; requires NC and Z
		xor 	a
		adc 	hl,hl
		pop 	hl
		jr 		c,_VSLRecord				; shifted out
		scf 								; otherwise return carry if zero.
		ret 	z
_VSLRecord:
		;
		;		Check if they actually match. First do the hash.
		;
		ld 		a,(VarHash) 				; get the hash value of the variable
		cp 		(hl) 						; check against HL
		inc 	hl 							; points to link back
		jr 		nz,_VSLLoop
		;
		;		Now check the name
		;
		push 	hl 							; save next link on stack (e.g. record offset 1)
		inc 	hl 							; advance to the name address
		inc 	hl
		inc 	hl
		inc 	hl
		ld_ind_hl 							; HL now points to the record in program space.
		ld 		de,(VarNameStart)			; and DE to the start of the name.
		;
		;		Check individual characters
		;
_VSLCharacter:
		ld 		a,(de) 						; get next character
		cp 		IDENTIFIER_END 				; if end character check if both are.		
		jr 		nc,_VSLEndIdentifier
		cp 		(hl) 						; compare them
		inc 	hl 							; bump both character pointers
		inc 	de
		jr 		z,_VSLCharacter 			; go back if match. If not
		;
_VSLFailed:
		pop 	hl 							; pop the +1 link
		jr 		_VSLLoop 					; and loop round.
		;
		;		Found IDENTIFIER END at DE
		;		
_VSLEndIdentifier:
		ld 		a,(hl) 						; want non identifier character at HL too
		cp 		IDENTIFIER_END
		jr 		c,_VSLFailed 				; it's still an identifier, no match.
		;
		pop 	hl 							; get the +1 link
		dec 	hl 							; now start of record
		xor 	a 							; clear carry
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
		