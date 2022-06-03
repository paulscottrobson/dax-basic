; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		dispatcher.inc
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Vector dispatcher
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;				Dispatchers - takes a vector table (2 bytes Z80,4 bytes EZ80)
; 				reads the call address into DE/UDE. Breaks AHL.
;
; ***************************************************************************************

#ifdef EZ80

#macro 	dispatch(vtable)
		and 	$7F 						; clear bit 7.
		ld 		hl,$0000 					; put index into HL.
		ld 		l,a  						
		add 	hl,hl 						; x 2 
		add 	hl,hl
		ld 		de,vtable 					; DE now points to the vector table
		add 	hl,de 						; HL now points to the vector entry.
		ld 		de,(hl) 					; read target address into DE
		ld 		(JumpCode+1),de 			; and set up the jump vector
#endmacro

#else

#macro 	dispatch(vtable)
		and 	$7F 						; clear bit 7.
		ld 		hl,$0000 					; put index into HL.
		ld 		l,a  						
		add 	hl,hl 						; x 2 
		ld 		de,vtable 					; DE now points to the vector table
		add 	hl,de 						; HL now points to the vector entry.
		ld 		e,(hl) 						; read target address into DE
		inc 	hl
		ld 		d,(hl)
		ld 		(JumpCode+1),de
#endmacro

#endif

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
