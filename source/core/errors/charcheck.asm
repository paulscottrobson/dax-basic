; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		charcheck.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Check next character type functions.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
; 		Common Macro, can create for any token. Use for common ones like ) and ,
;
; ***************************************************************************************

#macro 	checknext(ch,errorid)
		ld 		a,(ix+0) 					; get next character and skip it
		inc 	ix
		cp 		ch 							; exit if matches
		ret 	z
		ld  	a,errorid					; otherwise error (nesting macros doesn't work)
		jp 		ErrorHandler
#endmacro

CheckLeftBracket:
		checknext(KWD_LPAREN,ERRID_NOLBRACKET)

CheckRightBracket:
		checknext(KWD_RPAREN,ERRID_NORBRACKET)

CheckDollar:
		checkNext(KWD_DOLLAR,ERRID_NODOLLAR)
		
CheckComma:
		checknext(KWD_COMMA,ERRID_NOCOMMA)		

; ***************************************************************************************
;
; 							Check A, gives Syntax Error
;
; ***************************************************************************************

CheckNextA:
		cp 		a,(ix+0) 					; match ?
		inc 	ix 							; skip character
		ret 	z 							; yes, okay
		ERR_SYNTAX 							; no, syntax error.
		
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
		