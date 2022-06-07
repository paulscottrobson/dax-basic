; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		repeat.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		7th June 2022
;		Reviewed :	No
;		Purpose :	Repeat/Until command
;
; ***************************************************************************************

; ***************************************************************************************
;
;									Repeat Command
;
; ***************************************************************************************

Command_REPEAT: ;; [repeat]
			ld		a,STM_REPEAT
			call 	StackOpenFrame
			call 	StackSavePosition
			ret

; ***************************************************************************************
;
;									Until command
;
; ***************************************************************************************

Command_Until: ;; [until]
			ld		a,STM_REPEAT
			call 	StackCheckFrame
			jr 		nz,_UntilError
			call	EvaluateInteger 		; until what
			call 	Int32Zero 				; check zero
			jp 		z,StackLoadPosition 	; if zero loop back
			call 	StackCloseFrame 		; otherwise end frame.
			ret
_UntilError:
			ERR_REPEAT

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
