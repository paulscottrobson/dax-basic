# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		makeinclude.py
#		Purpose :	Build the _build.asm file
#		Date :		3rd June 2022
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import re,sys,os

class IncludeBuilder(object):
	def __init__(self):
		self.defines = []
		self.includes = []
		self.sources = []

	def loadFile(self,f):
		for l in [l.strip() for l in open(f).readlines()]:
			l = l.strip() if l.find("#") < 0 else l[:l.find("#")].strip()
			self.newIncludes = []
			self.newSources = []
			if l != "":
				if l.startswith("define"):
					self.loadDefines(l[6:])
				else:
					self.loadModule(l)
			self.newSources.sort()
			self.newIncludes.sort()
			self.includes += self.newIncludes
			self.sources += self.newSources

	def loadDefines(self,dList):
		for d in dList.strip().split(","):
			self.defines.append(d.strip())

	def loadModule(self,base):
		base = base.replace("\\","/").replace("/",os.sep)
		m = re.match("^(.*)\\[(.*)\\]\\s*$",base)
		if m is not None:
			self.newSources.append(m.group(1).strip()+os.sep+m.group(2).strip())
		else:
			for root,dirs,files in os.walk(base):
				for f in files:
					if f.endswith(".inc"):
						self.newIncludes.append(root+os.sep+f)
					if f.endswith(".asm"):
						self.newSources.append(root+os.sep+f)

	def dump(self,h):
		h.write(";\n;\tGenerated by makeinclude.py script\n;\n")
		for d in self.defines:
			h.write("#define {0}\n".format(d))
		for f in self.includes:
			h.write("#include \"{0}\"\n".format(f))
		for f in self.sources:
			h.write("#include \"{0}\"\n".format(f))
		h.write("FinalAddress:\n")

icb = IncludeBuilder()
for f in sys.argv[1:]:
	icb.loadFile(f)
icb.dump(sys.stdout)