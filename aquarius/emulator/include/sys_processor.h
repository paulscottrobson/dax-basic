// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		sys_processor.h
//		Purpose:	Processor Emulation (header)
//		Created:	1st April 2022
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#ifndef _PROCESSOR_H
#define _PROCESSOR_H

#define CYCLE_RATE 		(3540*1000)													// Cycles per second (3.54Mhz)

#define RAMPAKSIZE  	(0xC000) 												 	// Size of RAM Pack (e.g. excluding $3000-$3FFF)

typedef unsigned short WORD16;														// 8 and 16 bit types.
typedef unsigned char  BYTE8;
typedef unsigned int   LONG32;														// 32 bit type.

#define DEFAULT_BUS_VALUE (0xFF)													// What's on the bus if it's not memory.

#define AKEY_BACKSPACE	(0x5F)														// Apple Backspace

void CPUReset(void);
BYTE8 CPUExecuteInstruction(void);
BYTE8 CPUWriteKeyboard(BYTE8 pattern);
BYTE8 CPUReadMemory(WORD16 address);
BYTE8 *CPUGetUpper16kAddress(void);
void CPUWriteMemory(WORD16 address,BYTE8 data);
WORD16 CPUGetCycles(void);
void CPUSetPC(WORD16 newPC);
BYTE8 CPUReadCharacterROM(BYTE8 nchar,BYTE8 row);
WORD16 CPUReadPalette(BYTE8 colour);
BYTE8 CPUInVerticalSync(void);

#ifdef INCLUDE_DEBUGGING_SUPPORT													// Only required for debugging

typedef struct __CPUSTATUS {
	int AF,BC,DE,HL;
	int AFalt,BCalt,DEalt,HLalt;
	int IE,PC,SP,IX,IY,cycles;
} CPUSTATUS;

CPUSTATUS *CPUGetStatus(void);
BYTE8 CPUExecute(WORD16 breakPoint1,WORD16 breakPoint2);
WORD16 CPUGetStepOverBreakpoint(void);
void CPUEndRun(void);
void CPULoadBinary(char *fileName);
void CPUExit(void);

#endif
#endif