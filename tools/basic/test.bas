20 LET k=0
25 DIM m(5)
30 LET k=k+1
40 LET a=k/2*3+4-5
45 GOSUB 700
46 for l = 1 to 5
47 LET m(l) = a
48 next
50 IF k<10000 THEN GOTO 30

print "*************"
print "*************"
print "*************"
print "*************"
print "*************"


700 RETURN
