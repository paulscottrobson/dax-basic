;
;	Vectors for set 0
;
VectorsSet0:
	addr(EOLHandler)                 ; $0080 [[eol]]
	addr(Unimplemented)              ; $0081 [[shift1]]
	addr(Unimplemented)              ; $0082 [[shift2]]
	addr(ALULongReference)           ; $0083 !
	addr(ALUByteReference)           ; $0084 ?
	addr(ALUMultiply)                ; $0085 *
	addr(ALUDivide)                  ; $0086 /
	addr(ALUModulus)                 ; $0087 mod
	addr(ALUAdd)                     ; $0088 +
	addr(ALUSubtract)                ; $0089 -
	addr(ALUCompareGreaterEqual)     ; $008a >=
	addr(ALUCompareLessEqual)        ; $008b <=
	addr(ALUCompareGreater)          ; $008c >
	addr(ALUCompareLess)             ; $008d <
	addr(ALUCompareEqual)            ; $008e =
	addr(ALUCompareNotEqual)         ; $008f <>
	addr(ALUAnd)                     ; $0090 and
	addr(ALUOr)                      ; $0091 or
	addr(ALUXor)                     ; $0092 eor
	addr(Unary_Ampersand)            ; $0093 &
	addr(Unary_Brackets)             ; $0094 (
	addr(Unimplemented)              ; $0095 $
	addr(Unimplemented)              ; $0096 rnd
	addr(Unimplemented)              ; $0097 len
	addr(Unimplemented)              ; $0098 abs
	addr(Unimplemented)              ; $0099 sgn
	addr(Unimplemented)              ; $009a int
	addr(Unimplemented)              ; $009b str$
	addr(Unimplemented)              ; $009c asc
	addr(Unary_Page)                 ; $009d page
	addr(BadCmd_RBracket)            ; $009e )
	addr(BadCmd_Comma)               ; $009f ,
	addr(Command_Colon)              ; $00a0 :
	addr(BadCmd_SemiColon)           ; $00a1 ;
	addr(Command_REM2)               ; $00a2 '
	addr(Unimplemented)              ; $00a3 repeat
	addr(Unimplemented)              ; $00a4 until
	addr(Unimplemented)              ; $00a5 if
	addr(BadCmd_Then)                ; $00a6 then
	addr(Unimplemented)              ; $00a7 else
	addr(Unimplemented)              ; $00a8 for
	addr(BadCmd_To)                  ; $00a9 to
	addr(Unimplemented)              ; $00aa step
	addr(Unimplemented)              ; $00ab next
	addr(BadCmd_Defproc)             ; $00ac def
	addr(Unimplemented)              ; $00ad proc
	addr(Unimplemented)              ; $00ae endproc
	addr(Unimplemented)              ; $00af local
	addr(Unimplemented)              ; $00b0 dim
	addr(Command_REM)                ; $00b1 rem
	addr(Unimplemented)              ; $00b2 let
	addr(Unimplemented)              ; $00b3 vdu
	addr(Unimplemented)              ; $00b4 print
	addr(Unimplemented)              ; $00b5 load
	addr(Unimplemented)              ; $00b6 save
	addr(Unimplemented)              ; $00b7 list
	addr(Command_NEW)                ; $00b8 new
	addr(Command_RUN)                ; $00b9 run
	addr(Unimplemented)              ; $00ba read
	addr(Unimplemented)              ; $00bb data
	addr(Unimplemented)              ; $00bc restore
	addr(Command_ASSERT)             ; $00bd assert
	addr(Command_CLEAR)              ; $00be clear
	addr(Command_END)                ; $00bf end
	addr(Command_STOP)               ; $00c0 stop
;
;	Vectors for set 1
;
VectorsSet1:
;
;	Vectors for set 2
;
VectorsSet2:
