; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		errors.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	ErrorHandler
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;								Error handler, message A 
;
; ***************************************************************************************

ErrorHandler:
		push 	af 						; save error ID

		ld 		hl,0  					; put message# in HL,24 bit compatible
		ld 		l,a
		add 	hl,hl 					; x 4
		add 	hl,hl 		
		ld 		de,ErrorIDTable 		; point HL to address, in generated table.
		add 	hl,de
		ld_ind_hl 						; load hl,(hl) to get address in HL.
		call 	PrintStringAtHL
		;
		pop 	af 						; restore error ID
		or 		a 						; no line # if error #zero (warmstart)
		jr 		z,_EHExit
		;
		ld 		ix,(CurrentLineStart) 	; get line
		ld 		a,(ix+0) 				; check offset zero, if so , off the end.
		or 		a
		jr 		z,_EHExit

		ld 		hl,_EHAtText 			; print "at line"
		call 	PrintStringAtHL 
		
		exx								; HL'HL = line number
		ld 		hl,$0000 		
		exx 
		ld 		l,(ix+1)
		ld 		h,(ix+2)
		ld 		a,10 					; convert in base 10
		ld 		bc,ConvertBuffer
		call 	Int32ToString
		push 	bc
		pop 	hl
		call 	PrintStringAtHL			; print error line number.
_EHExit:		
		call 	SYSPrintCRLF 			; print carriage return
		jp 		WarmStart

_EHAtText:
		.db 	" at line ",0

NotImplemented:
		ERR_DISABLED
TypeMismatch:
		ERR_BADTYPE
BadValue:
		ERR_BADVALUE
SyntaxError:
		ERR_SYNTAX
						
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
