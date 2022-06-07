10 gosub 1000
90 i = 0
95 repeat i=i+1: until i = 1000
100 gosub 1000:gosub 1000
110 stop

1000 a = 65
1010 repeat
1020 	print chr$(a);
1030 	a = a+1
1040 until a = 96:print
1050 return