; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		gosub.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		7th June 2022
;		Reviewed :	No
;		Purpose :	Gosub/Return command
;
; ***************************************************************************************

; ***************************************************************************************
;
;									Gosub Command
;
; ***************************************************************************************

Command_GOSUB: ;; [gosub]
			ld		a,STM_GOSUB
			call 	StackOpenFrame
			call 	GoGetLineNumber
			push 	hl
			call 	StackSavePosition
			pop 	hl
			call	TransferToLineHL
			ret

; ***************************************************************************************
;
;									Return command
;
; ***************************************************************************************

Command_Return: ;; [return]
			ld		a,STM_GOSUB
			call 	StackCheckFrame
			jr 		nz,_ReturnError
			call 	StackLoadPosition
			call 	StackCloseFrame
			ret
_ReturnError:
			ERR_GOSUB

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
