ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

SOURCE=..$(S)source$(S)
BASCODE = basic/test.bas 
TESTCODE = basic/_gen.bas
TARGET = ../source/testprogram/testprogram.dax

all: common 
	python makeprogram.py $(BASCODE)  $(TARGET)

intmath: common
	python tests$(S)intmath.py >$(TESTCODE)
	python makeprogram.py  $(TESTCODE) $(TARGET)

compare: common
	python tests$(S)compare.py >$(TESTCODE)
	python makeprogram.py  $(TESTCODE) $(TARGET)

unary: common
	python tests$(S)unary.py >$(TESTCODE)
	python makeprogram.py  $(TESTCODE) $(TARGET)

brackets: common
	python tests$(S)brackets.py >$(TESTCODE)
	python makeprogram.py  $(TESTCODE) $(TARGET)
	
variables: common
	python tests$(S)variables.py >$(TESTCODE)
	python makeprogram.py  $(TESTCODE) $(TARGET)
	
common:
	python errorgen.py en
	python keywords.py 
	python scanner.py $(SOURCE)
