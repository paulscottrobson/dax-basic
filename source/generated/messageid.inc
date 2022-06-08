;
;	This is automatically generated.
;
ERRID_WARMSTART = 0

#macro ERR_WARMSTART
	ld a,ERRID_WARMSTART
	jp ErrorHandler
#endmacro

ERRID_ASSERT = 1

#macro ERR_ASSERT
	ld a,ERRID_ASSERT
	jp ErrorHandler
#endmacro

ERRID_BADTYPE = 2

#macro ERR_BADTYPE
	ld a,ERRID_BADTYPE
	jp ErrorHandler
#endmacro

ERRID_BADVALUE = 3

#macro ERR_BADVALUE
	ld a,ERRID_BADVALUE
	jp ErrorHandler
#endmacro

ERRID_DIM = 4

#macro ERR_DIM
	ld a,ERRID_DIM
	jp ErrorHandler
#endmacro

ERRID_DISABLED = 5

#macro ERR_DISABLED
	ld a,ERRID_DISABLED
	jp ErrorHandler
#endmacro

ERRID_DIVZERO = 6

#macro ERR_DIVZERO
	ld a,ERRID_DIVZERO
	jp ErrorHandler
#endmacro

ERRID_GOSUB = 7

#macro ERR_GOSUB
	ld a,ERRID_GOSUB
	jp ErrorHandler
#endmacro

ERRID_INDEX = 8

#macro ERR_INDEX
	ld a,ERRID_INDEX
	jp ErrorHandler
#endmacro

ERRID_LINENO = 9

#macro ERR_LINENO
	ld a,ERRID_LINENO
	jp ErrorHandler
#endmacro

ERRID_MEMORY = 10

#macro ERR_MEMORY
	ld a,ERRID_MEMORY
	jp ErrorHandler
#endmacro

ERRID_NEXT = 11

#macro ERR_NEXT
	ld a,ERRID_NEXT
	jp ErrorHandler
#endmacro

ERRID_NOCOMMA = 12

#macro ERR_NOCOMMA
	ld a,ERRID_NOCOMMA
	jp ErrorHandler
#endmacro

ERRID_NODOLLAR = 13

#macro ERR_NODOLLAR
	ld a,ERRID_NODOLLAR
	jp ErrorHandler
#endmacro

ERRID_NOLBRACKET = 14

#macro ERR_NOLBRACKET
	ld a,ERRID_NOLBRACKET
	jp ErrorHandler
#endmacro

ERRID_NOPROC = 15

#macro ERR_NOPROC
	ld a,ERRID_NOPROC
	jp ErrorHandler
#endmacro

ERRID_NORBRACKET = 16

#macro ERR_NORBRACKET
	ld a,ERRID_NORBRACKET
	jp ErrorHandler
#endmacro

ERRID_NOTREF = 17

#macro ERR_NOTREF
	ld a,ERRID_NOTREF
	jp ErrorHandler
#endmacro

ERRID_PARAM = 18

#macro ERR_PARAM
	ld a,ERRID_PARAM
	jp ErrorHandler
#endmacro

ERRID_PROC = 19

#macro ERR_PROC
	ld a,ERRID_PROC
	jp ErrorHandler
#endmacro

ERRID_REPEAT = 20

#macro ERR_REPEAT
	ld a,ERRID_REPEAT
	jp ErrorHandler
#endmacro

ERRID_STACK = 21

#macro ERR_STACK
	ld a,ERRID_STACK
	jp ErrorHandler
#endmacro

ERRID_STOP = 22

#macro ERR_STOP
	ld a,ERRID_STOP
	jp ErrorHandler
#endmacro

ERRID_SYNTAX = 23

#macro ERR_SYNTAX
	ld a,ERRID_SYNTAX
	jp ErrorHandler
#endmacro

ERRID_TODO = 24

#macro ERR_TODO
	ld a,ERRID_TODO
	jp ErrorHandler
#endmacro

ERRID_UNKNOWNVAR = 25

#macro ERR_UNKNOWNVAR
	ld a,ERRID_UNKNOWNVAR
	jp ErrorHandler
#endmacro

