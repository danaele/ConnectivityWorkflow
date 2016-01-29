import os.path
import json
import numpy as np
from pprint import pprint

#args : SUBJECT, SUBJECT_DIR, ${overlapFlag}, JSONTABLE filename, number_ROIS
subject = argv[1]
subject_dir = argv[2] 
overlapName = argv[3] 
jsonFile = argv[4] 
nb_ROIS = argv[5]


#DIR_Surfaces = subject_dir + subject + 'OutputSurfaces' + overlapName + '/labelSurfaces/'
DIR_Surfaces = "/Human2/Neonate-1-2yr/PROCEED/neo-0029-3-1year/OutputSurfaces_overlapping/labelSurfaces/"

#Open Json file and parse 
#with open(jsonFile) as data_file:    
with open('/work/danaele/JSONTABLEAAL.json') as data_file:    
    data = json.load(data_file)

#Create file for seedList
#seedPath = subject_dir + subject + '/seeds' + overlapName + '.txt'
#seedList = open(seedPath, 'w')
seedList = open('seedList.txt', 'w')

#Put all MatrixRow to -1 
for seed in data:
  seed['MatrixRow']=-1

#For each file in DIR
for i in range(nb_ROIS):
    numberStr = str(i+1)
    file = DIR_Surfaces + numberStr + ".asc"
    val = os.path.isfile(file)
    if (val == True):
      #Write in seedList Path 
      seedList.write(file + "\n")
      #Update JSON file : 'MatrixRow'
      data[i]['MatrixRow'] = i+1
     
seedList.close()

#Update JSON file 
#with open('jsonFile, 'w') as txtfile:
with open('jsonUpdata.json', 'w') as txtfile:
    json.dump(data, txtfile, indent = 2)

