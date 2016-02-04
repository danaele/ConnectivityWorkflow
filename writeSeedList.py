import os.path
import json
import numpy as np
from pprint import pprint
from sys import argv

#args : SUBJECT_DIR, ${overlapFlag}, JSONTABLE filename, number_ROIS
subject_dir = argv[1] 
overlapName = argv[2] 
jsonFile = argv[3] 
nb_ROIS = argv[4]


DIR_Surfaces = subject_dir + '/OutputSurfaces' + overlapName + '/labelSurfaces/'

#Open Json file and parse 
with open(jsonFile) as data_file:    
    data = json.load(data_file)

#Create file for seedList
seedPath = subject_dir + '/seeds' + overlapName + '.txt'
print "SEED PATHHHH"
print seedPath
seedList = open(seedPath, 'w')

#Put all MatrixRow to -1 
for seed in data:
  seed['MatrixRow']=-1

seedID = 0 
#For each file in DIR
for i in range(int(nb_ROIS)):
    numberStr = str(i+1)
    file = DIR_Surfaces + numberStr + ".asc"
    val = os.path.isfile(file)
    if (val == True):
      #Write in seedList Path 
      seedList.write(file + "\n")
      seedID = seedID + 1
      #Update JSON file : 'MatrixRow'
      for j in data:
        if(j['AAL_ID'] == i+1):
          j['MatrixRow'] = seedID
     
seedList.close()

#Update JSON file 
with open(jsonFile, 'w') as txtfile:
    json.dump(data, txtfile, indent = 2)

