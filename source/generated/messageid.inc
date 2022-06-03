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

ERRID_DISABLED = 4

#macro ERR_DISABLED
	ld a,ERRID_DISABLED
	jp ErrorHandler
#endmacro

ERRID_DIVZERO = 5

#macro ERR_DIVZERO
	ld a,ERRID_DIVZERO
	jp ErrorHandler
#endmacro

ERRID_MEMORY = 6

#macro ERR_MEMORY
	ld a,ERRID_MEMORY
	jp ErrorHandler
#endmacro

ERRID_NOCOMMA = 7

#macro ERR_NOCOMMA
	ld a,ERRID_NOCOMMA
	jp ErrorHandler
#endmacro

ERRID_NORBRACKET = 8

#macro ERR_NORBRACKET
	ld a,ERRID_NORBRACKET
	jp ErrorHandler
#endmacro

ERRID_NOTREF = 9

#macro ERR_NOTREF
	ld a,ERRID_NOTREF
	jp ErrorHandler
#endmacro

ERRID_STOP = 10

#macro ERR_STOP
	ld a,ERRID_STOP
	jp ErrorHandler
#endmacro

ERRID_SYNTAX = 11

#macro ERR_SYNTAX
	ld a,ERRID_SYNTAX
	jp ErrorHandler
#endmacro

ERRID_TODO = 12

#macro ERR_TODO
	ld a,ERRID_TODO
	jp ErrorHandler
#endmacro

ERRID_UNKNOWNVAR = 13

#macro ERR_UNKNOWNVAR
	ld a,ERRID_UNKNOWNVAR
	jp ErrorHandler
#endmacro

