// *******************************************************************************************************************************
// *******************************************************************************************************************************
//
//		Name:		hardware.c
//		Purpose:	Hardware Emulation
//		Created:	1st April 2022
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// *******************************************************************************************************************************
// *******************************************************************************************************************************

#include "sys_processor.h"
#include "hardware.h"
#include "gfx.h"
#include "gfxkeys.h"
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

static int soundPortState = 0;
static int lastToggleCycleTime = 0;
static int cycleToggleCount = 0;
static int cycleToggleTotal = 0;
static int tapeOffset = 0;

static void HWLoadDirectoryAsBASIC(void);

// *******************************************************************************************************************************
//												Reset Hardware
// *******************************************************************************************************************************

void HWReset(void) {	
	HWXSetFrequency(0);
	tapeOffset = 0;
	lastToggleCycleTime = 0;
}

// *******************************************************************************************************************************
//												  Reset CPU
// *******************************************************************************************************************************

#include <stdio.h>
void HWSync(void) {
	HWXSyncImplementation(0);
	if (lastToggleCycleTime != 0 && cycleToggleCount > 0) {
		//
		//		The SOUND actual frequency is Clock Frequency (3.54Mhz) / 64 / Sound parameter.
		//
		int frequency = CYCLE_RATE/2*cycleToggleCount/cycleToggleTotal;
//		printf("%d\n",frequency);
		HWXSetFrequency(frequency);
	} else {
		HWXSetFrequency(0);
	}
	lastToggleCycleTime = 0;
}

// *******************************************************************************************************************************
//												Port Read/Write
// *******************************************************************************************************************************

BYTE8 HWReadPort(WORD16 addr) {
	BYTE8 v = 0xFF;
	BYTE8 port = addr & 0xFF;

	if (port < 4) {  							// 0-3 gets the 0,1,2 and 3rd byte of the time in ms.
		int n = GFXTimer()/10;
		v = (n >> (port * 8)) & 0xFF;
	}

	if (port == 0xFD) {
		v = CPUInVerticalSync() ? 1 : 0;
	}
	if (port == 0xFF) {
		v = 0;
		for (int i = 0;i < 8;i++) {
			if ((addr & (0x0100 << i)) == 0) {
				v |= HWGetKeyboardRow(i);
			}
		}
		v ^= 0xFF;			
	}
	return v;
}

void HWWritePort(WORD16 addr,BYTE8 data) {
	BYTE8 port = addr & 0xFF;

	if (port == 0xFC && soundPortState != (data & 1)) {
		soundPortState = (data & 1);
		if (lastToggleCycleTime == 0) {
			cycleToggleCount = 0;
			cycleToggleTotal = 0;
		} else {
			cycleToggleCount++;
			cycleToggleTotal += abs(lastToggleCycleTime - CPUGetCycles());
		}
		lastToggleCycleTime = CPUGetCycles();
	}
}

// ****************************************************************************
//
//							Key codes for the ports
//
// ****************************************************************************

static int keys[][8] = {
	{ '=',GFXKEY_BACKSPACE,'@',GFXKEY_RETURN,';','.',0,0 },
	{ '-','/','0','P','L',',',0,0 },
	{ '9','O','K','M','N','J',0,0 },
	{ '8','I','7','U','H','B',0,0 },
	{ '6','Y','G','V','C','F',0,0 },
	{ '5','T','4','R','D','X',0,0 },
	{ '3','E','S','Z',' ','A',0,0 },
	{ '2','W','1','Q',GFXKEY_SHIFT,GFXKEY_CONTROL,0,0 }
};

// ****************************************************************************
//					Get the keys pressed for a particular row
// ****************************************************************************

int HWGetKeyboardRow(int row) {
	int word = 0;
	int p = 0;
	while (keys[row][p] != 0) {
		if (HWXIsKeyPressed(keys[row][p])) word |= (1 << p);
		p++;
	}
	return word;
}

// *******************************************************************************************************************************
// 									   Tape interface fake instructions
// *******************************************************************************************************************************

void HWSetTapeName(void) {
	char buffer[12];
	//
	// 		Get the filename in LC
	//
	for (int i = 0;i < 6;i++) buffer[i] = tolower(CPUReadMemory(LOADFILENAME+i));
	buffer[6] = '\0';
	strcat(buffer,".cqc");
	//
	// 		Load it into the 16k "ROM" area. If it's actually a cartridge we'll reset it.
	//
	//printf("Actually want file %s\n",buffer);
	HWXLoadFile(buffer,CPUGetUpper16kAddress());
	//
	// 		If it is really a cartridge, then reset the PC
	//
	if (CPUReadMemory(0xE005) == 0x9C && CPUReadMemory(0xE007) == 0xB0 && CPUReadMemory(0xE009) == 0x6C &&
		CPUReadMemory(0xE00B) == 0x64 && CPUReadMemory(0xE00D) == 0xA8 && CPUReadMemory(0xE00F) == 0x70) {
		CPUReset();
	}
	//
	// 		No file name (e.g. directory)
	//
	if (CPUReadMemory(LOADFILENAME) == 0) {
		HWLoadDirectoryAsBASIC();
		CPUSetPC(0x0402); 
	}
	//
	// 		BASIC doesn't know it now. So it will load whatever we give it.
	//
	CPUWriteMemory(LOADFILENAME,0x00);
	//
	// 		Rewind the tape offset.
	//
	tapeOffset = 0;
}

void HWReadTapeHeader(void) {
	BYTE8 b;
	while(b = HWReadTapeByte(),b == 0x00) {}
	while(b = HWReadTapeByte(),b == 0xFF) {}
}

BYTE8 HWReadTapeByte(void) {
	if (tapeOffset == 0x4000) {
		CPUSetPC(0x1CA2);
	}
	BYTE8 b = *(CPUGetUpper16kAddress()+tapeOffset);
	tapeOffset++;
	return b;
}

// ****************************************************************************
//							Load Directory as BASIC
// ****************************************************************************

static void HWLoadDirectoryAsBASIC(void) {
	int basicPtr = CPUReadMemory(0x384F)+CPUReadMemory(0x3850)*256; 						// Basic program starts here.
	int pBasicEnd = 0x38D6; 																// End pointer here.
	int lineNumber = 1000;
	char line[16],name[16];
	BYTE8 *storeAddr = CPUGetUpper16kAddress();
	HWXLoadDirectory(storeAddr);
	char *store = (char *)storeAddr;

	while (*store != '\0') {
		if (strlen(store) > 4 && strcmp(store+strlen(store)-4,".cqc") == 0) {
			strcpy(name,store);
			name[strlen(name)-4] = '\0';
			sprintf(line,"%c\" %-6s\"",0x95,name);
			if (lineNumber % 5 != 4) strcat(line,";");
			int endLine = basicPtr + 4 + 1 + strlen(line);
			CPUWriteMemory(basicPtr,endLine & 0xFF); 										// Write out the next pointer
			CPUWriteMemory(basicPtr+1,endLine >> 8);
			CPUWriteMemory(basicPtr+2,lineNumber & 0xFF);									// Write out the line number.
			CPUWriteMemory(basicPtr+3,lineNumber >> 8);
			for (int i = 0;i < strlen(line)+1;i++) { 										// Copy string and terminating zero.
				CPUWriteMemory(basicPtr+4+i,line[i]);
			}
			lineNumber += 1; 																// Next line number.
			basicPtr = endLine; 															// Go to next line.
		}
		while (*store != '\0') store++;
		store++;
	}
	CPUWriteMemory(basicPtr,0);																// Write end marker
	CPUWriteMemory(basicPtr+1,0);
	basicPtr += 2;
	CPUWriteMemory(pBasicEnd,basicPtr & 0xFF);												// Write end of program.
	CPUWriteMemory(pBasicEnd+1,basicPtr >> 8); 
}

// ****************************************************************************
//								New Prompt
// ****************************************************************************

void HWLoadPrompt(void) {
	const char *s = "Aquarius Emulator v0.0 (15-10-21)\r\n\r\nWritten by Paul Robson\r\n\r\nBASIC (C) Microsoft 1982 S2\r\n\r\n";
	for (int i = 0;i < strlen(s)+1;i++) CPUWriteMemory(0x4000+i,s[i]);
}