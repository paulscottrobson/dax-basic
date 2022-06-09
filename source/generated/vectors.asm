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
	addr(BadCmd_LSBracket)           ; $00aa [
	addr(BadCmd_RSBracket)           ; $00ab ]
	addr(BadCmd_Comma)               ; $00ac ~
	addr(Command_REPEAT)             ; $00ad repeat
	addr(Command_Until)              ; $00ae until
	addr(Command_IF)                 ; $00af if
	addr(BadCmd_Then)                ; $00b0 then
	addr(Command_Else)               ; $00b1 else
	addr(Command_FOR)                ; $00b2 for
	addr(BadCmd_To)                  ; $00b3 to
	addr(BadCmd_Step)                ; $00b4 step
	addr(Command_Next)               ; $00b5 next
	addr(BadCmd_Def)                 ; $00b6 def
	addr(Command_PROC)               ; $00b7 proc
	addr(Command_ENDPROC)            ; $00b8 endproc
	addr(Command_GOSUB)              ; $00b9 gosub
	addr(Command_Return)             ; $00ba return
	addr(Command_GOTO)               ; $00bb goto
	addr(Command_LOCAL)              ; $00bc local
	addr(Command_DIM)                ; $00bd dim
	addr(Command_REM)                ; $00be rem
	addr(Command_LET)                ; $00bf let
	addr(Command_VDU)                ; $00c0 vdu
	addr(Command_PRINT)              ; $00c1 print
	addr(Unimplemented)              ; $00c2 load
	addr(Unimplemented)              ; $00c3 save
	addr(Unimplemented)              ; $00c4 list
	addr(Command_NEW)                ; $00c5 new
	addr(Command_RUN)                ; $00c6 run
	addr(Command_READ)               ; $00c7 read
	addr(BadCmd_Data)                ; $00c8 data
	addr(Command_RESTORE)            ; $00c9 restore
	addr(Command_ASSERT)             ; $00ca assert
	addr(Command_CLEAR)              ; $00cb clear
	addr(Command_END)                ; $00cc end
	addr(Command_STOP)               ; $00cd stop
;
;	Vectors for set 1
;
VectorsSet1:
;
;	Vectors for set 2
;
VectorsSet2:
