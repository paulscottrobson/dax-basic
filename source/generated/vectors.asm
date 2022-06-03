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
	addr(ALUDivide2)                 ; $0088 div
	addr(ALUAdd)                     ; $0089 +
	addr(ALUSubtract)                ; $008a -
	addr(ALUCompareGreaterEqual)     ; $008b >=
	addr(ALUCompareLessEqual)        ; $008c <=
	addr(ALUCompareGreater)          ; $008d >
	addr(ALUCompareLess)             ; $008e <
	addr(ALUCompareEqual)            ; $008f =
	addr(ALUCompareNotEqual)         ; $0090 <>
	addr(ALUAnd)                     ; $0091 and
	addr(ALUOr)                      ; $0092 or
	addr(ALUXor)                     ; $0093 eor
	addr(Unary_Ampersand)            ; $0094 &
	addr(Unary_Brackets)             ; $0095 (
	addr(Unary_MkStr)                ; $0096 $
	addr(Unary_Random)               ; $0097 rnd
	addr(Unary_Len)                  ; $0098 len
	addr(Unary_Abs)                  ; $0099 abs
	addr(Unary_Sgn)                  ; $009a sgn
	addr(Unary_Str)                  ; $009b str
	addr(Unary_Chr)                  ; $009c chr
	addr(Unary_Asc)                  ; $009d asc
	addr(Unary_Not)                  ; $009e not
	addr(Unary_Page)                 ; $009f page
	addr(Unary_Time)                 ; $00a0 time
	addr(Unary_Top)                  ; $00a1 top
	addr(Unary_Val)                  ; $00a2 val
	addr(BadCmd_RBracket)            ; $00a3 )
	addr(BadCmd_Comma)               ; $00a4 ,
	addr(Command_Colon)              ; $00a5 :
	addr(BadCmd_SemiColon)           ; $00a6 ;
	addr(Command_REM2)               ; $00a7 '
	addr(Unimplemented)              ; $00a8 repeat
	addr(Unimplemented)              ; $00a9 until
	addr(Unimplemented)              ; $00aa if
	addr(BadCmd_Then)                ; $00ab then
	addr(Unimplemented)              ; $00ac else
	addr(Unimplemented)              ; $00ad for
	addr(BadCmd_To)                  ; $00ae to
	addr(Unimplemented)              ; $00af step
	addr(Unimplemented)              ; $00b0 next
	addr(BadCmd_Defproc)             ; $00b1 def
	addr(Unimplemented)              ; $00b2 proc
	addr(Unimplemented)              ; $00b3 endproc
	addr(Unimplemented)              ; $00b4 local
	addr(Unimplemented)              ; $00b5 dim
	addr(Command_REM)                ; $00b6 rem
	addr(Unimplemented)              ; $00b7 let
	addr(Unimplemented)              ; $00b8 vdu
	addr(Command_PRINT)              ; $00b9 print
	addr(Unimplemented)              ; $00ba load
	addr(Unimplemented)              ; $00bb save
	addr(Unimplemented)              ; $00bc list
	addr(Command_NEW)                ; $00bd new
	addr(Command_RUN)                ; $00be run
	addr(Unimplemented)              ; $00bf read
	addr(Unimplemented)              ; $00c0 data
	addr(Unimplemented)              ; $00c1 restore
	addr(Command_ASSERT)             ; $00c2 assert
	addr(Command_CLEAR)              ; $00c3 clear
	addr(Command_END)                ; $00c4 end
	addr(Command_STOP)               ; $00c5 stop
;
;	Vectors for set 1
;
VectorsSet1:
;
;	Vectors for set 2
;
VectorsSet2:
