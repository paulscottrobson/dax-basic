// ****************************************************************************
// ****************************************************************************
//
//		Name:		hardware_emu.c
//		Purpose:	Hardware Emulation (Emulator Specific)
//		Created:	1st April 2022
//		Author:		Paul Robson (paul@robsons.org.uk)
//
// ****************************************************************************
// ****************************************************************************

#include "sys_processor.h"
#include "hardware.h"
#include "gfx.h"
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <dirent.h>

#include <stdlib.h>
#include "gfx.h"

//
//		Really annoying.
//
#ifdef LINUX
#define MKSTORAGE()	mkdir("storage", S_IRWXU)
#else
#define MKSTORAGE()	mkdir("storage")
#endif

static BYTE8 m7Buffer[65536];
static int m7BufferPtr = -1;

// ****************************************************************************
//
//								Write to VRAM
//
// ****************************************************************************

void HWXWriteVRAM(WORD16 address,BYTE8 data) {
	// Does nothing, debugger updates display.
}

// ****************************************************************************
//								  Sync CPU
// ****************************************************************************

void HWXSyncImplementation(LONG32 iCount) {
	if ((SDL_GetModState() & KMOD_LCTRL) != 0 && 
		 SDL_GetKeyboardState(NULL)[SDL_SCANCODE_ESCAPE] != 0) CPUReset();			/* Ctrl+ESC is Reset */
}

// ****************************************************************************
//						Get System time in 1/1000s
// ****************************************************************************

WORD16 HWXGetSystemClock(void) {
	//printf("%d ",GFXTimer());
	return (GFXTimer()) & 0xFFFF;
}

// ****************************************************************************
// 						Set frequency of beeper,0 = off
// ****************************************************************************

void HWXSetFrequency(int frequency) {
	GFXSetFrequency(frequency);
}

// ****************************************************************************
//							 Check key pressed
// ****************************************************************************

int  HWXIsKeyPressed(int keyNumber) {
	return GFXIsKeyPressed(keyNumber);
}

// ****************************************************************************
//								Load file in
// ****************************************************************************

WORD16 HWXLoadFile(char * fileName,BYTE8 *target) {
	char fullName[128];
	if (fileName[0] == 0) return 1;
	MKSTORAGE();
	sprintf(fullName,"%sstorage%c%s",SDL_GetBasePath(),FILESEP,fileName);
	FILE *f = fopen(fullName,"rb");
	//printf("%s\n",fullName);
	if (f != NULL) {
		while (!feof(f)) {
			BYTE8 data = fgetc(f);
			*target++ = data;
		}
		fclose(f);
	}
	return (f != NULL) ? 0 : 1;
}

// ****************************************************************************
//								Save file out
// ****************************************************************************

WORD16 HWXSaveFile(char *fileName,WORD16 start,WORD16 size) {
	char fullName[128];
	MKSTORAGE();
	sprintf(fullName,"%sstorage%c%s",SDL_GetBasePath(),FILESEP,fileName);
	FILE *f = fopen(fullName,"wb");
	if (f != NULL) {
		fputc(start & 0xFF,f);
		fputc(start >> 8,f);
		while (size != 0) {
			size--;
			WORD16 d = CPUReadMemory(start++);
			fputc(d & 0xFF,f);
			fputc(d >> 8,f);
		}
		fclose(f);
	}
	return (f != NULL) ? 0 : 1;
}

// ****************************************************************************
//							  Load Directory In
// ****************************************************************************

void HWXLoadDirectory(BYTE8 *target) {
	DIR *dp;
	struct dirent *ep;
	char fullName[128];
	MKSTORAGE();
	sprintf(fullName,"%sstorage",SDL_GetBasePath());
	dp = opendir(fullName);
	if (dp != NULL) {
		while (ep = readdir(dp)) {
			if (ep->d_name[0] != '.') {
				char *p = ep->d_name;
				while (*p != '\0') *target++ =*p++;
				*target++ = '\0';
			}
		}
		closedir(dp);
	}
	*target = '\0';
}

// ****************************************************************************
// 								Import M7 Source
// ****************************************************************************

BYTE8 HWXImportM7Source(void) {
	if (m7BufferPtr < 0) {
		FILE *f = fopen("m7source.bin","rb");
		fread(m7Buffer,1,sizeof(m7Buffer),f);
		fclose(f);
		m7BufferPtr = 0;
	}
	if (m7Buffer[m7BufferPtr] == 0) return 0;
	return m7Buffer[m7BufferPtr++];
}
