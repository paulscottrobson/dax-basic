;
;	This is automatically generated.
;
ErrorIDTable:
	.dw	ErrText_warmstart & $FFFF,ErrText_warmstart >> 16
	.dw	ErrText_assert & $FFFF,ErrText_assert >> 16
	.dw	ErrText_badtype & $FFFF,ErrText_badtype >> 16
	.dw	ErrText_badvalue & $FFFF,ErrText_badvalue >> 16
	.dw	ErrText_dim & $FFFF,ErrText_dim >> 16
	.dw	ErrText_disabled & $FFFF,ErrText_disabled >> 16
	.dw	ErrText_divzero & $FFFF,ErrText_divzero >> 16
	.dw	ErrText_index & $FFFF,ErrText_index >> 16
	.dw	ErrText_lineno & $FFFF,ErrText_lineno >> 16
	.dw	ErrText_memory & $FFFF,ErrText_memory >> 16
	.dw	ErrText_nocomma & $FFFF,ErrText_nocomma >> 16
	.dw	ErrText_nodollar & $FFFF,ErrText_nodollar >> 16
	.dw	ErrText_nolbracket & $FFFF,ErrText_nolbracket >> 16
	.dw	ErrText_norbracket & $FFFF,ErrText_norbracket >> 16
	.dw	ErrText_notref & $FFFF,ErrText_notref >> 16
	.dw	ErrText_stop & $FFFF,ErrText_stop >> 16
	.dw	ErrText_syntax & $FFFF,ErrText_syntax >> 16
	.dw	ErrText_todo & $FFFF,ErrText_todo >> 16
	.dw	ErrText_unknownvar & $FFFF,ErrText_unknownvar >> 16

ErrText_warmstart:
	.db "Ready",0
ErrText_assert:
	.db "Assertion failed",0
ErrText_badtype:
	.db "Type Mismatch",0
ErrText_badvalue:
	.db "Bad Value",0
ErrText_dim:
	.db "DIM Error",0
ErrText_disabled:
	.db "Functionality not enabled",0
ErrText_divzero:
	.db "Division by Zero",0
ErrText_index:
	.db "Bad Array Index",0
ErrText_lineno:
	.db "Unknown line number.",0
ErrText_memory:
	.db "Out of memory",0
ErrText_nocomma:
	.db "Missing Comma",0
ErrText_nodollar:
	.db "Missing $",0
ErrText_nolbracket:
	.db "Missing Left Bracket",0
ErrText_norbracket:
	.db "Missing Right Bracket",0
ErrText_notref:
	.db "Cannot assign",0
ErrText_stop:
	.db "Stop",0
ErrText_syntax:
	.db "Syntax Error",0
ErrText_todo:
	.db "Code not written",0
ErrText_unknownvar:
	.db "Unknown Variable",0
