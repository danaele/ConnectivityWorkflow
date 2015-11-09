#!/bin/sh 

export toolDIR=$1
export SUBJECT=$2
export DTI_DIR=$3
export overlapFlag=$4

#Create label surfaces 
$toolDIR/ExtractLabelSurfaces \
--extractPointData \
--translateToLabelNumber \
--labelNameInfo labelListName.txt \
--labelNumberInfo labelListNumber.txt \
-a colour \
--vtkLabelFile $DTI_DIR/${SUBJECT}_combined_MiddleSurf_AALCOLOR.vtk \
--createSurfaceLabelFiles \
--vtkFile $DTI_DIR/${SUBJECT}_combined_InnerSurf.vtk $overlapFlag


