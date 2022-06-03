# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		unary.py
#		Purpose :	Unary testing
#		Date :		5th May 2022
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
		f1 = self.getFloat()
		s1 = self.getString()
		c1 = n1 if random.randint(0,1) == 0 else f1

		if op == "-":
			print("assert -{0} = {1}".format(c1,-c1))

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

		if op == "@":
			n1 = n1 & 0xFFFFFFFF  			# only guarantee 24 bits here.
			print("assert @{1}{0} = {2}".format(n1,"!?$"[random.randint(0,2)],n1 & 0x00FFFFFF))
			
		if op == "len":
			print("assert len(\"{0}\") = {1}".format(s1,len(s1)))

		if op == "asc":
			print("assert asc(\"{0}\") = {1}".format(s1,ord(s1[0]) if s1 != "" else 0))

		if op == "abs":
			print("assert abs({0}) = {1}".format(c1,abs(c1)))

		if op == "sgn":
			if c1 != 0:
				s = -1 if c1 < 0 else 1
			else:
				s = 0
			print("assert sgn({0}) = {1}".format(c1,s))

		if op == "peek":
			p = random.randint(6,20)
			print("assert peek(page+{0}) = {1}".format(p,self.getPV(p)))

		if op == "deek":
			v2 = random.randint(6,20)
			r = self.getPV(v2)+(self.getPV(v2+1) << 8)
			print("assert deek(page+{0}) = &{1:x}".format(v2,r))

		if op == "leek":
			v2 = random.randint(6,20)
			r = self.getPV(v2)+(self.getPV(v2+1) << 8)+(self.getPV(v2+2) << 16)+(self.getPV(v2+3) << 24)
			print("assert leek(page+{0}) = &{1:x}".format(v2,r))

		if op == "int":
			n = int(abs(c1)) * (-1 if c1 < 0 else 1)
			print("assert int({0}) = {1}".format(c1,n))

		if op == "float":
			n1 = n1 >> 8
			print("assert float({0}) = {0}.0".format(n1))

		if op == "frac":
			while abs(c1) >= 100:
				c1 = c1 / 10
			c1 = self.makeReal(c1)
			fp = self.makeReal(abs(c1) - int(abs(c1)))
			self.checkFloatNear("frac({0})".format(c1),fp)

		if op == "chr":
			c1 = random.randint(64,90)
			print("assert chr$({0}) = \"{1}\"".format(c1,chr(c1)))

		if op == "upper":
			print("assert upper$(\"{0}\") = \"{1}\"".format(s1,s1.upper()))

		if op == "lower":
			print("assert lower$(\"{0}\") = \"{1}\"".format(s1,s1.lower()))

		if op == "left":
			s = random.randint(0,10)
			r = s1[:s]
			print("assert left$(\"{0}\",{1}) = \"{2}\"".format(s1,s,r))

		if op == "right":
			s = random.randint(0,10)
			sp = max(len(s1)-s,0)
			r = s1[sp:]
			print("assert right$(\"{0}\",{1}) = \"{2}\"".format(s1,s,r))

		if op == "mid2":
			sp = random.randint(1,10)			
			sz = random.randint(1,10)
			r = s1[sp-1:]
			r = r[:sz]
			print("assert mid$(\"{0}\",{1},{2}) = \"{3}\"".format(s1,sp,sz,r))

		if op == "mid1":
			sp = random.randint(1,10)			
			r = s1[sp-1:]
			print("assert mid$(\"{0}\",{1}) = \"{2}\"".format(s1,sp,r))

		if op == "vali":
			print("assert val(\"{0}\") = {1}".format(n1,n1))

		if op == "valf":
			f1 = self.makeReal(f1)
			print("assert val(\"{0}\") = {1}".format(f1,f1))

		if op == "min" or op == "max":
			t = random.randint(0,2)
			pList = []
			for i in range(0,random.randint(1,3)):
				if t == 0:
					pList.append(self.getInteger())
				if t == 1:
					pList.append(self.getFloat())
				if t == 2:
					pList.append('"'+self.getString()+'"')
			print("assert {0}({1}) = {2}".format(op,",".join([str(x) for x in pList]),min(pList) if op == "min" else max(pList)))

		if op == "stri":
			print("assert str$({0}) = \"{0}\"".format(n1))

		if op == "strf":
			self.checkFloatNear("val(str$({0}))".format(f1),f1)

		if op == "trig":
			func = ["sin","cos"][random.randint(0,1)]			# tan is simple but not accurate as tan(x) gets larger.
			angle = random.randint(-720,720)
			s = "math.{0}({1})".format(func,angle*math.pi/180.0)
			self.checkFloatNear("{1}({0})".format(angle,func),eval(s))

		if op == "ln":
			f1 = random.randint(1,1000000)/100.0
			self.checkFloatNear("ln({0})".format(f1),math.log(f1))

		if op == "log":
			f1 = random.randint(1,1000000)/100.0
			self.checkFloatNear("log({0})".format(f1),math.log(f1,10.0))

		if op == "exp":
			f1 = random.randint(0,500)/100.0
			self.checkFloatNear("exp({0})".format(f1),math.exp(f1))

		if op == "sqrt":
			f1 = random.randint(80,10000)/100.0
			self.checkFloatNear("sqr({0})".format(f1),math.sqrt(f1))

		if op == "pi":
			self.checkFloatNear("pi",math.pi)
			
		return True 

	def getOperatorList(self):
		return "-,not,!,?,$,&,@,len,asc,abs,sgn,peek,deek,leek,int,float,frac,chr,upper,lower,left,right,mid2,mid1,vali,valf,min,max,stri,strf,trig,ln,log,exp,sqrt"

if __name__ == "__main__":
	UnaryOperators().create()

	