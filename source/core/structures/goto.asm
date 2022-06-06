; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		goto.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		6th June 2022
;		Reviewed :	No
;		Purpose :	Goto command
;
; ***************************************************************************************

; ***************************************************************************************
;
;									Goto Command
;
; ***************************************************************************************

Command_GOTO: ;; [goto]
			call 	GoGetLineNumber
			call	TransferToLineHL
			ret

; ***************************************************************************************
;
;							Get and validate a line number in HL
;
; ***************************************************************************************

GoGetLineNumber:
			call 	EvaluateInteger
			exx
			ld 		a,h
			or 		l
			exx
			ret 	z
			jp 		BadValue

; ***************************************************************************************
;
;							Transfer to Line Number HL
;
; ***************************************************************************************

TransferToLineHL:
			ex 		de,hl 					; put line number in DE
			ld 		bc,$000000 				; clear BC (for bumping)
			ld 		ix,(CodeAddress)
_TLSearch:	
			add 	ix,bc 					; follow offset, initially 0
			ld 		a,(ix+0) 				; get link
			or 		a 						; if zero
			jr 		z,_TLNotFound 			; not found
			ld  	c,a 					; BC is the offset.

			ld 		a,e						; compare line address
			cp 		(ix+1)
			jr 		nz,_TLSearch
			ld 		a,d
			cp 		(ix+2)
			jr 		nz,_TLSearch
			;
			ld 		(CurrentLineStart),ix 	; set line start
			inc 	ix 						; skip over offset / line#
			inc 	ix
			inc 	ix

			ret

_TLNotFound:
			ERR_LINENO

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
