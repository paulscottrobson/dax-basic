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
	def getArrayName(self):
		Variable.arrayCount += 1
		return "ar_"+str(Variable.arrayCount)

Variable.arrayCount = 0

class BasicIntegerVariable(Variable):
	def createName(self):
		return chr(random.randint(0,25)+97)
	def createValue(self):
		return random.randint(-9999999,9999999)

class LongNameIntegerVariable(BasicIntegerVariable):
	def createName(self):
		s = BasicIntegerVariable.createName(self)
		v = "0123456789abcdefghijklmnopqrstuvwxyz._"
		for i in range(0,random.randint(1,5)):
			s = s + v[random.randint(0,len(v)-1)]
		return self.createName() if s.startswith("ar") else s

class StringMemoryVariable(LongNameIntegerVariable):
	def __init__(self):
		self.space = random.randint(5,12)
		LongNameIntegerVariable.__init__(self)
		print("dim {0}[{1}]".format(self.getName(),self.space+1))
		self.name = "$"+self.name
	#
	def createValue(self):
		return "".join([chr(random.randint(48,110)) for i in range(0,random.randint(0,self.space))])
	#
	def getDisplayValue(self):
		return '"'+self.getValue()+'"'

class ArrayVariable(LongNameIntegerVariable):
	def __init__(self):
		Variable.__init__(self)
		self.arraySize = random.randint(1,10)
		self.data = [ 0 ] * (self.arraySize+1)
		print("dim {0}({1})".format(self.getName(),self.arraySize))
	#
	def changeValue(self):
		i = random.randint(0,self.arraySize)
		v = self.createValue()
		self.data[i] = v
		return "{0}({1}) = {2}".format(self.getName(),i,v)
	#
	def checkValue(self):
		for i in range(0,self.arraySize+1):
			print("assert {0}({1}) = {2}".format(self.getName(),i,self.data[i]))
		return "rem \"\""

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
		if random.randint(0,6) == 0:
			return ArrayVariable()
		if random.randint(0,4) == 0:
			return StringMemoryVariable()
		if random.randint(0,2) != 0:
			return LongNameIntegerVariable() 
		return BasicIntegerVariable()

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
