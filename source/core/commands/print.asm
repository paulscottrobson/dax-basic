; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		print.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Print command
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;										PRINT command
;
; ***************************************************************************************

Command_PRINT: 	;; [print]
		ld 		a,-10 						; default base.
		ld 		(PrintBase),a
		;
		;		Main loop
		;
_CPRLoop:
		ld 		a,(ix+0) 					; examine next character
		cp 		KWC_EOL_MARKER 				; EOL or :, do new line and exit
		jr 		z,_CPRExitNL
		cp 		KWD_COLON 	
		jr 		z,_CPRExitNL
		cp 		KWD_SEMICOLON 				; if semicolon, check it's not an ending semicolon
		jr 		z,_CPRCheckNext10
		cp 		KWD_COMMA 					; if comma, print tab
		jr 		z,_CPRTab
		cp 		KWD_SQUOTE 					; is it a single quote, if so print new line.
		jr 		z,_CPRNewLine
		cp 		KWD_TILDE 					; tilde, switch to hex mode
		jr 		z,_CPRHexMode
		;
		call 	EvaluateValue 				; so it must be an expression.		
		bit 	CIsString,c 				; if string, then print it.
		jr 		nz,_CPRPrintHL
		;
		ld 		a,(PrintBase)				; current print mode.
_CPRPrintNumber:
		ld  	bc,ConvertBuffer
		push 	bc
		call 	Int32ToString 				; convert to string
		pop 	hl
		;
		; 		Print text at HL.
		;
_CPRPrintHL:
		call 	PrintStringAtHL 			; print string out
		jr 		_CPRLoop 					; and loop back.		
		;
		;		Hex mode (~)
		;
_CPRHexMode:		
		ld 		a,16
		ld 		(PrintBase),a
		inc 	ix
		jr 		_CPRLoop
		;
		; 		New line (')
		;
_CPRNewLine:
		call 	SYSPrintCRLF
		jr 		_CPRCheckNext
		;
		; 		Tab command (,)
		;
_CPRTab:
		ld 		a,9  						; print CHR$(9), tab
		call 	SYSPrintChar
		;
		;		Set to base 10 then check next character
		;
_CPRCheckNext10:		
		ld 		a,-10
		ld 		(PrintBase),a
		;
		; 		Check if next character (; and , can end line w/o CR)
		;		
_CPRCheckNext:
		inc 	ix 							; consume current
		ld 		a,(ix+0) 					; return without CR if next is EOL or :
		cp 		KWC_EOL_MARKER
		ret 	z
		cp 		KWD_COLON
		ret 	z
		jr 		_CPRLoop 					; otherwise loop round
		;
		;		Found EOL or : not after ; ,
		;
_CPRExitNL:
		call 	SYSPrintCRLF 				; do CR/LF
		ret
