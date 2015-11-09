#!/bin/sh 

#TractographyWorkflow : for neonate dataset to the connectivity matrix 

#Variables
export SUBJECT=neo-0508-1-1year
export SUBJECT_DIR=/nas02/home/d/a/danaele/ConnectivityData/$SUBJECT
export DTI_DIR=$SUBJECT_DIR/DTI
OverLap="true"
export toolDIR=$PWD


#Create Diffusion data for bedpostx 
echo "Create Diffusion data ..."

$toolDIR/createDiffusionData.sh $SUBJECT $SUBJECT_DIR $DTI_DIR
echo "Create Diffusion data done !"

#Bedpostx 
echo "Run bedpostx ..."
cd $SUBJECT_DIR
$toolDIR/DoBedpostx.sh $SUBJECT_DIR
echo "Bedpostx Done !"

#Merge both hemisphere
#$toolDIR/polydatamerge -f $DTI_DIR/$SUBJECT-SW-T1-cere-seg.img.lh-rev.img.MiddleSurf.Reg.vtk.AALcolor.vtk \
#-g $DTI_DIR/$SUBJECT-SW-T1-cere-seg.img.rh-rev.img.MiddleSurf.Reg.vtk.AALcolor.vtk \
#-o $DTI_DIR/${SUBJECT}_combined_MiddleSurf_AALCOLOR.vtk

#$toolDIR/polydatamerge -f $DTI_DIR/$SUBJECT-SW-T1-cere-seg.img.lh-rev.img.InnerSurf.Reg.vtk \
#-g $DTI_DIR/$SUBJECT-SW-T1-cere-seg.img.rh-rev.img.InnerSurf.Reg.vtk \
#-o $DTI_DIR/${SUBJECT}_combined_InnerSurf.vtk

if( $OverLap = "true" )
then 
  export overlapFlag="--overlapping"
else
  export overlapFlag=""
fi

echo $overlapFlag

mkdir $SUBJECT_DIR/OutputSurfaces${overlapFlag} 
cd $SUBJECT_DIR/OutputSurfaces${overlapFlag}
export SURF_DIR=$PWD/labelSurfaces

echo $toolDIR
#Create label surfaces
$toolDIR/ExtractLabels.sh $toolDIR $SUBJECT $DTI_DIR $overlapFlag


cd $SUBJECT_DIR
 
#Create seeds list 
rm $SUBJECT_DIR/seeds$overlapFlag.txt
for case in $SUBJECT_DIR/OutputSurfaces${overlapFlag}/labelSurfaces/* 
do
  echo $case >> seeds$overlapFlag.txt
done 

#Do tractography with probtrackx2
$toolDIR/DoTractography.sh $SUBJECT $SUBJECT_DIR $DTI_DIR $overlapFlag

echo "Normalize and plot connectivity matrix..."
matlab -nojvm -nodisplay -nosplash -r "$toolDIR/connectivity_matrix_normalized('$SUBJECT_DIR/Network_${SUBJECT}$Overlap','$overlapFlag'); exit;"
echo "End, matrix save."


