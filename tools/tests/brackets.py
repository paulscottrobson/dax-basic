# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		brackets.py
#		Purpose :	Test bracketed expression.
#		Date :		3rd June 2022
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

from testobject import *

# *******************************************************************************************
#
#								Parenthesis testing
#
# *******************************************************************************************

class Parenthesis(TestObject):

	def selectOperators(self):
		operators = "+,-,*,"
		operators += ["|","&","^"][random.randint(0,2)]
		self.operators = operators.split(",")
	#
	def createExpression(self,level):
		if level == 0: 													# level 0 = single term.
			return str(random.randint(-100,100))
		elements = []
		for i in range(0,random.randint(2,4)):							# build a chain at this level.
			elements.append(self.createExpression(level-1))
			elements.append(self.operators[random.randint(0,len(self.operators)-1)])
		expr = " ".join(elements[:-1])
		return "("+expr+")"
	#
	def evaluate(self,expr):
		return eval(expr)
	#
	def basicFormat(self,expr):
		expr = expr.replace("&","and").replace("|","or").replace("^","eor")
		return expr
	#
	def createValidExpression(self,level):
		try:
			expr = self.createExpression(level)
			self.evaluate(expr)
			return expr
		except ValueError:
			return self.createValidExpression(level)

	def make(self,op):
		self.selectOperators()
		x = self.createValidExpression(random.randint(1,3))
		print("assert {0} = {1}".format(self.basicFormat(x),self.evaluate(x)))
		return True 

	def getOperatorList(self):
		return "+"

if __name__ == "__main__":
	Parenthesis().create()