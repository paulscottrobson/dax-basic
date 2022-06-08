; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		search.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th June 2022
;		Reviewed :	No
;		Purpose :	Search forward for token
;
; ***************************************************************************************

; ***************************************************************************************
;
;		Search forward for either B or C tokens. If found, return the token in A, 
; 		and IX points to next byte.
;		At EOL error if EOL is not one of the two tokens.							
;
; ***************************************************************************************

SearchForwardTokens:
		ld 		a,(ix+0) 					; get token and skip it
		inc 	ix
		cp 		b 							; exit if either found.
		ret 	z
		cp 		c
		ret 	z
		;
		cp 		STRING_MARKER 				; string constant is special skip
		jr 		nz,SearchForwardTokens

		ld 		de,0 						; put length into DE
		ld 		e,(ix+0)
		inc 	de 							; add 1 for length, 1 for terminator
		inc 	de
		add 	ix,de 						; jump forward
		jr 		SearchForwardTokens

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
