// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		sys_processor.cpp
//		Purpose:	Processor Emulation.
//		Created:	1st April 2022
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#include <stdio.h>
#include "sys_processor.h"
#include "sys_debug_system.h"
#include "hardware.h"

// *******************************************************************************************************************************
//														   Timing
// *******************************************************************************************************************************

#define FRAME_RATE		(60)														// Frames per second (50 arbitrary)
#define CYCLES_PER_FRAME (CYCLE_RATE / FRAME_RATE) 									// Cycles per frame.

// *******************************************************************************************************************************
//														CPU / Memory
// *******************************************************************************************************************************

static BYTE8 A,B,C,D,E,H,L;  														// Standard register
static WORD16 AFalt,BCalt,DEalt,HLalt; 												// Alternate data set.
static WORD16 PC,SP; 																// 16 bit registers
static WORD16 IX,IY; 																// IX IY accessed indirectly.

static BYTE8 s_Flag,z_Flag,c_Flag,h_Flag,n_Flag,p_Flag; 							// Flag Registers
static BYTE8 I,R,intEnabled; 														// We don't really bother with these much.
static BYTE8 highSpeed = 0; 														// High speed running.

static BYTE8 ramMemory[0x10000];													// Memory at $0000 upwards, 64k off

static LONG32 temp32;
static WORD16 temp16,temp16a,*pIXY;
static BYTE8 temp8,oldCarry;

static int cycles;																	// Cycle Count.
static WORD16 cyclesPerFrame = CYCLES_PER_FRAME;									// Cycles per frame

#define CYCLES(n) cycles -= (n)

static const BYTE8 kernel_rom[] = {
	#include "kernel_rom.h"
};

static BYTE8 character_rom[] = {
	#include "character_rom.h"
};

static WORD16 palette4[16] = { 
	0x000,0xC02,0x0B0,0xCB0,0x00B,0xB0C,0x0CA,0xFFF,
	0xBBB,0x4A9,0x828,0x016,0xBA5,0x493,0x712,0x000
};

// *******************************************************************************************************************************
//											 Memory and I/O read and write macros.
// *******************************************************************************************************************************

#define READ8(a) 	_Read(a)														// Basic Read
#define WRITE8(a,d)	_Write(a,d)														// Basic Write

#define READ16(a) 	(READ8(a) | ((READ8((a)+1) << 8)))								// Read 16 bits.
#define WRITE16(a,d) { WRITE8(a,(d) & 0xFF);WRITE8((a)+1,(d) >> 8); } 				// Write 16 bits

#define FETCH8() 	ramMemory[PC++]													// Fetch byte
#define FETCH16()	_Fetch16()	 													// Fetch word

static inline BYTE8 _Read(WORD16 address);											// Need to be forward defined as 
static inline void _Write(WORD16 address,BYTE8 data);								// used in support functions.

#define INPORT(p) 	HWReadPort(p)
#define OUTPORT(p,d) HWWritePort(p,d)

// *******************************************************************************************************************************
//											   Read and Write Inline Functions
// *******************************************************************************************************************************

static inline BYTE8 _Read(WORD16 address) {
	return ramMemory[address];							
}

static void _Write(WORD16 address,BYTE8 data) {
	if (address >= 0x3000 && (address < RAMPAKSIZE+0x4000 || address >= 0xC000)) {
		ramMemory[address] = data;
		if (address < 0x3800) HWXWriteVRAM(address,data);
	}
	if (address == 0x1000) { 														// POKE 4096,1 turns on fast mode.
		highSpeed = (data != 0);
	}
}

static inline WORD16 _Fetch16(void) {
	WORD16 w = ramMemory[PC] + (ramMemory[PC+1] << 8);
	PC += 2;
	return w;
}

// *******************************************************************************************************************************
//											 Support macros and functions
// *******************************************************************************************************************************

#ifdef INCLUDE_DEBUGGING_SUPPORT
#include <stdlib.h>
#define FAILOPCODE(g,n) exit(fprintf(stderr,"Opcode %02x in group %s\n",n,g))
#else
#define FAILOPCODE(g,n) {}
#endif

#include "cpu_support.h"

WORD16 CPUGetCycles(void) {
	return cycles;
}

BYTE8 *CPUGetUpper16kAddress(void) {
	return ramMemory+0xC000;
}

void CPUSetPC(WORD16 newPC) {
	PC = newPC;
}

BYTE8 CPUReadCharacterROM(BYTE8 nchar,BYTE8 row) {
	return character_rom[(((WORD16)nchar) << 3)+row];
}

WORD16 CPUReadPalette(BYTE8 colour) {
	return palette4[colour & 0x0F];
}

// *******************************************************************************************************************************
//														Reset the CPU
// *******************************************************************************************************************************

#ifdef INCLUDE_DEBUGGING_SUPPORT
static void CPULoadChunk(FILE *f,BYTE8* memory,int count);
#endif

void CPUReset(void) {
	HWReset();																		// Reset Hardware
	BuildParityTable();																// Build the parity flag table.
	for (int i = 0;i < sizeof(kernel_rom);i++) ramMemory[i] = kernel_rom[i]; 		// Copy the Kernel ROM
	PC = 0; 																		// Zero PC.
	highSpeed = 0;
}

// *******************************************************************************************************************************
//					Called on exit, does nothing on ESP32 but required for compilation
// *******************************************************************************************************************************

#ifdef INCLUDE_DEBUGGING_SUPPORT
#include "gfx.h"
void CPUExit(void) {	
	printf("Exited via $FFFF");
	GFXExit();
}
#else
void CPUExit(void) {}
#endif

// *******************************************************************************************************************************
//												Execute a single instruction
// *******************************************************************************************************************************

BYTE8 CPUExecuteInstruction(void) {
	#ifdef INCLUDE_DEBUGGING_SUPPORT
	if (PC == 0xFFFF) CPUExit();
	#endif
	BYTE8 opcode = FETCH8();														// Fetch opcode.
	switch(opcode) {																// Execute it.
		#include "_code_group_0.h"
		default:
			FAILOPCODE("-",opcode);
	}
	if (cycles >= 0 ) return 0;														// Not completed a frame.
	cycles = cycles + cyclesPerFrame * (highSpeed ? 16 : 1);						// Adjust this frame rate, up to x16 on HS
	HWSync();																		// Update any hardware
	return FRAME_RATE;																// Return frame rate.
}

BYTE8 CPUInVerticalSync(void) {
	return cycles < cyclesPerFrame / 6;
}

// *******************************************************************************************************************************
//												Read/Write Memory
// *******************************************************************************************************************************

BYTE8 CPUReadMemory(WORD16 address) {
	return READ8(address);
}

void CPUWriteMemory(WORD16 address,BYTE8 data) {
	WRITE8(address,data);
}

#ifdef INCLUDE_DEBUGGING_SUPPORT

// *******************************************************************************************************************************
//		Execute chunk of code, to either of two break points or frame-out, return non-zero frame rate on frame, breakpoint 0
// *******************************************************************************************************************************

BYTE8 CPUExecute(WORD16 breakPoint1,WORD16 breakPoint2) { 
	BYTE8 next;
	do {
		BYTE8 r = CPUExecuteInstruction();											// Execute an instruction
		if (r != 0) return r; 														// Frame out.
		next = CPUReadMemory(PC);
	} while (PC != breakPoint1 && PC != breakPoint2 && next != 0x76);				// Stop on breakpoint or $76 HALT break
	return 0; 
}

// *******************************************************************************************************************************
//									Return address of breakpoint for step-over, or 0 if N/A
// *******************************************************************************************************************************

WORD16 CPUGetStepOverBreakpoint(void) {
	BYTE8 op = CPUReadMemory(PC); 	
	if (op == 0xCD || (op & 0xC7) == 0xC4) return PC+3; 							// CALL/CALL xx
	if ((op & 0xC7) == 0xC7) return PC+1;											// RST
	return 0;																		// Do a normal single step
}

void CPUEndRun(void) {
	FILE *f = fopen("memory.dump","wb");
	fwrite(ramMemory,1,sizeof(ramMemory),f);
	fclose(f);
}

void CPULoadBinary(char *fileName) {
	FILE *f = fopen(fileName,"rb");
//	BYTE8 *romSpace = CPUGetUpper16kAddress();
//	for (int i = 0;i < 0x4000;i++) romSpace[i] = 0;
	if (f != NULL) {
		fread(ramMemory+0x4000,1,0xC000,f); 										// Load binary to $4000
		fclose(f);
		ramMemory[0x49] = 0xC3; 													// Jump to $4000 after SP initialise and CLS
		ramMemory[0x4A] = 0x00;
		ramMemory[0x4B] = 0x40;
	}
}

// *******************************************************************************************************************************
//											Retrieve a snapshot of the processor
// *******************************************************************************************************************************

static CPUSTATUS st;																	// Status area

CPUSTATUS *CPUGetStatus(void) {
	st.AF = AF();
	st.BC = BC();
	st.DE = DE();
	st.HL = HL();
	st.AFalt = AFalt;
	st.BCalt = BCalt;
	st.DEalt = DEalt;
	st.HLalt = HLalt;
	st.PC = PC;
	st.SP = SP;
	st.IX = IX;
	st.IY = IY;
	st.IE = intEnabled;
	st.cycles = cycles;
	return &st;
}

#endif