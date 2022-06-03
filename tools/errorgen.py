# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		errors.py
#		Purpose :	Create error text file and include file
#		Date :		3rd June 2022
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import sys,os,re

if len(sys.argv) != 2:
	print("errors.py <language>")
	sys.exit(1)

src = open("errortext"+os.sep+"errors."+sys.argv[1]).readlines()
src = [x if x.find("#") < 0 else x[:x.find("#")] for x in src]
src = [x.replace("\t"," ").strip() for x in src if x.strip() != ""]

messages = {}
for s in src:
	m = re.match("^\\s*(.*?)\\s*\\:(.*)$",s)
	assert m,"Error in language file "+s
	key = m.group(1).lower().strip()
	assert key not in messages,"Duplicate message "+s
	messages[key] = m.group(2).strip()

header = ";\n;\tThis is automatically generated.\n;\n"
keys = [x for x in messages.keys()]
keys.sort()

h = open("../source/generated/messagetext.asm".replace("/",os.sep),"w")
h.write(header)
h.write("ErrorIDTable:\n")
for k in keys:
	h.write("\t.dw\t{0} & $FFFF,{0} >> 16\n".format("ErrText_"+k.replace("@","")))
h.write("\n")
for k in keys:
	h.write("ErrText_{0}:\n\t.db \"{1}\",0\n".format(k.replace("@",""),messages[k]))	
h.close()

h = open("../source/generated/messageid.inc".replace("/",os.sep),"w")
h.write(header)
index = 0
for k in keys:
	h.write("ERRID_{0} = {1}\n\n".format(k.replace("@","").upper(),index))
	h.write("#macro ERR_{0}\n\tld a,ERRID_{0}\n\tjp ErrorHandler\n#endmacro\n\n".format(k.replace("@","").upper()))
	index += 1
h.close()