; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		clear.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Clear command.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;										CLEAR command
;
; ***************************************************************************************

Command_CLEAR: 	;; [clear]
		;
		;			Reset the low free memory pointer (e.g. just above the program space.)
		;
		ld 		hl,(LowMemory) 				; base memory
_CCFindLow:
		ld 		de,0 						; keep adding [hl] till [hl] was zero.
		ld 		e,(hl)		
		add 	hl,de
		ld 		a,e
		or 		a
		jr 		nz,_CCFindLow
		inc 	hl 							; one past the last $00
		ld 		(TopMemory),hl 				; save TOP
		inc 	hl 							; one for luck
		ld 		(LowAllocMemory),hl 		; lowest byte allocated, this pointer moves up.
		;
		; 	 		Reset the language stack
		;
		ld 		hl,(HighMemory) 			; this is high memory, also top of stack
		;
		ld 		(LanguageStack),hl 			; going down from here		
		ld 		de,-LanguageStackSize 		; allocate space for language stack.
		add 	hl,de
		ld 		l,$00 						; put on page boundary.
		ld 		(LanguageStackEnd),hl 		; where it runs out.
		;
		ld 		de,-128 					; allow 128 bytes for the 26 x 4 integer variables.
		add 	hl,de
		ld 		(StandardIntegers),hl
		;
		; 		Allocate space for, and erase all hash table pointers, 
		;
		ld 		de,HashTableSize*4*2 		; bytes required for integer/array hash tables
_CCFClearHT:
		dec 	hl 							; clear DE bytes going backwards.
		ld 		(hl),0
		dec 	de
		ld 		a,d
		or 		e
		jr 		nz,_CCFClearHT
		ld 		(HashTableBase),hl 			; save table base
		;
		; 		Save highest byte that can be allocate
		;
		ld 		(HighAllocMemory),hl 		; set high memory
		;
		; 		Seed the RNG incase the seeds were all zero which gives bad results
		;
		call 	UnaryRandomInitialise
		;
		;		Erase the stack
		;
		call 	StackReset 					; reset the basic stack to empty
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
