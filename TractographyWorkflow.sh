#!/bin/sh 

#TractographyWorkflow : for neonate dataset to the connectivity matrix 

#Variables
export SUBJECT=neo-0576-1-1-1year
#export SUBJECT_DIR=/nas02/home/d/a/danaele/ConnectivityData/${SUBJECT}
export SUBJECT_DIR=/work/danaele/data/${SUBJECT}
export DTI_DIR=${SUBJECT_DIR}/DTI
OverLap="true"
loopcheck="true"
export toolDIR=$PWD


#Create Diffusion data for bedpostx 
echo "Create Diffusion data ..."

#${toolDIR}/createDiffusionData.sh ${SUBJECT} ${SUBJECT_DIR} ${DTI_DIR}
echo "Create Diffusion data done !"

#Bedpostx 
echo "Run bedpostx ..."
cd ${SUBJECT_DIR}
#${toolDIR}/DoBedpostx.sh ${SUBJECT_DIR}
echo "Bedpostx Done !"

#Merge both hemisphere
#${toolDIR}/polydatamerge -f $DTI_DIR/${SUBJECT}-SW-T1-cere-seg.img.lh-rev.img.MiddleSurf.Reg.vtk.AALcolor.vtk \
#-g $DTI_DIR/${SUBJECT}-SW-T1-cere-seg.img.rh-rev.img.MiddleSurf.Reg.vtk.AALcolor.vtk \
#-o $DTI_DIR/${SUBJECT}_combined_MiddleSurf_AALCOLOR.vtk

#${toolDIR}/polydatamerge -f $DTI_DIR/${SUBJECT}-SW-T1-cere-seg.img.lh-rev.img.InnerSurf.Reg.vtk \
#-g $DTI_DIR/${SUBJECT}-SW-T1-cere-seg.img.rh-rev.img.InnerSurf.Reg.vtk \
#-o $DTI_DIR/${SUBJECT}_combined_InnerSurf.vtk

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
${toolDIR}/ExtractLabels.sh ${toolDIR} ${SUBJECT} ${DTI_DIR} ${overlapFlag}

cd ${SUBJECT_DIR}
 
#Create seeds list 
rm ${SUBJECT_DIR}/seeds${overlapName}.txt
for case in ${SUBJECT_DIR}/OutputSurfaces${overlapName}/labelSurfaces/* 
do

  case6=$(basename $case)
  if [ "$case6" = "6.asc" ] ; then
    echo "Don't add 6.asc to seeds list" 
  else
    echo ${case} >> seeds${overlapName}.txt
  fi
done 

if [ "${loopcheck}" = "true" ]; then 
  export loopcheckFlag="--loopcheck"
  export loopcheckName="_loopcheck"
else 
  export loopcheckFlag=""
  export loopcheckName=""
fi

export network_DIR=${SUBJECT_DIR}/Network_${SUBJECT}${overlapName}${loopcheckName}  
#Do tractography with probtrackx2
${toolDIR}/DoTractography.sh ${SUBJECT} ${SUBJECT_DIR} ${DTI_DIR} ${overlapName} ${loopcheckFlag} ${network_DIR}

echo "Normalize and plot connectivity matrix..."
#erase old matrix saved
rm ${SUBJECT_DIR}/Network_${SUBJECT}${overlapName}/Matrix_normalized_by_sum_row.txt
rm ${SUBJECT_DIR}/Network_${SUBJECT}${overlapName}/Matrix_normalized_by_sum_row_Visualization.pdf

matlab -nojvm -nodisplay -nosplash -r "${toolDIR}/connectivity_matrix_normalized('${SUBJECT}','${network_DIR}','${overlapName}','${loopcheck}'); exit;"
echo "End, matrix save."


