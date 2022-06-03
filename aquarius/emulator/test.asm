; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		test.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		1st April 2022
;		Purpose :	M7 Main.
;
; ***************************************************************************************
; ***************************************************************************************


	.org $4000
	jp 		start

	.db  	"PSR",0 						; 4 bytes filler.
	.db  	0,$9C,0,$B0,0,$6C 				; 12 bytes ROM Identify
	.db 	0,$64,0,$A8,$5F,$70 			; the $5F makes the total $70 so $00 is output to scrambler
start:	
	jp 		start 							; BIOS enters here.

	.block 	64-($ & $3F)
algined:	

