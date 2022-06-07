; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		for.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		7th June 2022
;		Reviewed :	No
;		Purpose :	For/Next command
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
			push	ix 						; save start position
			ld 		a,255 					; FOR can create
			ld 		(AllowAutoCreate),a
			call 	EvaluateTerm 			; get term
			xor 	a 						; autocreate off.
			ld 		(AllowAutoCreate),a
			pop 	ix 						; get start position
			push 	hl 						; save reference address.
			;
			bit 	CIsString,c 			; check it is a string reference.
			jp 		nz,SyntaxError
			ex 		de,hl 					; put reference in DE.
			;
			ld 		hl,(BasicSP)			; point to Basic+6, where the reference goes.
			ld 		bc,6
			add 	hl,bc 
			st_de_hl_ind_incr 				; write and bump reference.
			;
			;		var = value
			;
			call 	Command_LET 			; so we do I = 1 or whatever.
			; 		
			; 		TO
			;
			ld 		a,KWD_TO 				; TO token
			call 	CheckNextA
			;
			;		value
			;
			call 	EvaluateInteger  		; write the TO value to offset 10.
			ld 		a,10
			call 	CFWriteHLHLToA 
			;
			;		Check STEP ?
			;
			ld 		hl,1 					; default STEP is 1.
			exx
			ld 		hl,0
			exx			
			ld 		a,(ix+0) 				; STEP provided ?
			cp 		KWD_STEP 				
			jr 		nz,_CFDefaultStep
			;
			inc 	ix 						; get step
			call 	EvaluateInteger
_CFDefaultStep:			
			ld 		a,14 					; write to STEP slot.
			call 	CFWriteHLHLToA 
			call 	StackSavePosition 		; save loop address
			ret

; ***************************************************************************************
;
;								Read BasicStack+A to HL'HL
;
; ***************************************************************************************

CFReadAToHLHL:
			ld 		bc,0 					; BC = 00|A
			ld 		c,a
			ld 		hl,(BasicSP) 			; add stack base
			add 	hl,bc

CFReadHLToHLHL:
			push 	hl
			ld_ind_hl 						; get low word
			exx

			pop 	hl 						; get high word
			inc 	hl
			inc 	hl
			ld_ind_hl
			exx

			ret

; ***************************************************************************************
;
;								Write HL'HL to BasicStack+A
;
; ***************************************************************************************

CFWriteHLHLToA:
			ex 		de,hl 					; copy HL'HL to DE
			exx
			ex 		de,hl
			exx

			ld 		bc,0 					; BC = 00|A
			ld 		c,a
			ld 		hl,(BasicSP) 			; add stack base
			add 	hl,bc

			ld 		(hl),e 					; write low word
			inc 	hl
			ld 		(hl),d
			inc 	hl

			push 	hl 						; write high word
			exx
			pop 	hl
			ld 		(hl),e
			inc 	hl
			ld 		(hl),d
			exx
			ret			

; ***************************************************************************************
;
;									Next Command
;		  (only supports version w/o index variable, something I never liked)
;
; ***************************************************************************************

Command_Next:	;; [next]
			debug
			ld		a,STM_FOR 				; check in a FOR Loop.
			call 	StackCheckFrame

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
