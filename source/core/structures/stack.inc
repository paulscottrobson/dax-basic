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

STM_PROC = $41 								; Proc Marker : Element 4, one byte

STM_PROCINFO = $53 							; Proc Return : Element 5, six bytes
											; return position (5) marker (1)

STM_LOCAL = $65 							; Local/Param : Element 6, nine bytes
											; 1..4 	Address of variable localised
											; 5..8  Value to restore to it.
											
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
