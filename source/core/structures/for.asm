; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		repeat.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		7th June 2022
;		Reviewed :	No
;		Purpose :	Repeat/Until command
;
; ***************************************************************************************

; ***************************************************************************************
;
;									For Command
;
; ***************************************************************************************

Command_FOR: ;; [for]
			ld		a,STM_FOR 				; open the FOR frame
			call 	StackOpenFrame
			;
			;		Variable Reference to increment
			;
			ld 		a,255 					; FOR can create
			ld 		(AllowAutoCreate),a
			call 	EvaluateTerm 			; get term
			xor 	a 						; autocreate off.
			ld 		(AllowAutoCreate),a

			;
			bit 	CIsReference,c 			; must be an integer reference.
			jp 		z,SyntaxError
			bit 	CIsString,c
			jp 		nz,SyntaxError
			ex 		de,hl 					; put reference in DE.
			;
			ld 		hl,(BasicSP)			; point to Basic+6, where the reference goes.
			ld 		bc,6
			add 	hl,bc 
			st_de_hl_ind_incr 				; write and bump reference.
			ex 		de,hl 					; put the FOR data pointer in DE.
			;
			;		=
			;
			ld 		a,KWD_EQUALS 			; should be FOR <var> = <a> TO <b>
			call 	CheckNextA
			;
			; 		start
			;
			push 	de 						; save write pos (Stack + 10)
			call 	EvaluateInteger 		; get start value in HL'HL
			call 	_CRUpdateIndex 			; copy HL'HL to the index.
			pop 	de 						; restore write pos
			; 		
			; 		TO
			;
			ld 		a,KWD_TO 				; TO token
			call 	CheckNextA
			;
 			;		end
			;
			call 	_CRWriteIntToDE 		; to value 
			;
			;		check step
			;
			ld 		a,(ix+0)				; followed by STEP ?
			cp 		KWD_STEP
			jr 		z,_CRHasStep
			;
			;		No Step, use 1.
			;
			ld 		hl,1 					; HL'HL is step
			exx
			ld 		hl,0
			exx
			call 	_CRWriteHLHLToDE 		; write it and exit
			jr 		_CRExit
			;
			;		Step, get value
			;
_CRHasStep:	inc 	ix 						; skip STEP
			call 	_CRWriteIntToDE 		; Step value			
			;
			;		Come back here.
			;
_CRExit:			
			call 	StackSavePosition 		; save the loop position last of all.
			ret

;
;		Write an evaluate integer or HL'HL to address DE.
;
_CRWriteIntToDE:
			push 	de
			call 	EvaluateInteger
			pop 	de
_CRWriteHLHLToDE:
			ex 		de,hl 					; write DE'DE to (HL)
			exx
			ex 		de,hl
			exx

			ld 		(hl),e
			inc 	hl
			ld 		(hl),d
			inc 	hl
			push 	hl
			exx 	
			pop 	hl

			ld 		(hl),e
			inc 	hl
			ld 		(hl),d
			inc 	hl
			push 	hl
			exx 	
			pop 	hl

			ex 		de,hl 					; put back so DE is the address.
			exx
			ex 		de,hl
			exx
			ret
;
;			Read offset A into HL'HL
;			
_CRReadAToHLHL:
			push 	bc 						; HL = (BasicSP)+a
			ld 		bc,$000000
			ld 		c,a
			ld 		hl,(BasicSP)
			add 	hl,bc
			pop 	bc
;
;			Read (HL) to HL'HL
;			
_CRReadHLToHLHL:
			push 	hl
			ld_ind_hl
			exx
			pop 	hl
			inc 	hl
			inc 	hl
			ld_ind_hl
			exx
			ret
;
;			Copy HL'HL to the index
;
_CRUpdateIndex
			ex 		de,hl 					; put index value in DE.
			ld 		hl,(BasicSP) 			; point HL to the reference address
			ld 		bc,6
			add 	hl,bc
			ld_ind_hl 						; HL now contains the address of the variable
			ex 		de,hl 					; DE address HL'HL data
			call 	_CRWriteHLHLToDE
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
