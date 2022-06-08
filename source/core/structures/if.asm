; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		if.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th June 2022
;		Reviewed :	No
;		Purpose :	If / Then / Else commands
;
; ***************************************************************************************

; ***************************************************************************************
;
;									If Command
;
; ***************************************************************************************

Command_IF: ;; [if]
		call 	EvaluateInteger 			; work out the test.
		call 	Int32Zero 					; test if zero
		jr 		z,_IFFail
		;
		;	 	Passed
		;
		ld 		a,(ix+0) 					; get next, which should be THEN or GOTO
		inc 	ix
		cp 		KWD_GOTO 					; if GOTO goto GOTO code ;-)
		jp 		z,Command_GOTO
		cp 		KWD_THEN 					; no THEN, syntax error
		jp 		nz,SyntaxError
		ld 		a,(ix+0) 					; check THEN <number>
		and 	$C0 						; this checks 40-7F e.g. number
		cp 		$40
		jp 		z,Command_GOTO 				; if number found then GOTO code
		ret 								; otherwise carry on.
		;
		;		Failed.
		;
_IFFail:
		ld 		b,KWC_EOL_MARKER 			; look for EOL or ELSE.
		ld 		c,KWD_ELSE
		call 	SearchForwardTokens 		; searching forward.
		cp 		KWC_EOL_MARKER 				; if EOL was found
		jp 		z,EOLHandler 				; do the next line code.
		ret 								; otherwise carry on.

; ***************************************************************************************
;
;						Else command => Progress to next line
;
; ***************************************************************************************

Command_Else: ;; [else]
		jp 		EOLHandler 					; same code as EOL e.g. read offset from start line.

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
