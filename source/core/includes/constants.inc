; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		constants.inc
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Constants
;
; ***************************************************************************************
; ***************************************************************************************

IDENTIFIER_END = $26 						; 00 .. 25 is an identifier
STRING_MARKER = $3F 						; marker for string.
;
;		Normally, type information is in C
;				  if reference or string, then address is in (U)HL
;				  if integer, then data (32 bit) is in HL'HL
;

CIsReference = 7 							; Bit 7 set if reference
CIsByteReference = 6 						; Bit 6 set if byte reference
CIsString = 0 								; Bit 0 set if data is string

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
