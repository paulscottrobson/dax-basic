n1 = -3
c = -7
PROC test1(4):PRINT "Next":PROC test1(8)
PROC tex(-11,12)
PROC newproc
print c
print n1
PROC check(-999)
print c
END

DEF PROC check(c)
print c
ENDPROC

DEF PROC tex(n1,abc)
PRINT "tex",n1,abc
PROC test1(n1*abc)
PRINT "etex"
ENDPROC

DEF PROC test1(c)
PRINT "test1 ";c
ENDPROC

DEF PROC newproc
local n1,c
n1 = 5:c = 7
print "In new",n1,c
ENDPROC
