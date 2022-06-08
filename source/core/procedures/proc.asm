; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		proc.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		8th June 2022
;		Reviewed :	No
;		Purpose :	Proc command
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;										PROC Command
;
; ***************************************************************************************

Command_PROC: 	;; [proc]
			ld		a,STM_PROC 				; open a PROC frame. This is an empty
			call 	StackOpenFrame 			; marker position.
			;
			ld 		a,(ix+0) 				; check followed by identifier
			cp 		IDENTIFIER_END
			jp 		nc,SyntaxError 			; no , no call possible.
			call 	SearchProcedure 		; find procedure referenced at IX.
			;
			;		We have the start of line in DE, and the position in the line
			;		of the callee (possible parameter list) in HL.
			;
			push 	de 						; save start of line
			ld 		a,(ix+0) 				; does the caller provide any parameters
			cp 		KWD_LPAREN 				; e.g. DEF PROC name(42)
			call 	z,ProcDoParameterList 	; this may create more LOCAL frames.
			;
			push 	hl 						; save start of new code, after PROC call
			;
			ld 		a,STM_PROCINFO 			; open a frame for the PROC data.
			call 	StackOpenFrame 
			call 	StackSavePosition 		; and save the return address on the stack.

			pop 	ix 						; new position in code
			pop 	hl 						; start of line
			ld 		(CurrentLineStart),hl 	; save start of line
			ret

; ***************************************************************************************
;
;			IX points to the ( of the parameter list <known>, check the param list
; 			exists at callee (HL), then transfer the parameters
;
;			on exit the HL and IX should both point to the position *after* the
;			final ) on the parameter lists.
;
; ***************************************************************************************

ProcDoParameterList:
			ld 		a,(hl) 					; check (HL) = (DE) , at this point they
			cp 		(ix+0) 					; should point to the same thing ( , or )
			jr 		nz,_ParamError
			;
			inc 	ix 						; skip over it
			inc 	hl
			cp 		KWD_RPAREN 				; if it was ), then reached the end.
			ret 	z
			;
			cp 		KWD_LPAREN 				; if it was ( or , it's okay.
			jr 		z,_PDPFound
			cp 		KWD_COMMA
			jr 		nz,_ParamError 			; if not, there's an error.
			;
			;		at this point HL points to callee, IX to caller.
			;
_PDPFound:			
			push 	hl 						; save callee on stack
			call 	EvaluateInteger 		; get a parameter, integer only => HL'HL
			ex 		(sp),ix 				; now IX points to callee, caller is on stack
			call 	LocalCreateVariable 	; create variable at IX with start value HL'HL
			ex 		(sp),ix 				; now IX is caller again 
			pop 	hl 						; and HL the callee
			jr 		ProcDoParameterList 	; both should point to ) or ,

_ParamError:
			ERR_PARAM

; ***************************************************************************************
;
;										ENDPROC Command
;
; ***************************************************************************************

Command_ENDPROC: ;; [endproc]
			call 	PopLocals 				; restore any locals (declared using LOCAL)
			ld		a,STM_PROCINFO 			; check its a procedure information frame
			call 	StackCheckFrame
			jr 		nz,_EndProcError
			call 	StackLoadPosition 		; restore position into IX/SOL
			call 	StackCloseFrame 		

			call 	PopLocals 				; restore any locals (parameters)
			ld		a,STM_PROC 				; check its a procedure marker frame
			call 	StackCheckFrame
			jr 		nz,_EndProcError
			call 	StackCloseFrame 		
			ret
_EndProcError:
			ERR_NOPROC

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
