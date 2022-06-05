; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		create.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		4th June 2022
;		Reviewed :	No
;		Purpose :	Create a variable.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;		Create a variable as set up by VariableInformation. On entry HL contains the
;		data size (e.g. the data for integer, and size+data for array) past offset 9.
;
; ***************************************************************************************

VariableCreate:		
		;
		;		Work out bytes to allocate (HL+9) and allocate it
		;
		ld 		de,9 						; add 9 for the first collection of bytes.
		add 	hl,de 						; actual # of bytes required.
		push 	hl 							; save count.
		call 	AllocateBytes 				; claim that many bytes
		pop 	bc 							; restore count to BC
		;
		; 		Erase data - bytes to erase is in BC, data at HL.
		;
		push	hl 							; save start address on stack
_VCClear:
		ld 		(hl),$00 					; erase the allocated memory.
		inc 	hl
		dec 	bc
		ld		a,b
		or 		c
		jr 		nz,_VCClear
		pop 	hl							; restore start address
		;
		;		Now start to create the data.
		;
		push 	hl 							; save start
		;
		;		Write hash to +0
		;
		ld 		a,(VarHash) 				; write Hash to +0
		ld 		(hl),a
		inc 	hl
		;
		;		Write list head to +1
		;
		push 	hl 							; save write position
		ld 		hl,(VarHashListPtr)			; get the address of the list head
		ld_ind_hl 							; get the list head
		ex 		de,hl 						; put in list head in DE
		pop 	hl 		 					; restore write position
		st_de_hl_ind_incr 					; write DE at HL and increment by 4.
		;
		;		Write variable name to +5
		;
		ld 		de,(VarNameStart)			; push start of variable name
		st_de_hl_ind_incr 					; write DE at HL and increment by 4.
		;
		pop 	de 							; get the start address back
		ld 		hl,(VarHashListPtr)			; get the address of the list head
		st_de_hl_ind_incr 					; write DE at HL and patch into list head.
		;
		ex 		de,hl 						; start address into HL
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
