# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		scanner.py
#		Purpose :	Scan the source code to build the command tables
#		Date :		3rd June 2022
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import sys,re
from keywords import * 

keywords = Keywords()
vectors = {}
#
#		Scan included sources for [[command]] markers
#
for l in [x.strip() for x in open(sys.argv[1]+"_build.asm").readlines()]:
	m = re.match("^\\#include\\s+\\\"(.*asm)\\\".*$",l)
	if m is not None:
		for s in open(sys.argv[1]+m.group(1)).readlines():
			if s.find(";;") >= 0:
				m = re.match("^(.*?)\\:\\s*\\;\\;\\s*\\[(.*)\\].*$",s)
				assert m is not None, "Bad line "+s
				kwd = m.group(2).strip().lower()
				assert kwd not in vectors,"Duplicate "+kwd
				assert keywords.find(kwd) is not None,"Unknown "+kwd
				vectors[kwd] = m.group(1)
#
#		Create vector tables.
#
h = open(sys.argv[1]+"generated/vectors.asm","w")
for kset in range(0,keywords.highestSet+1):
	h.write(";\n;\tVectors for set {0}\n;\nVectorsSet{0}:\n".format(kset))
	id = 0x80
	while kset*4096+id in keywords.idLookup:
		l = keywords.idLookup[kset*4096+id]
		name = l["keyword"].lower() 
		vector = vectors[name] if name in vectors else "Unimplemented"
		vector = "addr({0})".format(vector)
		h.write("\t{0:32} ; ${1:04x} {2}\n".format(vector,kset*4096+id,l["keyword"].lower()))
		id += 1
h.close()
