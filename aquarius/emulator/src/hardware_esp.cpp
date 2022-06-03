// ****************************************************************************
// ****************************************************************************
//
//		Name:		hardware_esp.c
//		Purpose:	Hardware Emulation (ESP32 Specific)
//		Created:	1st April 2022
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ****************************************************************************
// ****************************************************************************

#include <Arduino.h>
#include "sys_processor.h"
#include "gfxkeys.h"
#include "hardware.h"
#include "espinclude.h"

int HWESPGetScanCode(void);
void HWESPSetFrequency(int freq);
void HWXClearScreen(int colour);
void HWXPlotCharacter(int x,int y,int colour,int bgr,BYTE8 ch);

static const int scan_to_gfx[] = {
#include "_scan_to_gfx.h"
};

// ****************************************************************************
//							  Sync Hardware
// ****************************************************************************

static BYTE8 keyStatus[256] = {0};
static int shift = 0;
static int release = 0;
static int lastKey = 0;

void HWXSyncImplementation(LONG32 iCount) {
	int scanCode = HWESPGetScanCode();
	while (scanCode > 0) {
		if (scanCode == 0xE0) {
			shift = 0x80;
		} 
		else if (scanCode == 0xF0) {
			release = 1;
		}
		else {
			int isDown = (release == 0);
			scanCode = (scanCode & 0x7F) | shift;
			scanCode = scan_to_gfx[scanCode];
			//writeCharacter(scanCode & 0x0F,(scanCode >> 4)+2,isDown ? '*' : '.');
			keyStatus[scanCode] = isDown;
			lastKey = isDown ? scanCode : -scanCode;
			shift = 0x00;
			release = 0x00;
		}
		scanCode = HWESPGetScanCode();
		keyStatus[GFXKEY_SHIFT] = keyStatus[GFXKEY_LSHIFT]|keyStatus[GFXKEY_RSHIFT];
		keyStatus[GFXKEY_CONTROL] = keyStatus[GFXKEY_LCTRL]|keyStatus[GFXKEY_RCTRL];
	}
	if (keyStatus[GFXKEY_CONTROL] && keyStatus[GFXKEY_ESCAPE]) CPUReset();			/* Ctrl+ESC is Reset */
}

void HWXLog(char *logText) {
	Serial.println(logText);
}

// ****************************************************************************
//							Write to VRAM
// ****************************************************************************

void HWXWriteVRAM(WORD16 address,BYTE8 data) {
	if (address != 0x3400) {
		int p = (address & 0x3FF);
		if (p >= 0x28 && p < 40*24+0x28) {
			int colByte = CPUReadMemory(0x3400+p);
			HWXPlotCharacter(p % 40,p / 40-1,colByte >> 4,colByte & 0x0F,CPUReadMemory(0x3000+p));
		}
	} else {
		HWXClearScreen(data & 0x0F);
		for (int i = 0x3028;i < 0x3400;i++) {
		 	HWXWriteVRAM(i,CPUReadMemory(i));
		}
	}
}

// ****************************************************************************
//					Check if key pressed (GFXKEY values)
// ****************************************************************************

int  HWXIsKeyPressed(int key) {
	return keyStatus[key] != 0;
}

// ****************************************************************************
//						Get System time in 1/100s
// ****************************************************************************

WORD16 HWXGetSystemClock(void) {
	return millis() & 0xFFFF;
}

// ****************************************************************************
//	 						Set sound pitch, 0 = off
// ****************************************************************************

void HWXSetFrequency(int frequency) {
	HWESPSetFrequency(frequency);
}

// ****************************************************************************
// 									Load file
// ****************************************************************************

WORD16 HWXLoadFile(char * fName,BYTE8 *target) {
	char fullName[64];
	sprintf(fullName,"/%s",fName);									// SPIFFS doesn't do dirs
	//fabgl::suspendInterrupts();										// And doesn't like interrupts
	WORD16 exists = SPIFFS.exists(fullName);						// If file exitst
	if (exists != 0) {
		File file = SPIFFS.open(fullName);							// Open it
		while (file.available()) {									// Read body in
			BYTE8 b = file.read();
			*target++ = b;
		}
		file.close();
	}
	//fabgl::resumeInterrupts();
	return exists == 0;
}

// ****************************************************************************
//						Directory of SPIFFS root
// ****************************************************************************

void HWXLoadDirectory(BYTE8 *target) {
	//fabgl::suspendInterrupts();
  	File root = SPIFFS.open("/");									// Open directory
   	File file = root.openNextFile();								// Work throughfiles
   	while(file){
       	if(!file.isDirectory()){									// Write non directories out
           	const char *p = file.name();							// Then name
           	while (*p != '\0') {	
           		if (*p != '/') *target++ = *p;
           		p++;
           	}
	       	*target++ = '\0';
       	}
       	file.close();
       	file = root.openNextFile();
   	}
    *target = '\0';
    root.close();
	//fabgl::resumeInterrupts();
}

// ****************************************************************************
// 								Import M7 Source
// ****************************************************************************

BYTE8 HWXImportM7Source(void) {
	return 0;
}
