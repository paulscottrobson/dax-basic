10 count = 0
20 gosub 1000
30 gosub 1000:gosub 1000
40 gosub 2000
50 gosub 2000
90 end
1000 count = count + 1
1010 print count
1020 return
2000 print "In 2000"
2010 gosub 1000:gosub 1000
2020 return