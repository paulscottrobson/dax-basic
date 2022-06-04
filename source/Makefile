ifeq ($(OS),Windows_NT)
include ..\documents\common.make
else
include ../documents/common.make
endif

all: ez80 z80 ti84

z80: prebuild
	$(CDEL) z80$(S)basic.bin $(CDELQ)
	$(ASSEMBLER) $(BUILDOPTS) -DAQUARIUS _build.asm build$(S)z80$(S)basic.bin $(ASMEND)

ez80: prebuild 
	$(CDEL) ez80$(S)basic.bin $(CDELQ)
	$(ASSEMBLER) $(BUILDOPTS) -E -DEZ80 -DCLEANEZ80 _build.asm build$(S)ez80$(S)basic.bin $(ASMEND)
	
ti84: prebuild 
	$(CDEL) ti84$(S)basic.8xp $(CDELQ)
	$(ASSEMBLER) $(BUILDOPTS) -E -DEZ80 -DTI84 _build.asm build$(S)ti84$(S)basic.8xp $(ASMEND)
	python ..$(S)tools$(S)checkfinal.py

prebuild:
	python ..$(S)tools$(S)makeinclude.py default.build >_build.asm
	make -C ..$(S)tools #variables

zrun: z80 
	$(AEMULATOR) build$(S)z80$(S)basic.bin go

trun: ti84
	$(EEMULATOR) build$(S)ti84$(S)basic.8xp
	
crun: ti84
	tilp --no-gui build$(S)ti84$(S)basic.8xp

dump:
	python ..$(S)tools$(S)dumpvars.py