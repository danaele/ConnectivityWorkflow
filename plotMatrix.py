import numpy as N
import matplotlib.pyplot as plt
from matplotlib import pylab as pl
from sys import argv

#args : ${SUBJECT} ${network_DIR} ${overlapName} ${loopcheck}

subject = argv[1] 
matrix = argv[2] 
overlapName = argv[3] 
loopcheck = argv[4] 



print len(overlapName)
print len(loopcheck)
fin = open(matrix,'r')
a=[]
for line in fin.readlines():
    a.append( [ float (x) for x in line.split(' ') ] )   
#print N.shape(a)
#print a 

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
