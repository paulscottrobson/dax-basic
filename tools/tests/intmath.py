# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		intmath.py
#		Purpose :	Integer Mathematics testing.
#		Date :		3rd June 2022
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

from testobject import *

# *******************************************************************************************
#
#							Integer Mathematics testing
#
# *******************************************************************************************

class IntegerMathematics(TestObject):
	def getPV(self,offset):
		return offset-6+0x41

	def make(self,op):
		v1 = self.getInteger()
		v2 = self.getInteger()
		if v2 == 0 and (op == "/" or op == "mod"):
			return False 
		if op == "!" or op == "?":
			v2 = abs(v2) % 15+6
			v1 = "page"
		if op == "+":
			r = v1+v2
		if op == "-":
			r = v1-v2
		if op == "*":
			r = v1*v2
		if op == "/":
			s1 = 1 if v1 > 0 else -1
			s2 = 1 if v2 > 0 else -1
			r = abs(v1)//abs(v2)*s1*s2
		if op == "mod":
			r = abs(v1) % abs(v2)
		if op == "and":
			r = v1 & v2
		if op == "or":
			r = v1 | v2
		if op == "eor":
			r = v1 ^ v2
		if op == "?":
			r = self.getPV(v2)
		if op == "!":
			r = self.getPV(v2)+(self.getPV(v2+1) << 8)+(self.getPV(v2+2) << 16)+(self.getPV(v2+3) << 24)

		r = r & 0xFFFFFFFF
		if (r & 0x80000000) != 0:
			r = r - 0x100000000
		print("assert ({0} {1} {2}) = {3}".format(v1,op,v2,r))
		return True 

	def getOperatorList(self):
		return "+,-,*,/,mod,and,or,eor,?,!"

if __name__ == "__main__":
	IntegerMathematics().create()