; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		badcommands.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Commands that aren't allowed to be run, e.g. cause SN Error.
;
; ***************************************************************************************
; ***************************************************************************************

BadCmd_Then: 		;; [then]
BadCmd_RBracket: 	;; [)]
BadCmd_Comma: 		;; [,]
BadCmd_SemiColon: 	;; [;]
BadCmd_Defproc: 	;; [def]
BadCmd_To: 			;; [to]
		jp 		SyntaxError

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
