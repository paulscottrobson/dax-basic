; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		allocate.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		4th June 2022
;		Reviewed :	No
;		Purpose :	Allocate memory
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;						Allocate UHL bytes of memory, return in UHL
;
; ***************************************************************************************

AllocateBytes:
		ld 		de,(LowAllocMemory) 		; lowest free byte
		push 	de 							; save on stack
		add 	hl,de 						; HL is the new highest
		ld 		(LowAllocMemory),hl 		; update it
		ex 		de,hl 						; put in DE
		ld 		hl,(HighAllocMemory) 		; calculate high-low
		xor 	a
		sbc 	hl,de
		pop 	hl 							; get lowest free byte back into HL
		ret 	nc 							; return if high >= low
		ERR_MEMORY 							; memory error.

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
