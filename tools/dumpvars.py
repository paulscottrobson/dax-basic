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
hashTableSize = 16 																# Number of hash table entries.

mem = [x for x in open("memory.dump","rb").read(-1)]

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
					assert False
				print("\t@ ${0:04x} #{3:02x} {1:10} = {2}".format(hl,name,s,mem[hl]))
				hl = deek(hl+1)	