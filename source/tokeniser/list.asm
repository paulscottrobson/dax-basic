; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		list.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		9th June 2022
;		Reviewed :	No
;		Purpose :	Program listing.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;										LIST a program
;
; ***************************************************************************************

Command_LIST: 	;; [list]
		ld 		bc,$0000 					; BC is the low value
		ld 		de,$FFFF 					; DE is the high value
		;
		;		Unpack the command
		;		
		ld 		a,(ix+0) 					; what's there ?
		cp	 	KWD_COMMA 					; if , then do the second part
		jr 		z,_CLUpperRange
		and 	$C0 						; check number follows.
		cp 		$40
		jr 		nz,_CLList 			
		call 	_CLGetInteger 				; get a line number
		ld  	b,h 						; put into BC
		ld 		c,l
		ld 		a,(ix+0)					; , follows ?
		cp 		KWD_COMMA
		jr 		z,_CLUpperRange
		ld 		d,h 						; one number only, so in BC and DE
		ld 		e,l
		jr 		_CLList
		;
		;		Second number.
		;
_CLUpperRange:
		inc 	ix 							; skip comma
		ld 		a,(ix+0) 					; followed by a number
		and 	$C0
		cp 		$40
		jr 		nz,_CLList 					; No listing done
		call 	_CLGetInteger 				; get a number
		ld 		d,h 						; put into DE
		ld 		e,l		
		;
		;		List from line no.s BC to DE.
		;
_CLList:		
		ld 		ix,(CodeAddress) 			; start of code.
		debug
		;
		;		List main loop
		;
_CLNextLine:		
		ld 		a,(ix+0) 					; offset = 0, then end.
		or 		a
		jp 		z,Command_END
		;
		ld 		hl,$0000 					; line number into HL
		ld 		l,(ix+1) 						
		ld 		h,(ix+2)
		call 	CLCheckLineNumber
		call 	nc,CLPrintLine
		;
		push 	bc 							; go to next line
		ld 		bc,0 						; BC is offset
		ld 		c,(ix+0)
		add 	ix,bc
		pop 	bc
		;
		jr 		_CLNextLine 				; go round again.

; ***************************************************************************************
;
;				Compare line number in HL vs BC/DE, NC if listable
;
; ***************************************************************************************

CLCheckLineNumber:
		push 	hl 							; compare against BC
		xor		a
		sbc 	hl,bc
		pop 	hl
		ret		c 							; if < BC then fail.
		sbc 	hl,de
		jr 		z,_CLCLOkay 				; if <= DE then okay
		jr 		c,_CLCLOkay
		scf
		ret
_CLCLOkay:
		xor 	a
		ret

; ***************************************************************************************
;
;						Get 16 bit integer (for line numbers)
;
; ***************************************************************************************

_CLGetInteger:
		push 	bc
		push 	de
		call 	EvaluateInteger
		exx
		ld 		a,h
		or 		l
		exx
		jp 		z,BadValue
		pop 	de
		pop 	bc
		ret

; ***************************************************************************************
;
;								Print line starting at IX
;
; ***************************************************************************************

CLPrintLine:
		push 	bc
		push 	de
		push 	ix



		pop 	ix
		pop 	de
		pop 	bc
		ret

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
