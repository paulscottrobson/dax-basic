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
					if s[0] >= '0' and s[0] <= '9':
						m = re.match("^([0-9]+)\\s*(.*)$",s)
						line = int(m.group(1))
						s = m.group(2).strip()
					if s != "":
						self.addLine(s.strip(),line)
						line += 1
	#
	# 		Add a line, optional line number
	#
	def addLine(self,text,lineNumber = None):
		#print(lineNumber,text)
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
	def write(self,fileName):
		f = fileName.replace("/",os.sep)
		h = open(f,"wb")
		h.write(bytes(self.code))
		h.close()

if __name__ == "__main__":
	if len(sys.argv) != 3:
		assert "Bad makeprogram.py invocation <src> <dax>"
	b = BasicProgram(sys.argv[1].replace("/",os.sep))
	b.write(sys.argv[2])		