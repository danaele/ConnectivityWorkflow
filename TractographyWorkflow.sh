#!/bin/sh 

#TractographyWorkflow : for neonate dataset to the connectivity matrix 

#Variables
export SUBJECT=$1
export SUBJECT_DIR=/netscr/danaele/neonate_1year/${SUBJECT}
#export SUBJECT_DIR=/work/danaele/data/${SUBJECT}
export DTI_DIR=${SUBJECT_DIR}/DTI
OverLap="true"
loopcheck="true"
export toolDIR=$PWD


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
#${toolDIR}/ExtractLabels.sh ${toolDIR} ${SUBJECT} ${SUBJECT_DIR} ${DTI_DIR} ${overlapFlag}

cd ${SUBJECT_DIR}
 
#Create seeds list 
rm ${SUBJECT_DIR}/seeds${overlapName}.txt
for i in `seq 1 2`
do
  for j in `seq 1 90`; do
    export fileLabel=${SUBJECT_DIR}/OutputSurfaces${overlapName}/labelSurfaces/${j}.asc
    echo ${fileLabel}
    if [ $(($j % 2)) -eq 0 ] && [ $i -eq 2 ] && [ $j -ne 78 ] && [ -e ${fileLabel} ]; then
      echo ${fileLabel} >> seeds${overlapName}.txt
    elif [ $(($j % 2)) -ne 0 ] && [ $i -eq 1 ] && [ -e ${fileLabel} ]; then
      echo ${fileLabel} >> seeds${overlapName}.txt
    fi
  done
done

if [ "${loopcheck}" = "true" ]; then 
  export loopcheckFlag="--loopcheck"
  export loopcheckName="_loopcheck"
else 
  export loopcheckFlag=""
  export loopcheckName=""
fi

export network_DIR=${SUBJECT_DIR}/Network_${SUBJECT}${overlapName}${loopcheckName} 
export matrix=$network_DIR/fdt_network_matrix 
echo $matrix
#Do tractography with probtrackx2
if [ -e $matrix ]; then
  echo "probtrackx already proceed"
else
  ${toolDIR}/DoTractography.sh ${SUBJECT} ${SUBJECT_DIR} ${DTI_DIR} ${overlapName} ${loopcheckFlag} ${network_DIR} ${toolDIR}
fi

echo "Normalize and plot connectivity matrix..."
#erase old matrix saved
rm ${network_DIR}/matrix_normalized.txt
rm ${network_DIR}/matrix_normalized.pdf
cd ${toolDIR}
#run prog c++ normalize
#
#python plotMatrix.py ${SUBJECT} ${network_DIR} ${overlapName} ${loopcheck}

matlab -nodesktop -r "connectivity_matrix_normalized('${SUBJECT}','${network_DIR}','${overlapName}','${loopcheck}'); exit; "
echo "End, matrix save."



