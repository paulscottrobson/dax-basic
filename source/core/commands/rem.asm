; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		rem.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Rem / ' command
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;							Comment command, can be ' or REM
;				Note for semantic consistency the comment is in a string.
;
; ***************************************************************************************

Command_REM: 	;; [rem]
Command_REM2: 	;; [']
		ld 		a,(ix+0) 					; check : EOL or a string follows
		inc 	ix
		cp 		KWD_COLON 					; exit if colon, e.g. end of command
		ret 	z
		cp 		KWC_EOL_MARKER 				; exit if end of line.
		ret 	z
		cp 		STRING_MARKER
		jp 		nz,SyntaxError
		;		
		ld 		de,$0000 					; length + 2 into DE (length, and NULL)
		ld 		e,(ix+0)
		inc 	de 
		inc 	de
		add 	ix,de 						; skip string
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
