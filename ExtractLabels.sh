#!/bin/sh 

export toolDIR=$1
export SUBJECT=$2
export SUBJECT_DIR=$3
export DTI_DIR=$4
export overlapFlag=$5

#Create label surfaces 
$toolDIR/ExtractLabelSurfaces --extractPointData --translateToLabelNumber --labelNameInfo labelListName.txt --labelNumberInfo  labelListNumber.txt --useTranslationTable --labelTranslationTable ${SUBJECT_DIR}/RGBToLabelTranslation.txt -a colour --vtkLabelFile ${DTI_DIR}/${SUBJECT}_combined_MiddleSurf_AALCOLOR.vtk --createSurfaceLabelFiles --vtkFile ${DTI_DIR}/${SUBJECT}_combined_InnerSurf.vtk ${overlapFlag} --ignoreLabel "0 0 0"

 
