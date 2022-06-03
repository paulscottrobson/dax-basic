# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		unary.py
#		Purpose :	Unary testing
#		Date :		3rd June 2022
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

from testobject import *
import math

# *******************************************************************************************
#
#								Unary operator testing
#
# *******************************************************************************************

class UnaryOperators(TestObject):

	def getPV(self,offset):
		return offset-6+0x41

	def make(self,op):
		n1 = self.getInteger()
		s1 = self.getString()

		if op == "-":
			print("assert -{0} = {1}".format(n1,-n1))

		if op == "not":
			n1 = n1 & 0xFFFFFFFF
			print("assert not({0}) = {1}".format(n1,n1 ^ 0xFFFFFFFF))

		if op == "?":
			p = random.randint(6,20)
			print("assert ?(page+{0}) = {1}".format(p,self.getPV(p)))

		if op == "!":
			v2 = random.randint(6,20)
			r = self.getPV(v2)+(self.getPV(v2+1) << 8)+(self.getPV(v2+2) << 16)+(self.getPV(v2+3) << 24)
			print("assert !(page+{0}) = &{1:x}".format(v2,r))

		if op == "$":
			v2 = random.randint(6,20)
			r = "".join([chr(65-6+n) for n in range(v2,0x20)])
			r = '"'+r+'"'
			print("assert $(page+{0}) = {1}".format(v2,r))

		if op == "&":
			n1 = n1 & 0xFFFFFFFF
			print("assert &{0:x} = {0}".format(n1))
		
		if op == "len":
			print("assert len(\"{0}\") = {1}".format(s1,len(s1)))

		if op == "asc":
			print("assert asc(\"{0}\") = {1}".format(s1,ord(s1[0]) if s1 != "" else 13))

		if op == "abs":
			print("assert abs({0}) = {1}".format(n1,abs(n1)))

		if op == "sgn":
			if n1 != 0:
				s = -1 if n1 < 0 else 1
			else:
				s = 0
			print("assert sgn({0}) = {1}".format(n1,s))

		if op == "chr":
			n1 = random.randint(64,90)
			print("assert chr$({0}) = \"{1}\"".format(n1,chr(n1)))

		if op == "val":
			print("assert val(\"{0}\") = {1}".format(n1,n1))

		if op == "str":
			print("assert str$({0}) = \"{0}\"".format(n1))

			
		return True 

	def getOperatorList(self):
		return "-,&,not,?,!,abs,len,asc,sgn,val,str,chr,$"

if __name__ == "__main__":
	UnaryOperators().create()

	