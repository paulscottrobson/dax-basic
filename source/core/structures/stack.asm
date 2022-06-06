; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		stack.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		6th June 2022
;		Reviewed :	No
;		Purpose :	Rem / ' command
;
; ***************************************************************************************
; ***************************************************************************************
;
;		The BASIC stack works downwards. Each entry has a first byte, offset 0
;		The low bytes (0..3) the size of the stack entry in bytes 
;		The high byte (4..7) identifies what the stack entry is (e.g. GOSUB, LOCAL)
;
;		If a location in program is saved on the stack, it is at offset 1..4 (start of
;		line) and offset 5 (offset in line)
;
; ***************************************************************************************
;
;								Clear the stack
;
; ***************************************************************************************

StackReset:
		ld 		hl,(LanguageStack) 			; top of language stack
		dec 	hl 							; down to make space for end.
		ld 		(BasicSP),hl 				; write out current position
		ld 		(hl),0 						; Dummy top, as stack size cannot be 0.
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
