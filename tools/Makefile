ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

SOURCE=..$(S)source$(S)
BASCODE = basic/test.bas 
TESTCODE = basic/_gen.bas

all: common 
	python makeprogram.py $(BASCODE) 

intmath: common
	python tests$(S)intmath.py >$(TESTCODE)
	python makeprogram.py  $(TESTCODE)

compare: common
	python tests$(S)compare.py >$(TESTCODE)
	python makeprogram.py  $(TESTCODE)

unary: common
	python tests$(S)unary.py >$(TESTCODE)
	python makeprogram.py  $(TESTCODE)

brackets: common
	python tests$(S)brackets.py >$(TESTCODE)
	python makeprogram.py  $(TESTCODE)
	
variables: common
	python tests$(S)variables.py >$(TESTCODE)
	python makeprogram.py  $(TESTCODE)
	
common:
	python errorgen.py en
	python keywords.py 
	python scanner.py $(SOURCE)
