#!/bin/sh

export SUBJECT=$1
export SUBJECT_DIR=$2
export DTI_DIR=$3
export overlapName=$4
export loopcheckFlag=$5
export network_dir=$6

echo "Convert T1 image to nifti format "
DWIConvert --inputVolume $DTI_DIR/${SUBJECT}_T1_regDTI.nrrd --conversionMode NrrdToFSL --outputVolume $DTI_DIR/${SUBJECT}_T1_regDTI.nii.gz --outputBValues $DTI_DIR/bvals.temp --outputBVectors $DTI_DIR/bvecs.temp
echo "Conversion done"



echo "Start probtrackx " 
echo "probtrackx2 --samples=${SUBJECT_DIR}/Diffusion.bedpostX/merged --mask=${SUBJECT_DIR}/Diffusion.bedpostX/nodif_brain_mask --seed=${SUBJECT_DIR}/seeds${OverLap}.txt --seedref=${DTI_DIR}/${SUBJECT}_T1_regDTI.nii.gz --forcedir --network --omatrix1 -P 1000  -V 1 --dir=${network_dir} --stop=${SUBJECT_DIR}/seeds${OverLap}.txt ${loopcheckFlag} "

probtrackx2 --samples=${SUBJECT_DIR}/Diffusion.bedpostX/merged --mask=${SUBJECT_DIR}/Diffusion.bedpostX/nodif_brain_mask --seed=${SUBJECT_DIR}/seeds${overlapName}.txt --seedref=${DTI_DIR}/${SUBJECT}_T1_regDTI.nii.gz --forcedir --network --omatrix1 -P 1000  -V 1 --dir=${network_dir} --stop=${SUBJECT_DIR}/seeds${overlapName}.txt ${loopcheckFlag}
echo "done "


