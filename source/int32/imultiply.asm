; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		imultiply.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Multiply HL'HL by DE'DE
;
; ***************************************************************************************
; ***************************************************************************************

Int32Multiply:
		push 	bc 							; save BC'BC and DE'DE, copy HL'HL to BC'BC and zero HL'HL
		push 	de
		ld 		b,h
		ld 		c,l
		ld 		hl,$0000

		exx
		push 	bc
		push 	de
		ld 		b,h
		ld 		c,l
		ld 		hl,$0000		
		exx

_I32MultiplyLoop:
		bit 	0,c 						; is bit 0 of BC'BC set ?
		call 	nz,Int32Add 				; add DE'DE to HL'HL
		;
		exx 								; shift BC'BC right.
		srl 	b
		rr 		c
		exx
		rr 		b
		rr 		c
		;
		sla 	e 							; shift DE'DE left.
		rl 		d
		exx
		rl 		e
		rl 		d

		ld 		a,b 						; check BC is zero in last exx
		or 		c
		exx
		or 		b
		or 		c
		jr 		nz,_I32MultiplyLoop

		exx  								; pop DE'DE and BC'BC
		pop 	de
		pop 	bc
		exx
		pop 	de
		pop 	bc
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
