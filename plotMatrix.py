import numpy as N
import matplotlib.pyplot as plt
from matplotlib import pylab as pl
from sys import argv

#args : ${SUBJECT} ${network_DIR} ${overlapName} ${loopcheck}

subject = argv[1] 
matrix = argv[2] 
overlapName = argv[3] 
loopcheck = argv[4] 

#print len(overlapName)
#print len(loopcheck)
fin = open(matrix,'r')
a=[]
for line in fin.readlines():
  print line.split('  ')
  a.append( [ float(x) for x in line.split('  ') if x != "\n" ] )   
#print N.shape(a)
#print a 

#Normalize NOW
waytotal = []
sumLine = 0
j=0
for line in a:
  for val in line:
    sumLine = sumLine + float(val)
    j=j+1
  waytotal.append(sumLine)
  print j
print len(waytotal)
print waytotal[0]
i=0
for line in a:
  for val in line:
    print i
    val = val / waytotal[i]
  i=i+1  
    
print a 

# plotting the correlation matrix
fig = pl.figure(num=None, figsize=(15, 15))
fig.clf()

outputfilename = 'Connectivity matrix of data ' + subject + ' normalized - '

if len(overlapName)>3 and len(loopcheck)>3:
  outputfilename += 'with Loopcheck and with Overlapping'
elif len(overlapName)<3 and len(loopcheck)>3:
  outputfilename += 'without Loopcheck and with Overlapping'
elif len(overlapName)>3 and len(loopcheck)<3:
  outputfilename += 'with Loopcheck and without Overlapping'
else:
  outputfilename += 'without Loopcheck and without Overlapping'


fig.suptitle(outputfilename, fontsize=18)
plt.xlabel('Seeds')
plt.ylabel('Targets')
ax = fig.add_subplot(1,1,1)
cax = ax.imshow(a, interpolation='nearest', vmin=0.0, vmax=0.99)
fig.colorbar(cax)
#pl.show()
fig.savefig(matrix + '.pdf', format='pdf')
