; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		vdu.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th June 2022
;		Reviewed :	No
;		Purpose :	Vdu command
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;										END command
;
; ***************************************************************************************

Command_VDU: 	;; [vdu]
		ld 		a,(ix+0) 					; exit if : or EOL
		cp 		KWC_EOL_MARKER
		ret 	z
		cp 		KWD_COLON
		ret 	z
		;
		call 	EvaluateInteger 			; evaluate integer value
		exx 								; check 0-FFFF
		ld 		a,h
		or 		l
		exx
		jp  	nz,BadValue
		push 	hl 							; save on stack
		ld 		a,l 						; do the LSB anyway
		call 	SYSPrintChar
		pop 	hl 							; get upper back
		ld 		a,(ix+0) 					; what follows ?
		inc 	ix 
		cp 		KWD_COMMA 					
		jr 		z,Command_VDU
		cp 		KWD_SEMICOLON 				; if semicolon
		jr 		z,_VDUUpper 				; print the MSB
		dec 	ix 							; go back and try again
		jr 		Command_VDU

_VDUUpper:
		ld 		a,h 						; print MSB of expr.
		call 	SYSPrintChar
		jr 		Command_VDU		

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
		