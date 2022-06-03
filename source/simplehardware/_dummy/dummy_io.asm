; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		dummy_io.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	eZ80 build System code.,a
;
; ***************************************************************************************
; ***************************************************************************************

#ifdef CLEANEZ80

; ***************************************************************************************
;
;								Initialise system stuff
;
; ***************************************************************************************

SYSInitialise:
	ret

; ***************************************************************************************
;
;								Terminate system stuff
;
; ***************************************************************************************

SYSTerminate:
	ret

; ***************************************************************************************
;
;								Print A character
;
; ***************************************************************************************

SYSPrintChar:
	ret		

; ***************************************************************************************
;
;									Print Newline
;
; ***************************************************************************************

SYSPrintCRLF:
	ret

#endif

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
