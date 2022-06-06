# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		variables.py
#		Purpose :	Variable allocation and testing
#		Date :		4th June 2022
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

from testobject import *

# *******************************************************************************************
#
#								Variable classes
#
# *******************************************************************************************

class Variable:
	def __init__(self):
		self.name = self.createName()
		self.value = self.createValue()		
	def getName(self):
		return self.name.lower()
	def getValue(self):
		return self.value 
	def getDisplayValue(self):
		return self.getValue()
	def changeValue(self):
		self.value = self.createValue()		
		return "{0} = {1}".format(self.getName(),self.getDisplayValue())
	def checkValue(self):
		return "assert {0} = {1}".format(self.getName(),self.getDisplayValue())

class BasicIntegerVariable(Variable):
	def createName(self):
		return chr(random.randint(0,25)+97)
	def createValue(self):
		return random.randint(-99999,99999)

class LongNameIntegerVariable(BasicIntegerVariable):
	def createName(self):
		s = BasicIntegerVariable.createName(self)
		v = "0123456789abcdefghijklmnopqrstuvwxyz._"
		for i in range(0,random.randint(1,5)):
			s = s + v[random.randint(0,len(v)-1)]
		return self.createName() if s.startswith("ar") else s


# *******************************************************************************************
#
#							Assignment/variable testing
#
# *******************************************************************************************

class Assignments(TestObject):
	def header(self):
		TestObject.header(self)
		self.variables = []
		names = {}
		while len(self.variables) < 40:
			v = self.createNewVariable()
			while v.getName() in names:
				v = self.createNewVariable()
			self.variables.append(v)
			names[v.getName()] = v
			print(v.changeValue())

	def createNewVariable(self):
		return LongNameIntegerVariable() if random.randint(0,2) != 0 else BasicIntegerVariable()

	def footer(self):
		for v in self.variables:
			print(v.checkValue())
		TestObject.footer(self)

	def make(self,op):
		n = random.randint(0,len(self.variables)-1)
		print(self.variables[n].changeValue())
		return True 

if __name__ == "__main__":
	Assignments().create()
