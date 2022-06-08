; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		search.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th June 2022
;		Reviewed :	No
;		Purpose :	Search program for procedures
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;					Search program for procedure, procedure identifier at IX
;					returns line at HL, after identifier in IX / or error.
;
;					A very simple search which may actually be good enough.
;					Give consideration to a table w/index ? 
;
; ***************************************************************************************

SearchProcedure:
			ld 		c,(ix+0) 				; put the first character of the name into C.

			ld 		hl,(CodeAddress) 		; start of program space
			;
			;		Main loop. First we look for <DEF> <PROC> <1st Character>
			;
_SPLoop:	ld 		a,(hl) 					; is this the end of the program.
			or 		a
			jr 		z,_SPFail
			push 	hl 						; save start of line on the stack
			inc 	hl 						; skip over offset and line number.
			inc 	hl
			inc 	hl
			ld 		a,(hl) 					; check for DEF.
			cp 		KWD_DEF 				
			jr 		nz,_SPNext
			inc 	hl 				
			ld 		a,(hl) 					; check for PROC.
			cp 		KWD_PROC
			jr 		nz,_SPNext
			inc 	hl
			ld 		a,(hl) 					; check first character
			cp 		c
			jr 		z,_SPFullCheck 			; no, do full check.
			;
			;		Advance to next entry.
			;			
_SPNext:	pop 	hl 						; start of line
			ld 		de,0 					; offset into UDE
			ld 		e,(hl)
			add 	hl,de 					; add it and go round again.
			jr 		_SPLoop
			;
			;		Full check. IX points to the name in the caller, DE to HL to the name in the
			; 		DEF PROC line.
			;		
			;		Already know the first characters match
			;
_SPFullCheck:
			push 	ix 						; save position of the 1st character of caller on the stack.			
_SPCheckLoop:
			inc 	ix 						; look at next character.
			inc 	hl
			ld 		a,(ix+0) 				; get first in caller.
			cp 		IDENTIFIER_END 			; end of identifier ?
			jr 		nc,_SPCheckBothEnd 		; check both end here.
			cp 		(hl) 					; matches callee ?
			jr 		z,_SPCheckLoop 			; go round again keep checking.
			;
			;		Full check failed.
			;
_SPFullCheckFailed:			
			pop 	ix 						; restore the original caller position
			jr 		_SPNext 				; do the next line.
			;
			;		End of identifier in caller, check end of identifier in callee
			;
_SPCheckBothEnd:
			ld 		a,(hl) 					; if the character in callee is an identifier	
			cp 		IDENTIFIER_END 			; the names do not match.
			jr 		c,_SPFullCheckFailed			
			;
			;	 	We found it.
			;
			pop 	bc  					; throw away the original caller position
			pop 	de 						; DE is the start of the line it is on
			ret 							; HL is the character after the identifier.

_SPFail: 									; come here when not found.
			ERR_PROC			

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
