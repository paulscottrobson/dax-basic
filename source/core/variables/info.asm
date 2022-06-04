; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		info.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		4th June 2022
;		Reviewed :	No
;		Purpose :	Get information about variable at IX
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;		Get information about variable at IX. On exit IX points to the next character
; 		after the identifier.
;
; ***************************************************************************************

VariableInformation:
		ld 		(VarNameStart),ix 			; save start.
		;
		; 		Calculate hash, find end.
		;
		ld 		b,0 						; build the hash in B.
_VICalculateHash:
		ld 		a,(ix+0) 					; look at character
		cp 		IDENTIFIER_END 				; not an identifier character.
		jr 		nc,_VIHashDone 				; if so, reached the end.
		add 	a,b 						; add to hash
		rrca 								; rotate byte twice right
		rrca
		ld 		b,a 						; update hash
		inc 	ix 							; next character
		jr 		_VICalculateHash				
		;
_VIHashDone:
		ld 		a,b 						; write hash byte out
		ld 		(VarHash),a
		;
		; 		Calculate the hash table address pointer.
		;		
		and 	HashTableSize-1 			; put into range 0..HashTableSize-1
		add 	a,a 						; multiply by 4
		add 	a,a
		ld 		de,$0000 					; put in DE
		ld 		e,a
		;
		ld 		hl,HashTableBase 			; add to hash table base.
		add 	hl,de
		;
		ld 		a,(ix+0) 					; followed by a ( ?
		cp 		KWD_LPAREN 					; if so
		jr 		nz,_VINotArray 				; it's an array.
		ld 		de,HashTableSize * 4 		; so advance to the second block which is
		add 	hl,de 						; for hash tables
_VINotArray:
		ld 		(VarHashListPtr),hl 		; this is the address of the first link in the list (or NULL)
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

