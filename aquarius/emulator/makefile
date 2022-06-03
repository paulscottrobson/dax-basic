ifeq ($(OS),Windows_NT)
include ..\..\documents\common.make
else
include ../../documents/common.make
endif

APPNAME = aqnext$(APPSTEM)

SOURCES = 	src$(S)sys_processor.o  framework$(S)main.o framework$(S)gfx.o framework$(S)debugger.o \
			src$(S)sys_debug_aqnext.o src$(S)hardware.o src$(S)hardware_emu.o
  
CC = g++

.PHONY: all clean emulator test prebuild 

all: emulator
#	.$(S)$(APPNAME) 

run: emulator 
	.$(S)$(APPNAME) roms$(S)aliens.cqc go

debug: emulator 
	.$(S)$(APPNAME) 
	
asmash : emulator 
	.$(S)aqnext storage$(S)asmash.cqc run

tarmin : emulator 
	.$(S)aqnext "..$(S)roms$(S)add tarmin.bin.decoded" run

test : emulator
	$(CDEL) memory.dump $(CDELQ)
	spasm  -T -L test.asm test.bin
	.$(S)$(APPNAME) test.bin

emulator: prebuild $(APPNAME)
#	$(CCOPY) $(APPNAME) ..$(S)..$(S)bin$(S) $(CCOPYQ)

prebuild:
	make -C ..$(S)z80
	make -C ..$(S)roms
	$(CCOPY) ..$(S)z80$(S)code$(S)*.h cpu
	$(CCOPY) ..$(S)roms$(S)*.h roms

%.o:%.cpp
	$(CC) $(CXXFLAGS) -D INCLUDE_DEBUGGING_SUPPORT -I cpu -I framework -I include -I roms -c -o $@ $<

clean:
	$(CDEL) $(APPNAME) 
	$(CDEL) src$(S)*.o 
	$(CDEL) framework$(S)*.o

$(APPNAME): $(SOURCES) include$(S)cpu_support.h
	$(CC) $(SOURCES) $(LDFLAGS) $(SDL_LDFLAGS) -o $@
	

