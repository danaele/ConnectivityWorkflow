#!/bin/sh 

#TractographyWorkflow : for neonate dataset to the connectivity matrix 

#Variables to set
########################################################################
export SUBJECT=$1  #ex : neo-0029-1-1year
export SUBJECT_DIR=/netscr/danaele/neonate_1year/${SUBJECT}
#export SUBJECT_DIR=/work/danaele/data/${SUBJECT}
export DTI_DIR=${SUBJECT_DIR}/DTI
OverLap="true"
loopcheck="true"
number_ROIS=150
matrix=fdt_network_matrix
export toolDIR=$PWD
export JSONFile_PATH=$toolDIR/
export JSONfilename=JSON_TABLE_AAL.json
########################################################################

export NewJSONFILE_PATH=${SUBJECT_DIR}/${JSONfilename}
cp ${JSONFile_PATH}/${JSONfilename} ${NewJSONFILE_PATH}

#Create Diffusion data for bedpostx 
echo "Create Diffusion data ..."
export DiffusionData=${SUBJECT_DIR}/Diffusion/data.nii.gz
export DiffusionNodif_Brain=${SUBJECT_DIR}/Diffusion/nodif_brain_mask.nii.gz
if [ -e $DiffusionData ] && [ -e $DiffusionNodif_Brain ]; then 
  echo "Diffusion Data already created "
else
  ${toolDIR}/createDiffusionData.sh ${SUBJECT} ${SUBJECT_DIR} ${DTI_DIR}
  echo "Create Diffusion data done !"
fi

#Bedpostx 
echo "Run bedpostx ..."
cd ${SUBJECT_DIR}
${toolDIR}/DoBedpostx.sh ${SUBJECT_DIR}
echo "Bedpostx Done !"

if [ "${OverLap}" = "true" ]; then 
  export overlapFlag="--overlapping"
  export overlapName="_overlapping"  
else
  export overlapFlag=""
  export overlapName=""  
fi

mkdir ${SUBJECT_DIR}/OutputSurfaces${overlapName} 
cd ${SUBJECT_DIR}/OutputSurfaces${overlapName}
export SURF_DIR=$PWD/labelSurfaces

#Create label surfaces
if [ -d ${SURF_DIR} ]; then
       echo "Label already created"
else
	${toolDIR}/ExtractLabels.sh ${toolDIR} ${SUBJECT} ${NewJSONFILE_PATH} ${DTI_DIR} ${overlapFlag}
fi

cd ${SUBJECT_DIR}
 
#Create seeds list 
rm ${SUBJECT_DIR}/seeds${overlapName}.txt
python ${toolDIR}/writeSeedList.py ${SUBJECT_DIR} ${overlapName} ${NewJSONFILE_PATH} ${number_ROIS}

if [ "${loopcheck}" = "true" ]; then 
  export loopcheckFlag="--loopcheck"
  export loopcheckName="_loopcheck"
else 
  export loopcheckFlag=""
  export loopcheckName=""
fi

export network_DIR=${SUBJECT_DIR}/Network_${SUBJECT}${overlapName}${loopcheckName} 
export matrixDIR=$network_DIR/${matrix} 
echo $matrixDIR
#Do tractography with probtrackx2
if [ -e $matrixDIR ]; then
  echo "probtrackx already proceed"
else
  ${toolDIR}/DoTractography.sh ${SUBJECT} ${SUBJECT_DIR} ${DTI_DIR} ${overlapName} ${loopcheckFlag} ${network_DIR} ${toolDIR}
fi

echo "Normalize and plot connectivity matrix..."
#erase old matrix saved
rm ${matrixDIR}_normalized.pdf
cd ${toolDIR}

python ${toolDIR}/plotMatrix.py ${SUBJECT} ${matrixDIR} ${overlapName} ${loopcheck}

echo "End, matrix save."



