#!/bin/sh

export SUBJECT=$1
export SUBJECT_DIR=$2
export DTI_DIR=$3
export OverLap=$overlapFlag

echo "Convert T1 image to nifti format "
./DWIConvert --inputVolume $DTI_DIR/${SUBJECT}_T1_regDTI.nrrd --conversionMode NrrdToFSL --outputVolume $DTI_DIR/${SUBJECT}_T1_regDTI.nii.gz
echo "Conversion done"

echo "start probtrackx " 
probtrackx2 --samples=$SUBJECT_DIR/Diffusion.bedpostX/merged --mask=$SUBJECT_DIR/Diffusion.bedpostX/nodif_brain_mask --seed=$SUBJECT_DIR/seeds${overlapFlag}.txt --seedref=$DTI_DIR/${SUBJECT}_T1_regDTI.nii.gz --forcedir --network --omatrix1 -P 1000  -V 1 --loopcheck --dir=Network_${SUBJECT}$Overlap --stop=$SUBJECT_DIR/seeds${overlapFlag}.txt
echo "done "
#
