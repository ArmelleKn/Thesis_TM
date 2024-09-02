%% Registration optimization tool for the pons in MNI space for fMRI bladder state data
clear all; close all; clc;

% Set names of data
rootdir = 'Z:\FHML_MHeNs\Urology_Div3\Thijs de rijk\OAB fMRI\Data\'
subs =  {'fMRI_OAB_1008', 'fMRI_OAB_1013','fMRI_OAB_2002','fMRI_OAB_2004','fMRI_OAB_2011','fMRI_OAB_2012','fMRI_OAB_2013','fMRI_OAB_2017'};

file_name = '_SCCTBL_3DMCTS_THPGLMF6c_undist_256_sinc3_1x1.0_MNI.vtc'
file_name_bbx = '_SCCTBL_3DMCTS_THPGLMF6c_undist_256_sinc3_1x1.0_MNI_bbox_adj.vtc'
file_name_oldbbx = '_SCCTBL_3DMCTS_THPGLMF6c_undist_256_sinc3_1x1.0_MNI.vtc'

fmr_files = '\fmr_files\fmr_fullbladder\'
empty = 'empty_'

vmr_name = '_anat_IIHC_ISO_1p0_MNI.vmr'
out = '\Out\'

mseError = zeros(7,1);

bbx = [132 174; 126 178; 110 145];

%% First we are opening the MNI template brain and applying the bounding box
rootdir2 = 'Z:\FHML_MHeNs\Urology_Div3\Thijs de rijk\TRACK\'
MNI_name = 'MNI_ICBM152_T1_NLIN_ASYM_09c_BRAIN.vmr'
MNI_vmr = xff([rootdir2 MNI_name]);

% eerste index geeft van ventraal naar dorsaal, tweede crandiaal caudaal
MNI_vmr_bbx = MNI_vmr.VMRData((bbx(1,1):bbx(1,2)), (bbx(2,1):bbx(2,2)), (bbx(3,1):bbx(3,2))); 
figure; sliceViewer(MNI_vmr_bbx);
title('Pons in MNI space from bbx')

%% Here the bounding box is applied to the .vmr file and vtc file per subject. 
% The .vmr file will be used to register (using affine registration) to the MNI_vmr file, which results
% in a transformation matrix tform. This tform will be used to register (using
% imwarp) the VTC file better to MNI space

for pt = 1:numel(subs);

    % apply bbx to vmr file
    anatomy_vmr_name = [rootdir char(subs{pt}) fmr_files char(subs{pt}) vmr_name];
    anatomy_vmr = xff(anatomy_vmr_name);
    anatomy_vmr_bbx = anatomy_vmr.VMRData((bbx(1,1):bbx(1,2)), (bbx(2,1):bbx(2,2)), (bbx(3,1):bbx(3,2)));
    figure; sliceViewer(anatomy_vmr_bbx);
    title('vmr anatomy');

    % Registration part
    [optimizer,metric] = imregconfig("monomodal");
    movingVolume = rescale(anatomy_vmr_bbx);
    fixedVolume = rescale(MNI_vmr_bbx);
    tform = imregtform(movingVolume, fixedVolume, 'affine', optimizer, metric);

    figure; sliceViewer(movingVolume);
    title('Moving Volume affine');

    % Here the moving volume is registered to the fixed volume. By chosen
    % 'DisplayOptimization', true, the MSE is automatically calculated for
    % the final registered moving volume
    %registeredVolume = imwarp(movingVolume, tform, 'OutputView', imref3d(size(movingVolume)));
    movingRegistered = imregister(movingVolume, fixedVolume,'affine',optimizer,metric,'DisplayOptimization',true);


    % Display the fixed volume
    figure;
    sliceViewer(fixedVolume);
    title('Fixed Volume affine');

    % Display the registered moving volume
    figure; sliceViewer(registeredVolume);
    title('Registered Moving Volume affine');

    % Calculate error
    mseError_before = immse(fixedVolume, movingVolume)
    mseError(pt) = mseError_before;

    subdir_vtc_bbx= [rootdir char(subs{pt}) fmr_files char(subs{pt}) file_name_oldbbx];
    vtc_bbx = xff(subdir_vtc_bbx);

    size_VTC_bbx = size(vtc_bbx.VTCData);
    outputSizeRef = imref3d([size_VTC_bbx(2), size_VTC_bbx(3), size_VTC_bbx(4)]);

    new_vtc_adj = zeros(size_VTC_bbx);

    for n = 1:size_VTC_bbx(1);
        per_vtc_adj = squeeze(vtc_bbx.VTCData(n,:,:,:));
        new_vtc_adj(n,:,:,:) = imwarp(per_vtc_adj, tform, 'outputView', outputSizeRef);
    end

    % save new vtc data in new vtc file
    vtc_bbx.VTCData = new_vtc_adj;
    vtc_new_name = [char(subs{pt}) '_vtc_oldbbx_registered_to_MNI_affine.vtc']
    %  vtc_new_name = [empty char(subs{pt}) '_vtc_oldbbx_registered_to_MNI_affine.vtc']
    vtc_bbx.SaveAs(vtc_new_name);

end 
