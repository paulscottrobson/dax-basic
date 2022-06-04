; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		let.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		4th June 2022
;		Reviewed :	No
;		Purpose :	Assignment statement
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;					LET, IX points to value *after* the LET
;
; ***************************************************************************************

Command_LET: 	;; [let]
		ld 		a,(ix+0) 					; if first character an identifier we can autocreate it.
		cp 		KWD_DOLLAR 					; is it $term = something ?
		jr 		z,_CLString
		cp 		IDENTIFIER_END 				; is it an identifier.
		jr 		nc,_CLNoAuto
		ld 		a,$FF 						; set the autocreate flag.
		ld 		(AllowAutoCreate),a
_CLNoAuto:
		ld 		a,KWD_PRECEDENCE_INDIRECT-1 ; only at over this level.
		call 	EvaluateAtPrecedence  		; so we get x!4 = 2.
		bit 	CIsReference,c 				; must be a reference.
		jp 		z,SyntaxError 				; otherwise we have problems.
		push 	hl 							; save address on stack
		push 	bc 							; save type on stack
		xor 	a 							; clear autocreate flag.
		ld 		(AllowAutoCreate),a 		
		ld 		a,KWD_EQUALS 				; check = follows
		call 	CheckNextA

		call 	EvaluateValue 				; evaluate the RHS. Value is in C:HL'HL

		pop 	de 							; get the type of left back (in E)
		ld 		b,e 						
		pop 	de 							; get address of left back into DE
		;
		;		At this point. B:UDE is the target reference and C:HL'HL the value.
		;
		call 	WriteHLToDE
		ret
		;
		; 		String assignment code.
		;
_CLString:
		debug

; ***************************************************************************************
;
;				Write the value in C:HL'HL to the reference B:UDE
;
; ***************************************************************************************

WriteHLToDE:
		bit 	CIsString,c 				; type mismatch if RHS is a string
		jp 		nz,TypeMismatch
		;
		;		Do the actual write of HL'HL to UDE
		;		
_WHDWriteNumber:
		ex 		de,hl 						; the value is in DE'DE, the target in UHL now.
		exx
		ex 		de,hl
		exx

		ld 		(hl),e 						; Z80 version of write DE'DE to (HL)
		inc 	hl  						; not really worth optimising for EZ80
		ld 		(hl),d
		inc 	hl
		push 	hl
		exx
		pop 	hl
		ld 		(hl),e
		inc 	hl
		ld 		(hl),d
		exx

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
