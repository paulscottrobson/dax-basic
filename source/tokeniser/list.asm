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
		call 	CLExpandLine
		ld 		hl,TokenBuffer
		call 	PrintStringAtHL 
		call 	SYSPrintCRLF
		ret

; ***************************************************************************************
;
;						 Expand line to buffer starting at IX
;
; ***************************************************************************************

CLExpandLine:
		push 	bc
		push 	de
		push 	ix
		ld 		hl,TokenBuffer 				; set the token buffer pointer
		ld 		(TWPointer),hl
		call 	CLDecodeLineNumber
		call 	CLPrintSpace
		inc 	ix 							; point to line star.
		inc 	ix
		inc 	ix
_CLPLLoop		
		ld 		a,(ix+0) 					; next token.
		cp 		$80 						; EOL 
		jr 		z,_CLPLLExit 				; if so, exit.
		or 		a
		call 	m,CLDecodeKeyword

		ld 		b,16
		cp 		KWD_AMPERSAND
		call 	z,CLDecodeInteger

		cp 		IDENTIFIER_END
		call 	c,CLDecodeIdentifier

		cp 		STRING_MARKER
		call 	z,CLDecodeString

		and 	$C0
		cp 		$40
		ld 		b,10
		call 	z,CLDecodeInteger
		jr 		_CLPLLoop

_CLPLLExit:		
		pop 	ix
		pop 	de
		pop 	bc
		ret

; ***************************************************************************************
;
;								Print Space/A to output
;
; ***************************************************************************************

CLPrintSpace:
		ld 		a,' '
CLPrintA:
		push 	hl
		ld 		hl,(TWPointer)		
		ld 		(hl),a
		inc 	hl
		ld 		(TWPointer),hl
		ld 		(hl),0
		pop 	hl
		ret

; ***************************************************************************************
;
;									Decode Keyword A
;
; ***************************************************************************************

CLDecodeKeyword:
		push 	af
		inc 	ix 							; consume keyword
		ld 		b,a 						; put keyword # in B
		ld 		hl,KeywordsSet0 			; start with set 0
_CLFindKeyword:
		dec 	b
		jp 		p,_CLFoundKeyword 			; if $7F have found keyword.
		ld 		de,0 						; get length into DE
		ld 		e,(hl)
		inc 	de 							; +1 for the length
		add 	hl,de 						; go to next keyword		
		jr 		_CLFindKeyword
_CLFoundKeyword:
		ld 		b,(hl) 						; get length into B
_CLCopyKeyword:
		inc 	hl 							; copy that many characters/
		ld 		a,(hl)				
		call 	CLPrintA
		djnz 	_CLCopyKeyword
		pop 	af
		ret

; ***************************************************************************************
;
;								 Decode Identifier at IX
;
; ***************************************************************************************

CLDecodeIdentifier:
		push 	af
_CLDILoop:
		ld 		a,(ix+0) 					; get identifier.
		inc 	ix
		ld 		b,97 
		cp 		26
		jr 		c,_CLDIDoChar
		ld 		b,48-26
		cp 		36
		jr 		c,_CLDIDoChar
		ld 		b,'_'-36
_CLDIDoChar:
		add 	a,b
		call 	CLPrintA		
		ld 		a,(ix+0) 					; check next is identifier
		cp 		IDENTIFIER_END
		jr 		c,_CLDILoop
		pop 	af
		ret

; ***************************************************************************************
;
;								 Decode String at IX
;
; ***************************************************************************************

CLDecodeString:
		push 	af
		ld	 	a,'"'
		call 	CLPrintA
		inc 	ix
		inc 	ix
_CLDSOut:
		ld 		a,(ix+0)
		inc 	ix
		cp 		' '	
		jr 		c,_CLDSEnd
		call 	CLPrintA
		jr 		_CLDSOut
_CLDSEnd:		
		ld	 	a,'"'
		call 	CLPrintA
		pop 	af
		ret

; ***************************************************************************************
;
;								 Decode Integer at IX
;
; ***************************************************************************************

CLDecodeInteger:
		push 	af
		push 	bc
		call 	EvaluateInteger
		pop 	bc
		ld 		a,b
		call 	CLExpandInt32ToBuffer
		pop 	af
		ret

; ***************************************************************************************
;
;							 Decode Line Number into Token Buffer
;
; ***************************************************************************************

CLDecodeLineNumber:
		ld 		l,(ix+1)					; get line# to HL'HL
		ld 		h,(ix+2)
		exx
		ld 		hl,$000000
		exx
		ld 		a,10 						; base
CLExpandInt32ToBuffer:
		ld 		bc,(TWPointer) 				; where it goes.
		call 	Int32ToString
_CLEI3End: 									; look for number end.
		ld 		a,(bc)
		ld 		(TWPointer),bc
		inc 	bc
		cp 		' '
		jr 		nc,_CLEI3End
		xor 	a 							; add EOS
		ld 		(bc),a				
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
