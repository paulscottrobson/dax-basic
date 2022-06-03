; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		binrefs.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		3rd June 2022
;		Reviewed :	No
;		Purpose :	Binary reference operators ! ?
;
; ***************************************************************************************
; ***************************************************************************************

; ***************************************************************************************
;
; 									<l> <op> <r>
;
; ***************************************************************************************

ALULongReference:			;; [!]
		call 	BRGetAddress 				; calculate address
		ld  	c,XTYPE_INTEGER
		set 	CIsReference,c
		ret

ALUByteReference: 			;; [?]
		call 	ALULongReference
		set 	CIsByteReference,c
		ret

BRGetAddress: 								; so we add the left and right values and return a reference.
		IntegerDispatch(_BRGAMain)
_BRGAMain:		
		call 	Int32Add 					; address in HL'HL
		call 	DRConvertHLHLtoAddress 		; make it a real physical address in UHL.
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
