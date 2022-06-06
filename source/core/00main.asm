; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		00main.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Main program.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
; 								Handle eZ80, both TI84 and default
;
; ***************************************************************************************

#ifdef EZ80

.assume ADL=1

#ifdef TI84 	
#include "otherfiles/ti84pce.inc"		; Standard header for TI84-CE
		.org 	userMem-2
		.db 	tExtTok,tAsm84CeCmp	
#endif

; ***************************************************************************************
;
; 								Handle Z80 for Aquarius binary
;
; ***************************************************************************************

#else 

#ifdef AQUARIUS
.org 	$4000
		ld 		hl,StandardIntegers 		; allows dumpvars to find this.
		ld 		sp,$BFFF
#endif

#endif
		call 	SYSInitialise
		ld 		de,TestInstance
		ld 		hl,EndTestInstance
		call 	SetCurrentInstance

		ld 		a,$C3 				; the code for JP
		ld 		(JumpCode),a 		; so we can do a CALL indirect.
		
		jp 		Command_RUN

WarmStart:		
		ld 		a,'*'
		call 	SYSPrintChar
		call 	SYSTerminate

Unimplemented:
		ERR_DISABLED
Int32DivZeroHandler:
		ERR_DIVZERO

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
