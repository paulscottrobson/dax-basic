; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		locals.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th June 2022
;		Reviewed :	No
;		Purpose :	Handling of LOCAL, locals and parameters.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;			Create variable at IX, give it the initial value HL'HL
;						(used for parameters and locals)
;
; ***************************************************************************************

LocalCreateVariable:
		push 	hl 							; push the initial value on the stack.
		exx
		push 	hl
		exx

		ld 		a,$FF 						; we can autocreate locals and parameters
		ld 		(AllowAutoCreate),a
		call 	FindVariable 				; locate the variable, address in UHL now.
		push 	hl 							; save variable address.

		ld		a,STM_LOCAL 				; create a local stack frame 
		call 	StackOpenFrame

		ld 		hl,(BasicSP) 				; point to SP+1
		inc 	hl
		pop 	de 							; variable address in UDE keeping on stack.
		push 	de
		st_de_hl_ind_incr					; write the variable address to SP+1, advance to +5
		;
		ex 		de,hl 						; final write address is now in DE, variable address in HL
		call 	_LCVRead32HL 				; read HL current value into HL'HL
		call 	_LCVWrite32HL 				; and write back the original value of the variable to DE.
		;
		pop 	de 							; the address of the variable itself.
		;
		exx 								; restore the value being initialised to.
		pop 	hl
		exx
		pop 	hl
		call 	_LCVWrite32HL 				; write HL'HL to DE.
		ret

; ***************************************************************************************
;
;									Write HL'HL to DE.
;
; ***************************************************************************************

_LCVWrite32HL:
		ld 		a,l
		ld 		(de),a
		inc 	de
		ld 		a,h
		ld 		(de),a
		inc 	de
		push 	de
		exx
		pop 	de
		ld 		a,l
		ld 		(de),a
		inc 	de
		ld 		a,h
		ld 		(de),a
		exx
		ret

; ***************************************************************************************
;
;									Read (HL) to HL'HL
;
; ***************************************************************************************

_LCVRead32HL:
		push 	hl
		ld_ind_hl
		exx
		pop 	hl
		inc 	hl
		inc 	hl
		ld_ind_hl
		exx
		ret

; ***************************************************************************************
;
;			If the local marker is on the top of the stack, then undo the local
;			or parameter
;
; ***************************************************************************************

PopLocals:
		ld 		a,STM_LOCAL 				; is there a LOCAL on the stack ?
		call 	StackCheckFrame
		ret 	nz 							; no, we've popped this lot.

		ld 		hl,(BasicSP) 				; get SP+1, which is the address to write to.
		inc 	hl
		push 	hl 							; save it
		ld_ind_hl 							; read address into HL
		ex 		de,hl 						; target address is in DE.
		;
		pop 	hl 							; address of old value
		inc 	hl
		inc 	hl
		inc 	hl
		inc 	hl
		call 	_LCVRead32HL 				; value into HL'HL
		call 	_LCVWrite32HL 				; and write it out again to var address

		call 	StackCloseFrame 			; remove the local/parameter
		jr 		PopLocals 					; check any more ?

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
