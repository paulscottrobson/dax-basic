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
	addr(UnaryInt32True)             ; $00a3 true
	addr(UnaryInt32False)            ; $00a4 false
	addr(BadCmd_RBracket)            ; $00a5 )
	addr(BadCmd_Comma)               ; $00a6 ,
	addr(Command_Colon)              ; $00a7 :
	addr(BadCmd_SemiColon)           ; $00a8 ;
	addr(Command_REM2)               ; $00a9 '
	addr(Unimplemented)              ; $00aa repeat
	addr(Unimplemented)              ; $00ab until
	addr(Unimplemented)              ; $00ac if
	addr(BadCmd_Then)                ; $00ad then
	addr(Unimplemented)              ; $00ae else
	addr(Unimplemented)              ; $00af for
	addr(BadCmd_To)                  ; $00b0 to
	addr(Unimplemented)              ; $00b1 step
	addr(Unimplemented)              ; $00b2 next
	addr(BadCmd_Defproc)             ; $00b3 def
	addr(Unimplemented)              ; $00b4 proc
	addr(Unimplemented)              ; $00b5 endproc
	addr(Unimplemented)              ; $00b6 local
	addr(Unimplemented)              ; $00b7 dim
	addr(Command_REM)                ; $00b8 rem
	addr(Command_LET)                ; $00b9 let
	addr(Unimplemented)              ; $00ba vdu
	addr(Command_PRINT)              ; $00bb print
	addr(Unimplemented)              ; $00bc load
	addr(Unimplemented)              ; $00bd save
	addr(Unimplemented)              ; $00be list
	addr(Command_NEW)                ; $00bf new
	addr(Command_RUN)                ; $00c0 run
	addr(Unimplemented)              ; $00c1 read
	addr(Unimplemented)              ; $00c2 data
	addr(Unimplemented)              ; $00c3 restore
	addr(Command_ASSERT)             ; $00c4 assert
	addr(Command_CLEAR)              ; $00c5 clear
	addr(Command_END)                ; $00c6 end
	addr(Command_STOP)               ; $00c7 stop
;
;	Vectors for set 1
;
VectorsSet1:
;
;	Vectors for set 2
;
VectorsSet2:
