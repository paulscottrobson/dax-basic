5 t1 = time
20 LET k=0
25 DIM m(5)
30 LET k=k+1
40 LET a=k/2*3+4-5
45 gosub 700
46 for l = 1 to 5
47 let m(l) = a
48 next 
50 IF k<1000 THEN GOTO 30
60 print time-t1
70 stop
700 return