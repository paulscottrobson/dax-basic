; ***************************************************************************************
; ***************************************************************************************
;
;		Name : 		read.asm
;		Author :	Paul Robson (paul@robsons.org.uk)
;		Date : 		9th June 2022
;		Reviewed :	No
;		Purpose :	READ command
;
; ***************************************************************************************

; ***************************************************************************************
;
;									Read Command
;
; ***************************************************************************************

Command_READ: ;; [read]
			;
			;		READ loop
			;
_CRLoop:	
			ld 		hl,DataScanRequired 	; check and clear scan required flag
			ld 		a,(hl)
			ld 		(hl),0 
			or 		a
			call 	nz,CRScanForward 		; if required, scan forward to the first data
			;
			ld 		a,$FF 					; we can autocreate READ variables
			ld 		(AllowAutoCreate),a
			call 	FindVariable 			; locate the variable, address in UHL now.
			xor 	a 						
			ld 		(AllowAutoCreate),a
			push 	ix 						; save position in program
			push 	hl						; save variable target address.
			;
_CRLocateData:			
			ld 		ix,(ReadDataPointer) 	; current read position
			call 	EvaluateInteger 		; should be an integer there.
			pop 	de 						; target address in DE
			call 	_LCVWrite32HL 			; function to write HL'HL to DE
			;
			ld 		a,(ix+0) 				; get following.
			inc 	ix
			ld 		(ReadDataPointer),ix 	; skip over it. It should be , EOS or :
			;
			xor 	KWD_COMMA 				; will be zero if a comma, hence no scan required
			ld 		(DataScanRequired),a 	; update the flag accordingly.
			;
			pop 	ix						; get program position back
			ld 		a,(ix+0) 				; is it followed by a comma
			cp 		KWD_COMMA
			ret 	nz 						; no, end of READ
			inc 	ix 						; skip comma
			jr 		_CRLoop 				; go round again.

; ***************************************************************************************
;
;			Scan the data pointer forward to the next data statement, error if none.
;
; ***************************************************************************************

CRScanForward:
			push 	ix
			ld 		ix,(ReadDataPointer)
_CRScanLoop:
			ld 		b,KWD_DATA 				; want to search for DATA or EOL
			ld 		c,KWC_EOL_MARKER
			call 	SearchForwardTokens 	; look for DATA or EOL in current line.
			cp 		KWD_DATA 				; DATA found, we can exit
			jr 		z,_CRScanExit
			;
			ld 		a,(ix+0) 				; get offset
			inc 	ix 						; point to start of next line.
			inc 	ix
			inc 	ix
			or 		a 						; if offset non zero try that line.
			jr 		nz,_CRScanLoop
			ERR_DATA 						; we have no data.

_CRScanExit:
			ld 		(ReadDataPointer),ix 	; update pointer at new DATA.
			pop 	ix
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
