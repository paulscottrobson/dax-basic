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

STM_GOSUB = $13					 			; Gosub : Element 1, six bytes
											; return position (5) marker (1)

STM_REPEAT = $23				 			; Repeat : Element 2, six bytes
											; loop position  (5) marker (1)

STM_FOR = $39 								; For : Element 3, 18 bytes
											; loop position  (5) marker (1)
											; 6..9 address of index variable
											; 10..13 limit of index variable
											; 14..17 step of index variable

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
