# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		tokenise.py
#		Purpose :	Tokeniser worker
#		Date :		3rd June 2022
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

from keywords import *
import re

# *******************************************************************************************
#
#								Tokeniser Worker
#
# *******************************************************************************************

class Tokeniser(object):
	def __init__(self):
		self.keywords = Keywords()
	#
	# 		Tokenise one string. 
	#
	def tokeniseString(self,s):
		s = s.strip().replace("\t"," ")
		self.code = []
		while s != "":
			s = self.tokeniseOne(s).strip()
		return self.code 
	#
	# 		Tokenise a single element
	#
	def tokeniseOne(self,s):
		#
		# 		Decimal integer.
		#
		if s[0] >= "0" and s[0] <= "9":
			m = re.match("^(\\d+)(.*)$",s)
			self.tokeniseConstant(int(m.group(1)))
			return m.group(2)
		#
		# 		Hexadecimal integer.
		#
		if s[0] == "&":
			m = re.match("^\\&([0-9A-Fa-f]+)(.*)$",s)
			ok = self.tryKeywords("&")
			assert ok
			self.tokeniseConstant(int(m.group(1),16))
			return m.group(2)
		#
		# 		Quoted string.
		#
		if s[0] == '"':
			m = re.match('^\\"(.*?)\\"(.*)$',s)
			if m is None:
				raise "Missing closing quote "+s
			self.code.append(0x3F)
			self.code.append(len(m.group(1)))
			for c in m.group(1):
				self.code.append(ord(c))
			self.code.append(13)
			return m.group(2)
		#
		#		Identifier or Token (alphanumeric)
		#
		if (s[0].upper() >= "A" and s[0].upper() <= "Z") or s[0] == "." or s[0] == "_":
			m = re.match('^([A-Za-z0-9\\.\\_]+)\\s*(.*)$',s) 		
			word = m.group(1).upper()
			if not self.tryKeywords(word):
				self.tokeniseIdentifier(word)
			return m.group(2)
		#
		# 		Give up.
		#
		if len(s) >= 2 and self.tryKeywords(s[0:2]):
			return s[2:]
		if self.tryKeywords(s[0]):
			return s[1:]
		assert False,"Cannot tokenise "+s
	#
	# 		If a keyword exists in any table, output that, returns True if done.
	#
	def tryKeywords(self,kwd):
		info = self.keywords.find(kwd)
		if info is None:
			return False
		if info["set"] > 0:
			self.code.append(0x80+info["set"])
		self.code.append(info["id"])
		return True 
	#
	# 		Tokenise identifier
	#
	def tokeniseIdentifier(self,word):
		for c in word:
			if c >= "A" and c <= "Z":
				self.code.append(ord(c)-ord('A'))
			if c >= "0" and c <= "9":
				self.code.append(ord(c)-ord('0')+26)
			if c == '.':
				self.code.append(36)
			if c == "_":
				self.code.append(37)
	#
	# 		Tokenise one constant
	#
	def tokeniseConstant(self,n):
		if n >= 64:
			self.tokeniseConstant(n >> 6)
		self.code.append((n & 0x3F) | 0x40)
	#
	# 		Tokeniser tester.
	#
	def test(self,s):
		tb = self.tokeniseString(s)
		tb = " ".join(["{0:02x}".format(c) for c in tb])
		print("{0}\n\t{1}".format(s,tb))

if __name__ == "__main__":
	tk = Tokeniser()
	tk.test("42 5 63 66")
	tk.test("&2A &2FFF")
	tk.test("0\"Hello !\"0\"\"0")
	tk.test("a nexti lenx(")
	tk.test("next len( liSt")
	tk.test(">= > -22")
	tk.test("_a")
	tk.test("assert ?(PAGE+6)")