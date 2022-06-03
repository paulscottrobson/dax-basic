; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		assert.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Assert command
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;									ASSERT command
;
; ***************************************************************************************

Command_ASSERT: 	;; [assert]
		call 	EvaluateInteger 			; get an integer expression.
		checkzero 							; set Z flag if HL'HL zero
		ret 	nz 							; okay if it is not
		ERR_ASSERT

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
		