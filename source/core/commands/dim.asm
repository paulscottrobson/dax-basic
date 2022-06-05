; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		dim.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		4th June 2022
;		Reviewed :	No
;		Purpose :	Dim command
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;		DIM command (note syntax change for memory allocation)
;	
;			DIM n(x) 			Creates variable n with x+1 elements 0..x
;			DIM n[x] 			Reserves x+1 bytes of memory and sets DIM equal to it
;								(can be comma chained)
;			DIM n[-ve, not -1] 	DIM_Error (Dim -1 allocates 0 bytes so gives lowmemalloc)
;
; ***************************************************************************************

Command_DIM: 	;; [dim]
		;
		; 		Skip the DIM identifier - we treat the two differently so
		; 		we cannot just get a l-value here.
		;
		push	ix 							; copy start of identifier to DE
		pop 	de
		;
		ld 		a,(ix+0) 					; check identifier
		cp 		IDENTIFIER_END 				
		jp 		nc,SyntaxError 				; no identifier here
_DISkip:
		inc 	ix 							; skip over identifier
		ld 		a,(ix+0)
		cp 		IDENTIFIER_END
		jr 		c,_DISkip 					
		;
		ld 		a,(ix+0) 					; see if followed by a (
		cp 		KWD_LPAREN
		push 	af 							; call whichever function depending.
		call 	z,DimensionArray 			; DE points to identifier.
		pop 	af
		call 	nz,DimensionAllocate
		;
		ld 		a,(ix+0) 					; comma follows ?
		cp 		KWD_COMMA
		ret 	nz
		inc 	ix							; if so, skip comma and go round
		jr 		Command_DIM

_CDError:
		ERR_DIM		

; ***************************************************************************************
;
;			Allocate memory to variable. Error if outside range -1 .. $FFFF
;			Allocates one extra byte so DIM x1 68 actually allocates 69 bytes :)
;
; ***************************************************************************************

DimensionAllocate:
		push 	de 							; save start on stack
		ex 		(sp),ix 					; IX to TOS, start -> IX
		ld 		a,1 						; allow creation of the variable if required
		ld 		(AllowAutoCreate),a
		call 	FindVariable 				; find/create the variable appropriately.
		bit 	CIsReference,c 				; check reference, and integer
		jr 		z,_CDError
		bit 	CIsString,c
		jr 		nz,_CDError
		pop 	ix 							; get address of constant back into IX
		push 	hl 							; save address of variable reference on stack.
		ld  	a,KWD_LSQPAREN
		call 	CheckNextA 					; check for [
		call 	EvaluateInteger 			; get the number of bytes to allocate into HL
		ld  	a,KWD_RSQPAREN
		call 	CheckNextA 					; check for ]
		inc 	hl 							; increment HL,HL'
		ld 		a,h
		or 		l
		jr 		nz,_DANoCarry
		exx
		inc 	hl
		exx
_DANoCarry:
		exx 								; check if HL' is zero
		ld 		a,h
		or 		l
		exx
		jr 		nz,_CDError
		call 	AllocateBytes 				; allocate that much memory.
		ex 		de,hl 						; put address into UDE
		pop 	hl 							; this is where it goes.
		st_de_hl_ind_incr 					; write DE at HL and increment by 4
		xor 	a 							; autocreate off
		ld 		(AllowAutoCreate),a
		ret

; ***************************************************************************************
;
;		Dimension array variable. Must not already exist, followed by one dimension
; 		which is the upper index, so n+1 memory locations.
;
; ***************************************************************************************

DimensionArray:
		push 	de 							; save start on stack.
		;
		call 	EvaluateInteger 			; get dimensions of array, max 1k.
		ld 		a,h 						; max out at $03FF
		and 	$FC
		exx
		or 		h
		or 		l
		exx
		jr 		nz,_CDError
		;
		ex 		(sp),ix 					; end position on stack, start in IX.
		push 	hl 							; save dimension size on stack.		
		;
		call 	VariableInformation 		; get information about this array
		call 	VariableSearchList 			; look to see if already present.
		jr 		nc,_CDError 				; not found.
		;
		pop 	hl 							; get dimension size back
		push 	hl
		inc 	hl 							; add one for zeroth array element
		inc 	hl 							; add one for size word.
		add 	hl,hl 						; x 4 = memory required
		add 	hl,hl
		call 	VariableCreate 				; create the array, completely blank.
		;
		pop 	de 							; get last index into DE
		ld 		bc,9 						; point HL to array offset 9 which is the array size
		add 	hl,bc
		st_de_hl_ind_incr 					; write DE at HL and increment by 4
		pop 	ix 							; restore end position
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
