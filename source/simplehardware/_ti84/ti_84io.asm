; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		ti84_io.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	TI84 specific code
;
; ***************************************************************************************
; ***************************************************************************************

#ifdef TI84

; ***************************************************************************************
;
;								Initialise system stuff
;
; ***************************************************************************************

SYSInitialise:
	di
	ld 		(_StackTemp84),sp 					; TI84 we preserve IY and SP.
	ld 		(_IYTemp84),iy
	ret

; ***************************************************************************************
;
;								Terminate system stuff
;
; ***************************************************************************************

SYSTerminate:
	ld 		sp,(_StackTemp84) 					; TI84 restore SP
	pop 	iy 									; throw return address from SYSInitialise call
	ld 		iy,(_IYTemp84) 						; restore IY
	res 	donePrgm,(iy+doneFlags) 			; marks program as complete (task switching ?)
	ei
	ret 										; and exit.

_StackTemp84:									; temp var for TI84 only.
	.dw 	0,0
_IYTemp84:
	.dw 	0,0		

; ***************************************************************************************
;
;								Print A character
;
; ***************************************************************************************

SYSPrintChar:
	push 	af 									; we stack everything including alt registers
	push 	bc
	push 	de
	push 	hl
	push 	ix
	push 	iy
	exx
	push 	bc
	push 	de
	push 	hl

	ld 		iy,(_IYTemp84)
	call 	_PutC 								; print A as character
	di
	ld 		(_IYTemp84),iy

	pop 	hl
	pop 	de
	pop 	bc
	exx
	pop 	iy
	pop 	ix
	pop 	hl
	pop 	de
	pop 	bc
	pop 	af
	ret		

; ***************************************************************************************
;
;									Print Newline
;
; ***************************************************************************************

SYSPrintCRLF:
	push 	af 									; we stack everything including alt registers
	push 	bc
	push 	de
	push 	hl
	push 	ix
	push 	iy
	exx
	push 	bc
	push 	de
	push 	hl

	ld 		iy,(_IYTemp84)
	call 	_newline
	di
	ld 		(_IYTemp84),iy

	pop 	hl
	pop 	de
	pop 	bc
	exx
	pop 	iy
	pop 	ix
	pop 	hl
	pop 	de
	pop 	bc
	pop 	af
	ret

#endif

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
