; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		run.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Run command
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;										RUN command
;
; ***************************************************************************************

Command_RUN: 	;; [run]
		call 	Command_CLEAR 				; clear all variables, stack

		ld 		ix,(CodeAddress) 			; start from this line, e.g. the first line.
		ld 		(RunStackPtr),sp 			; save Z80 SP
		xor 	a
		ld 		(AllowAutoCreate),a 		; clear the flag allowing auto-create of simple variables.
		;
		; 		New line at IX.
		;
CRNewLine:
		ld 		(CurrentLineStart),ix 		; mark the current line.
		;
		ld 		a,(ix+0) 					; look at the offset, if zero end of program.
		or 		a
		jp 		z,Command_END 				; if so, do an END, warm start
		;
		inc 	ix 							; point to first token, skip length, line#
		inc 	ix  						; (line nos are just for sorting and backwards compatibility)
		inc 	ix
		;
		; 		New command at IX
		;
_CRNewCommand:	
		ld 		a,(ix+0)					; get token
		or 		a 							; set flags, checking if 80-FF, e.g. a keyword
		jp 		p,_CRAssignmentHandler 		; if 00-7F can only be a LET default (A=42)
		;
		cp 		KWC_FIRST_NORMAL 			; not a binary/unary operator.
		jr  	nc,_CRDoCommand
		cp 		KWC_FIRST_BINARY
		jp 		nc,_CRAlternateLets
		;
_CRDoCommand:		
		dispatch(VectorsSet0)   			; Set up JumpCode
		inc 	ix 							; skip over token.
		call 	JumpCode 					; call the routine.
		jr 		_CRNewCommand 				; and loop back.
		;
		; 		Do CALL (HL)
		;
		;
		;		Check for alternate lets $x !x ?x which are all binary and/or unary operators
		;		
_CRAlternateLets:		
		cp 		KWD_PLING
		jr 		z,_CRAssignmentLet
		cp 		KWD_QMARK
		jr 		z,_CRAssignmentLet
		cp 		KWD_DOLLAR
		jr 		z,_CRAssignmentLet
		jp 		SyntaxError
		;
		; 		Come here if 00-7F tokens, e.g. must be an identifier or syntax error.
		;
_CRAssignmentHandler:		
		cp 		IDENTIFIER_END 				; check what follows is an identifier.
		jp 		nc,SyntaxError
_CRAssignmentLet:		
		call	Command_LET 				; do LET.
		jp 		_CRNewCommand

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
		