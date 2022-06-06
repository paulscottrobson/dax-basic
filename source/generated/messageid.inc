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

ERRID_INDEX = 7

#macro ERR_INDEX
	ld a,ERRID_INDEX
	jp ErrorHandler
#endmacro

ERRID_LINENO = 8

#macro ERR_LINENO
	ld a,ERRID_LINENO
	jp ErrorHandler
#endmacro

ERRID_MEMORY = 9

#macro ERR_MEMORY
	ld a,ERRID_MEMORY
	jp ErrorHandler
#endmacro

ERRID_NOCOMMA = 10

#macro ERR_NOCOMMA
	ld a,ERRID_NOCOMMA
	jp ErrorHandler
#endmacro

ERRID_NODOLLAR = 11

#macro ERR_NODOLLAR
	ld a,ERRID_NODOLLAR
	jp ErrorHandler
#endmacro

ERRID_NOLBRACKET = 12

#macro ERR_NOLBRACKET
	ld a,ERRID_NOLBRACKET
	jp ErrorHandler
#endmacro

ERRID_NORBRACKET = 13

#macro ERR_NORBRACKET
	ld a,ERRID_NORBRACKET
	jp ErrorHandler
#endmacro

ERRID_NOTREF = 14

#macro ERR_NOTREF
	ld a,ERRID_NOTREF
	jp ErrorHandler
#endmacro

ERRID_STOP = 15

#macro ERR_STOP
	ld a,ERRID_STOP
	jp ErrorHandler
#endmacro

ERRID_SYNTAX = 16

#macro ERR_SYNTAX
	ld a,ERRID_SYNTAX
	jp ErrorHandler
#endmacro

ERRID_TODO = 17

#macro ERR_TODO
	ld a,ERRID_TODO
	jp ErrorHandler
#endmacro

ERRID_UNKNOWNVAR = 18

#macro ERR_UNKNOWNVAR
	ld a,ERRID_UNKNOWNVAR
	jp ErrorHandler
#endmacro

