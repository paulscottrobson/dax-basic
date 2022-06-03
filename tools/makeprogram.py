# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		makeprogram.py
#		Purpose :	Converts code to program
#		Date :		3rd June 2022
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

from tokenise import *
import os,sys

# *******************************************************************************************
#
# 							Tokenised BASIC program class
#
# *******************************************************************************************

class BasicProgram(object):
	def __init__(self,fileName = None):
		self.code = []
		self.nextLineNumber = 1
		self.tokeniser = Tokeniser()
		if fileName is not None:
			line = 1
			for s in open(fileName).readlines():
				if s.strip() != "":
					self.addLine(s.strip())
					line += 1
	#
	# 		Add a line, optional line number
	#
	def addLine(self,text,lineNumber = None):
		if text.find("//") >= 0:
			text = text[:text.find("//")].strip()
			if text == "":
				return
		lineNumber = self.nextLineNumber if lineNumber is None else lineNumber
		assert text.strip() != "" and lineNumber > 0 and lineNumber <= 65535
		self.nextLineNumber = lineNumber + 1
		lineCode = [0,lineNumber & 0xFF,lineNumber >> 8] + self.tokeniser.tokeniseString(text) + [0x80]
		lineCode[0] = len(lineCode)
		self.code += lineCode
		return self
	#
	# 		Write output file 
	#
	def write(self,fileName = "testprogram.asm"):
		f = ("../source/generated/"+fileName).replace("/",os.sep)
		h = open(f,"w")
		h.write(";\n;\tThis code automatically generated.\n;\n")
		h.write("TestProgram:\n")
		h.write("\t.db\t{0},$00\n".format(",".join(["${0:02x}".format(x) for x in self.code])))
		h.close()

if __name__ == "__main__":
	if len(sys.argv) != 2:
		assert "Bad makeprogram.py invocation"
	b = BasicProgram(sys.argv[-1].replace("/",os.sep))
	b.write()		