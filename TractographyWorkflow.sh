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
export JSONFile_PATH=$toolDIR/JSON_TABLE_AAL.json
########################################################################

cp ${JSONFile_PATH} ${SUBJECT_DIR}
jsonfilename=basename ${JSONFile_PATH} 
export NewJSONFILE_PATH=${SUBJECT_DIR}/$jsonfilename

#Create Diffusion data for bedpostx 
echo "Create Diffusion data ..."
export DiffusionData=${SUBJECT_DIR}/Diffusion/data.nii.gz
export DiffusiobNodif_Brain=${SUBJECT_DIR}/Diffusion/nodif_brain_mask.nii.gz
if [ -e $DiffusionData ] && [ -e $DiffusiobNodif_Brain ]; then 
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

echo ${toolDIR}
#Create label surfaces
if [ -d ${SUBJECT_DIR}/OutputSurfaces${overlapName}/labelSurfaces ]; then
       echo "Label already created"
else
       ${toolDIR}/ExtractLabels.sh ${toolDIR} ${SUBJECT} ${SUBJECT_DIR} ${DTI_DIR} ${overlapFlag}
fi

cd ${SUBJECT_DIR}
 
#Create seeds list 
rm ${SUBJECT_DIR}/seeds${overlapName}.txt
python writeSeedList.py  ${SUBJECT} ${SUBJECT_DIR} ${overlapName} ${NewJSONFILE_PATH} ${number_ROIS}

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

python plotMatrix.py ${SUBJECT} ${SUBJECT_DIR} ${matrixDIR} ${overlapName} ${loopcheck}

echo "End, matrix save."



