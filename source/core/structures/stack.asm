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
;		The low bytes (0..3) doubled is the size of the stack entry in bytes 
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
		ld 		(hl),$F0 					; Dummy top, as stack size cannot be 0.
		ret

; ***************************************************************************************
;
;								Open a stack frame type A
;
; ***************************************************************************************

StackOpenFrame:
		push 	af 							; save frame type
		and 	$0F 						; get size of frame
		add 	a,a 						; double it
		ld 		de,$0000 					; put in UDE
		ld 		e,a
		ld 		hl,(BasicSP) 				; get stack pointer
		xor 	a
		sbc 	hl,de 						; subtract frame size and update
		ld 		(BasicSP),hl
		pop 	af 							; copy out frame type
		ld 		(hl),a
		ld 		de,(LanguageStackEnd) 		; subtract stack end (e.g. lowest value)
		xor 	a
		sbc 	hl,de
		ret 	nc 							; ok if >= lowest value
		ERR_STACK

; ***************************************************************************************
;
;								Close Stack Frame
;
; ***************************************************************************************

StackCloseFrame:
		ld 		hl,(BasicSP)				; get stack frame
		ld 		a,(hl) 						; get stack marker
		and 	$0F 						; put into UDE
		add 	a,a 						; double it
		ld 		de,$000000
		ld 		e,a
		add 	hl,de 						; close it
		ld 		(BasicSP),hl 				; write it back
		ret

; ***************************************************************************************
;
;								Check Stack Frame against A, Z if okay
;
; ***************************************************************************************

StackCheckFrame:
		ld 		hl,(BasicSP)				; get stack frame
		cp 		(hl) 						; get stack marker
		ret

; ***************************************************************************************
;
;								Save position on stack
;
; ***************************************************************************************

StackSavePosition:
		ld 		hl,(BasicSP) 				; goes after marker at stack + 1
		inc 	hl
		ld 		de,(CurrentLineStart) 		; work out current start line
		st_de_hl_ind_incr 					; write out that start line, increment by 4
		;
		push 	hl 							; save HL, e.g. offset 5
		push 	ix 							; HL = current position
		pop 	hl
		xor 	a 							; calculate offset
		sbc 	hl,de
		ld 		a,l 						; into A
		pop 	hl 							; restore offset 5 and save position
		ld 		(hl),a
		ret

; ***************************************************************************************
;
;								Load position off stack
;
; ***************************************************************************************

StackLoadPosition:
		ld 		hl,(BasicSP) 				; goes after marker at stack + 1
		inc 	hl
		push 	hl 							; save on stack
		ld_ind_hl 							; get start of line
		ld 		(CurrentLineStart),hl 		; write it back
		pop 	de 							; get +1 off stack, advance to +5
		inc 	de
		inc 	de
		inc 	de
		inc 	de
		ld 		a,(de) 						; offset into UDE
		ld 		de,$000000
		ld 		e,a
		add 	hl,de 						; add to start => position
		push 	hl 							; copy to IX and continue
		pop 	ix
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
