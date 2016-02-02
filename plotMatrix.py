import numpy as N
import matplotlib.pyplot as plt
from matplotlib import pylab as pl
from sys import argv

#args : ${SUBJECT} ${network_DIR} ${overlapName} ${loopcheck}

subject = argv[1]
subject_dir = argv[2] 
matrix = argv[3] 
overlapName = argv[4] 
loopcheck = argv[5] 

#print len(overlapName)
#print len(loopcheck)
fileMatrix = subject_dir + subject + '/Network_' + subject + overlapName + loopcheck + '/' + matrix
fin = open(fileMatrix,'r')
a=[]
for line in fin.readlines():
  a.append( [ float(x) for x in line.split('  ') if x != "\n" ] )   
#print N.shape(a)
print a 

#Normalize NOW
waytotal = []

j=0
for line in a:
  sumLine = 0
  for val in line:
    sumLine = sumLine + float(val)
    j=j+1
  waytotal.append(sumLine)

print waytotal
i=0
for line in a:
  j=0
  for val in line:
    newVal = val / waytotal[i]
    a[i][j]=newVal
    j=j+1
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
