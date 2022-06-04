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
;		DIM command
;			DIM n(x) 			Creates variable n with x+1 elements 0..x
;			DIM n x 			Reserves x+1 bytes of memory and sets DIM equal to it
;								(can be comma chained)
;			DIM n -ve, not 1 	DIM_Error (Dim -1 allocates 0 bytes so gives lowmemalloc)
;
; ***************************************************************************************

Command_DIM: 	;; [dim]
		debug
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
;		Dimension array variable. Must not already exist, followed by one dimension
; 		which is the upper index, so n+1 memory locations.
;
; ***************************************************************************************

DimensionArray:
		ERR_TODO

; ***************************************************************************************
;
;			Allocate memory to variable. Error if outside range -1 .. $FFFF
;			Allocates one extra byte so DIM x1 68 actually allocates 69 bytes :)
;
; ***************************************************************************************

DimensionAllocate:
		ERR_TODO

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
