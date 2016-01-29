import os.path
import json
import numpy as np
from pprint import pprint

#args : SUBJECT_DIR, SUBJECT, JSONTABLE filename, ${overlapFlag} (seedlist), number_ROIS

DIR_Surfaces = "/Human2/Neonate-1-2yr/PROCEED/neo-0029-3-1year/OutputSurfaces_overlapping/labelSurfaces/"

#Open Json file and parse 
with open('/work/danaele/JSONTABLEAAL.json') as data_file:    
    data = json.load(data_file)

#Create file for seedList
seedList = open('seedList.txt', 'w')

#Put all MatrixRow to -1 
for seed in data:
  seed['MatrixRow']=-1

#For each file in DIR
for i in range(150):
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
with open('jsonUpdata.json', 'w') as txtfile:
    json.dump(data, txtfile, indent = 2)

