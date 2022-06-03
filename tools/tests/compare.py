# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		compare.py
#		Purpose :	Comparison testing.
#		Date :		3rd May 2022
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

from testobject import *

# *******************************************************************************************
#
#							Comparitive testing
#
# *******************************************************************************************

class Comparisons(TestObject):
	def make(self,op):
		n = random.randint(0,2)
		v1 = self.getInteger()
		v2 = self.getInteger()
		if n == 1:
			v1 = self.getFloat()
			v2 = self.getFloat()
		if n == 2:
			v1 = self.getString()
			v2 = self.getString()

		if random.randint(0,5) == 0:
			v2 = v1

		if n != 2:
			s1 = str(v1)
			s2 = str(v2)
		else:
			s1 = '"'+v1+'"'
			s2 = '"'+v2+'"'
		op2 = op
		if op2 == "=":
			op2 = "=="
		if op2 == "<>":
			op2 = "!="
		result = "true" if eval(s1 + op2 + s2) != 0 else "false"
		print("assert ({0} {1} {2}) = {3}".format(s1,op,s2,result))
		return True 

	def getOperatorList(self):
		return "<,=,>,>=,<=,<>"

if __name__ == "__main__":
	Comparisons().create()