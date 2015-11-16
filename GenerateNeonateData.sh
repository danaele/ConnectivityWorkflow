#!/bin/tcsh
set nonomatch

set path_output= ( /work/danaele/data2 )

set casesFileDTI = ( /work/Rename_1-2yrDTI/DTI_1x1x1_42Dir/neo*1year*_42_DWI*_QCed_VC_Upx2_DTI_stripped_embed.nrrd )

foreach case ($casesFileDTI)

#Check if all files necessary exist
  set casePrefix = ( $case:t:s/-Trio//:s/_42_DWI_QCed_VC_Upx2_DTI_stripped_embed.nrrd// )
  echo $casePrefix

  #DTI
  set casesFileDTI42Dir = ( /NIRAL/work/Rename_1-2yrDTI/DTI_1x1x1_42Dir/${casePrefix}_42_DWI*_QCed_VC_Upx2_DTI_stripped_embed.nrrd )
  if (-e $casesFileDTI42Dir) then
    echo casesFileDTI42Dir files are here $casePrefix
  endif
  
   set casesFileDWI = ( /NIRAL/work/Rename_1-2yrDTI/DWI_1x1x1_ALL/${casePrefix}_42_DWI*_QCed_VC_Upx2.nrrd )
  if (-e $casesFileDWI) then
    echo casesFileDWI files are here $casePrefix
  endif
  
   set casesFileBrainMask = ( /NIRAL/work/Rename_1-2yrDTI/BrainMasks_1x1x1/${casePrefix}-brainmask_Upx2.nrrd )
  if (-e $casesFileBrainMask) then
    echo casesFileBrainMask files are here $casePrefix
  endif
  
  #Surfaces
  set caseFileInnerSurface_lh = ( /work/Surface_Analysis/Conte_1year_surfaceAnalysis/SURFACES/USABLE_SURFACES/Inner/${casePrefix}*.lh*vtk )
  set caseFileMiddleSurface_lh = ( /work/Surface_Analysis/Conte_1year_surfaceAnalysis/SURFACES/USABLE_SURFACES/Middle/${casePrefix}*.lh*vtk )
  set caseFileOuterSurface_lh = ( /work/Surface_Analysis/Conte_1year_surfaceAnalysis/SURFACES/USABLE_SURFACES/Outer/${casePrefix}*.lh*vtk )
  set caseFileInnerSurface_rh = ( /work/Surface_Analysis/Conte_1year_surfaceAnalysis/SURFACES/USABLE_SURFACES/Inner/${casePrefix}*.rh*vtk )
  set caseFileMiddleSurface_rh = ( /work/Surface_Analysis/Conte_1year_surfaceAnalysis/SURFACES/USABLE_SURFACES/Middle/${casePrefix}*.rh*vtk )
  set caseFileOuterSurface_rh = ( /work/Surface_Analysis/Conte_1year_surfaceAnalysis/SURFACES/USABLE_SURFACES/Outer/${casePrefix}*.rh*vtk )
  
  if ((-e $caseFileInnerSurface_lh) && (-e $caseFileInnerSurface_lh) && (-e $caseFileInnerSurface_lh) && (-e $caseFileInnerSurface_rh) && (-e $caseFileInnerSurface_rh) && (-e $caseFileInnerSurface_rh)) then
    echo surface files are here $casePrefix
    set caseSurfaces = ( /work/Surface_Analysis/Conte_1year_surfaceAnalysis/SURFACES/USABLE_SURFACES/*/${casePrefix}*vtk )
    set surfaceExist = exist
  endif
  
  
  
  #T1
  set T1SkullStrippedCorrectedSeg = ( /NIRAL/work/Surface_Analysis/Conte_1year_surfaceAnalysis/IMAGES/SkullStrippedImages/1year_Skull_Stripped/${casePrefix}-T1_SkullStripped_corrected-n3-seg.hdr )
  if (-e $T1SkullStrippedCorrectedSeg) then
    echo T1SkullStrippedCorrectedSeg files are here $casePrefix
  endif
  
  set T1SkullStrippedCorrected = ( /Human/conte_projects/CONTE_NEO/Data/${casePrefix}/Skull_Stripped/${casePrefix}-T1_SkullStripped_corrected.nrrd )
  if (-e $T1SkullStrippedCorrected) then
    echo T1SkullStrippedCorrected files are here $casePrefix
  endif

  if ( ( $surfaceExist == exist ) && (-e $casesFileDTI42Dir) && (-e $casesFileDWI) && (-e $casesFileBrainMask) && (-e $T1SkullStrippedCorrectedSeg) && (-e $T1SkullStrippedCorrected) ) then
    echo All files required exist
    
    set caseDir= ( $path_output/$casePrefix )
    mkdir $caseDir
    mkdir $caseDir/{sMRI,DTI}
    mkdir $caseDir/sMRI/{surf,mri}
    mkdir $caseDir/DTI/RegDTIAtlas
   
    cp $case $caseDir/DTI/RegDTIAtlas
    cp $casesFileDTI42Dir $caseDir/DTI/
    cp $casesFileDWI $caseDir/DTI/
    cp $casesFileBrainMask $caseDir/DTI
    cp $caseSurfaces $caseDir/sMRI/surf
    
    ImageMath $T1SkullStrippedCorrectedSeg -changeOrig -195,-233,0 -outfile $caseDir/sMRI/mri/${casePrefix}_seg.nrrd
    ImageMath $T1SkullStrippedCorrected -changeOrig -195,-233,0 -outfile $caseDir/sMRI/mri/${casePrefix}_T1.nrrd
    
    #DTIProc for AD
    dtiestim --dwi_image $caseDir/DTI/${casePrefix}_42_DWI*_QCed_VC_Upx2.nrrd --B0 $caseDir/DTI/${casePrefix}_DTI_B0.nrrd --idwi $caseDir/DTI/${casePrefix}_DTI_IDWI.nrrd --tensor_output $caseDir/DTI/${casePrefix}_DTI.nrrd  --correction nearest -m wls

    dtiprocess --dti_image $caseDir/DTI/${casePrefix}_42_DWI*_QCed_VC_Upx2_DTI_stripped_embed.nrrd --lambda1_output $caseDir/DTI/${casePrefix}_DTI_AD.nrrd -f $caseDir/DTI/${casePrefix}_DTI_FA.nrrd
    
    #Rigid Reg
    BRAINSFit --movingVolume $caseDir/sMRI/mri/${casePrefix}_T1.nrrd --fixedVolume $caseDir/DTI/${casePrefix}_DTI_AD.nrrd --linearTransform $caseDir/sMRI/mri/${casePrefix}_RegRigid.txt --useRigid --initializeTransformMode useCenterOfHeadAlign
    
    ANTS 3 -r Gauss\[3,1\] -i 100x30x5 -t SyN\[0.25\] -m CC\[$caseDir/DTI/${casePrefix}_DTI_FA.nrrd,$caseDir/sMRI/mri/${casePrefix}_T1.nrrd,1,8\] -m CC\[$caseDir/DTI/${casePrefix}_DTI_B0.nrrd,$caseDir/sMRI/mri/${casePrefix}_T1.nrrd,2,8\] -o $caseDir/sMRI/mri/${casePrefix}_Reg.nrrd --initial-affine $caseDir/sMRI/mri/${casePrefix}_RegRigid.txt --use-all-metrics-for-convergence

    ITKTransformTools MO2Aff $caseDir/sMRI/mri/${casePrefix}_RegAffine.txt $caseDir/sMRI/mri/${casePrefix}_RegAffine_ITK.txt
    ITKTransformTools invert $caseDir/sMRI/mri/${casePrefix}_RegAffine_ITK.txt $caseDir/sMRI/mri/${casePrefix}_RegAffineInv_ITK.txt
    ITKTransformTools concatenate $caseDir/sMRI/mri/${casePrefix}_GlobalWarp.nrrd -r $caseDir/DTI/${casePrefix}_DTI_AD.nrrd $caseDir/sMRI/mri/${casePrefix}_RegAffine_ITK.txt $caseDir/sMRI/mri/${casePrefix}_RegWarp.nrrd displacement
    ITKTransformTools concatenate $caseDir/sMRI/mri/${casePrefix}_GlobalInvWarp.nrrd -r $caseDir/sMRI/mri/${casePrefix}_T1.nrrd  $caseDir/sMRI/mri/${casePrefix}_RegInverseWarp.nrrd displacement $caseDir/sMRI/mri/${casePrefix}_RegAffineInv_ITK.txt 
  
    ResampleScalarVectorDWIVolume $caseDir/sMRI/mri/${casePrefix}_T1.nrrd $caseDir/DTI/${casePrefix}_T1_regDTI.nrrd -H $caseDir/sMRI/mri/${casePrefix}_GlobalWarp.nrrd --hfieldtype displacement -R $caseDir/DTI/${casePrefix}_DTI_AD.nrrd
  
    foreach surface ($caseDir/sMRI/surf/*vtk)
      polydatatransform --fiber_file $surface -D $caseDir/sMRI/mri/${casePrefix}_GlobalInvWarp.nrrd --inverty --invertx -o $caseDir/DTI/$surface:t:s/Surf./Surf.Reg./
    end
    
    #Merge both hemisphere
    polydatamerge -f $caseDir/DTI/${casePrefix}-SW-T1-cere-seg.img.lh-rev.img.MiddleSurf.Reg.vtk.AALcolor.vtk -g $caseDir/DTI/${casePrefix}-SW-T1-cere-seg.img.rh-rev.img.MiddleSurf.Reg.vtk.AALcolor.vtk -o $caseDir/DTI/${casePrefix}_combined_MiddleSurf_AALCOLOR.vtk

    polydatamerge -f $caseDir/DTI/${casePrefix}-SW-T1-cere-seg.img.lh-rev.img.InnerSurf.Reg.vtk -g $caseDir/DTI/${casePrefix}-SW-T1-cere-seg.img.rh-rev.img.InnerSurf.Reg.vtk -o $caseDir/DTI/${casePrefix}_combined_InnerSurf.vtk
    
  endif
end
