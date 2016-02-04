#!/bin/sh 

export toolDIR=$1
export SUBJECT=$2
export NewJSONFILE_PATH=$3
export DTI_DIR=$4
export overlapFlag=$5

#Create label surfaces 
$toolDIR/ExtractLabelSurfaces --extractPointData --translateToLabelNumber --labelNameInfo labelListName.txt --labelNumberInfo  labelListNumber.txt --useTranslationTable --labelTranslationTable ${NewJSONFILE_PATH} -a colour --vtkLabelFile ${DTI_DIR}/${SUBJECT}_combined_MiddleSurf_AALCOLOR.vtk --createSurfaceLabelFiles --vtkFile ${DTI_DIR}/${SUBJECT}_combined_InnerSurf.vtk ${overlapFlag} --ignoreLabel "0 0 0"

