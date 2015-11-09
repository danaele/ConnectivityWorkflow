#!/bin/sh

export SUBJECT=$1
export SUBJECT_DIR=$2
export DTI_DIR=$3

mkdir $SUBJECT_DIR/Diffusion
echo "DWIConvert : nodif_brain_mask.nii.gz"
./DWIConvert --inputVolume $DTI_DIR/${SUBJECT}-brainmask_Upx2.nrrd --conversionMode NrrdToFSL --outputVolume $SUBJECT_DIR/Diffusion/nodif_brain_mask.nii.gz --outputBVectors $SUBJECT_DIR/Diffusion/bvecs.nodif --outputBValues $SUBJECT_DIR/Diffusion/bvals.temp
echo "Done !"
echo "DWIConvert : data.nii.gz"
./DWIConvert --inputVolume $DTI_DIR/${SUBJECT}_42_DWI-Trio_QCed_VC_Upx2.nrrd --conversionMode NrrdToFSL --outputVolume $SUBJECT_DIR/Diffusion/data.nii.gz --outputBVectors $SUBJECT_DIR/Diffusion/bvecs --outputBValues $SUBJECT_DIR/Diffusion/bvals
echo "Done !"


