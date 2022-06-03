; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		01data.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Data space
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
;				Data area. Allow 3 bytes minimum for anything where you 
;				LD (xxx),rr etc.
;
; ***************************************************************************************

LanguageStackSize = 2048 					; bytes allocated to language stack.

HashTableSize = 16 							; 16 pointers for each of 6 types

; ***************************************************************************************
;
;								Defines the current instance
;
; ***************************************************************************************

LowMemory:									; Lowest byte for current instance.
		.dw 	0,0
HighMemory: 								; Highest byte for current instance
		.dw 	0,0		
CodeAddress: 								; Program code (e.g. first line) is here
		.dw 	0,0 							

; ***************************************************************************************
;
;								Allocatable memory, working down.
;
; ***************************************************************************************

LanguageStack: 								; Language Stack, down from here.
		.dw 	0,0

LanguageStackEnd: 							; as far as the language stack goes.
		.dw 	0,0		

StandardIntegers: 							; address of standard A-Z variables. On a 128 byte page.
		.dw 	0,0

;
;		The empty space is in here. Arrays, Variables and Memory allocated from the bottom up.
;

LowAllocMemory: 							; lowest free memory byte.
		.dw 	0,0

; ***************************************************************************************
;
;										Run variables
;
; ***************************************************************************************

CurrentLineStart: 							; Start of current line.
		.dw 	0,0
		
RunStackPtr: 								; Stack pointer at Command_RUN
		.dw 	0,0

JumpCode: 									; Code copied here for JP $xxxxxx
		.dw 	0,0,0

AConvert: 									; used for address conversions.
		.dw 	0,0,0
		
RandomSeed: 								; random number seeds.
		.block 	16

s; ***************************************************************************************
;
;										  Buffers
;
; ***************************************************************************************

ConvertBuffer:
		.block 	64

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