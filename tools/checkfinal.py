# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		checkfinal.py
#		Purpose :	Checks the TI84 image doesn't go beyond D2:0C00
#		Date :		3rd June 2022
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import sys

src = [x for x in open("build/ti84/basic.lab").readlines() if x.find("FINALADDRESS") >= 0]
src = src[0].split("$")[1].strip()
if int(src,16) >= 0xD20C00:
	print("Bad TI84 executable "+src)
	sys.exit(1)

#
# 		I don't know why yet, but accessing memory past this address causes problems.
#