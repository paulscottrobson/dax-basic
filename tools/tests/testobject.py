# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		testobject.py
#		Purpose :	Testing base class
#		Date :		3rd June 2022
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

from testobject import *
import random 

# *******************************************************************************************
#
#									Base test object
#
# *******************************************************************************************

class TestObject(object):
	def __init__(self):
		random.seed()
		self.seed = random.randint(0,99999)
		#self.seed = 66909
		random.seed(self.seed)
		self.opList = [x for x in self.getOperatorList().split(",") if x != ""]

	def header(self):
		print('rem "ABCDEFGHIJKLMNOPQRSTUVWXYZ"')				# This is for indirection testing
		print('rem "Seed = {0}"'.format(self.seed))

	def footer(self):
		print('print "Ok Seed {0}"'.format(self.seed))

	def create(self):
		self.header()
		count = 200
		#count = 3
		while count > 0:
			op = self.opList[random.randint(0,len(self.opList)-1)]
			if self.make(op):
				count -= 1
		self.footer()

	def getInteger(self):
		#return random.randint(-5,5)
		return random.randint(-0x80000000,0x7FFFFFFF)

	def getString(self,s = 8):
		return "".join(chr(random.randint(65,90)+random.randint(0,1)*32) for x in range(0,random.randint(0,s)))

	def getFloat(self):
		return random.randint(-1000000,1000000)/1000.0

	def makeReal(self,r):
		roundup = 1000
		return int(r * roundup+0.5)/roundup

	def getOperatorList(self):
		return "."