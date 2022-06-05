# *******************************************************************************************
# *******************************************************************************************
#
#		Name : 		dumpvars.py
#		Purpose :	Dump variable structures as per memory.dump
#		Date :		4th June 2022
#		Author : 	Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

def deek(a):
	n = mem[a]+(mem[a+1]<<8)+(mem[a+2]<<16)+(mem[a+3]<<24)
	return n-0x100000000 if (n & 0x80000000) != 0 else n

hashTableAddress = 0x5700 														# Location in CPU memory
szVariables = 0x5780  															# Location of A-Z variables.
hashTableSize = 16 																# Number of hash table entries.

mem = [x for x in open("memory.dump","rb").read(-1)]

vList = []
for v in range(0,26): 															# dump any non-zero a-z
	n = deek(szVariables+v*4)
	if n != 0:
		vList.append("\t{0} = {1}".format(chr(v+97),n))
if len(vList) > 0:
	print ("Standard Variables")
	print("\n".join(vList))
	
for t in range(0,2):															# 0 integer 1 array
	for h in range(0,hashTableSize):											# each hash entry.
		ha = hashTableAddress + (t*hashTableSize+h) *4
		hl = deek(ha)
		if hl != 0:
			print("{0:7}[{2}] at ${1:04x}".format(["Integer","Array"][t],ha,h))
			while hl != 0:
				name = ""
				p = deek(hl+5)
				while mem[p] < 0x3F:
					name += "abcdefghijklmnopqrstuvwxyz0123456789._"[mem[p]]
					p += 1
				if t == 0:
					s = str(deek(hl+9))
				else:
					sz = deek(hl+9)
					name += "("+str(sz)+")"
					s = ",".join([str(deek(hl+13+i*4)) for i in range(0,sz+1)])
				print("\t@ ${0:04x} #{3:02x} {1:10} = {2}".format(hl,name,s,mem[hl]))
				hl = deek(hl+1)	