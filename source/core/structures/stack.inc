; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		stack.inc
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		6th June 2022
;		Reviewed :	No
;		Purpose :	Stack constants.
;
; ***************************************************************************************

ST_CodePosSize = 5 							; bytes required to store code position.

STM_GOSUB = $11 + ST_CodePosSize 			; Gosub : Element 1, one position in code
											; (add 1 for the marker itself)

STM_REPEAT = $21 + ST_CodePosSize 			; Repeat : Element 1, one position in code

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
