; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		reference.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		1st May 2022
;		Reviewed :	No
;		Purpose :	Reference/Dereference functions.
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
; 									Dereference HL'HL C
;
; ***************************************************************************************

Dereference:
		bit 	CIsReference,c 				; exit if not reference
		ret 	z

		res 	CIsReference,c 				; clear reference bit.
		
		bit 	CIsString,c 				; dereferencing string, shouldn't be possible.
		jr 		nz,_DRInternal

		bit 	CIsByteReference,c 			; is it a byte reference ?
		jr 		nz,_DeRefByte 

		push 	hl 							; save address on stack.
		ld_ind_hl 							; read HL'HL from HL
		exx
		pop 	hl 							; get address into HL'
		inc 	hl 							; point 2 bytes forward
		inc  	hl
		ld_ind_hl 							; read HL'HL from HL+2
		exx 								; fix back
		ret

_DeRefByte:		
		ld	 	a,(hl) 						; read byte
		ld 		hl,$0000 					; and zero everything else.
		ld	 	l,a
		exx
		ld 		hl,$0000
		exx
		ld 		c,XTYPE_INTEGER 			; return as integer.
		ret

_DRInternal:
		ERR_DISABLED

; ***************************************************************************************
;
; 							Convert HL'HL to address in UHL
;
; ***************************************************************************************

DRConvertHLHLToAddress:
		#ifdef EZ80
		ld 		(AConvert),hl 				; two lower bytes at offset +0
		exx
		ld 		(AConvert+2),hl 			; two upper bytes at offset +2
		ld 		hl,$0000 					; zero HL'
		exx
		ld 		hl,(AConvert) 				; load UHL
		#endif
		ret

; ***************************************************************************************
;
; 							Convert address in UHL to HL'HL 
;
; ***************************************************************************************

DRConvertAddressToHLHL:
		#ifdef EZ80
		ld 		(AConvert),hl
		ld 		hl,$0000
		ld 		(AConvert+3),hl
		exx
		ld 		hl,(AConvert+2)
		exx
		xor 	a
		ld 		(AConvert+2),a
		ld 		hl,(AConvert)
		#endif
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
