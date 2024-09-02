%% Registration optimization tool for the pons in MNI space for TRACK-PD data
clear all; close all; clc;

% Set names of data
rootdir = 'Z:\FHML_MHeNs\Urology_Div3\Thijs de rijk\TRACK\'
subs = {'TRACK-P001', 'TRACK-P003','TRACK-P004','TRACK-P005', 'TRACK-P006', 'TRACK-P007', 'TRACK-P016', 'TRACK-P018', 'TRACK-P019', 'TRACK-P022', 'TRACK-P023', 'TRACK-P024', 'TRACK-P025', 'TRACK-P026', 'TRACK-P028', 'TRACK-P031', 'TRACK-P033', 'TRACK-P034', 'TRACK-P038', 'TRACK-P039', 'TRACK-P041', 'TRACK-P043', 'TRACK-P045', 'TRACK-P046',  'TRACK-P080', 'TRACK-P110', 'TRACK-P111', 'TRACK-P112', 'TRACK-P113', 'TRACK-P115', 'TRACK-P116', 'TRACK-P117', 'TRACK-P118', 'TRACK-P119', 'TRACK-P121', 'TRACK-P122', 'TRACK-P124', 'TRACK-P125', 'TRACK-P126', 'TRACK-P127', 'TRACK-P130', 'TRACK-P135', 'TRACK-P136', 'TRACK-P137', 'TRACK-P138', 'TRACK-P140', 'TRACK-P142', 'TRACK-P143', 'TRACK-P146', 'TRACK-P147', 'TRACK-P148', 'TRACK-P149'}

file_name = '_fMRI_loc1_SCCTBL_3DMCTS_THPGLMF6c_undist_MNI.vtc';
file_name_bbx = '_fMRI_loc1_SCCTBL_3DMCTS_THPGLMF6c_undist_MNI_bbox.vtc';
vmr_name = '_anatomy_UNI_ISO_IIHC_MNI.vmr'
out = '\Out\'

mseError = zeros(48,1);

bbx = [140 178; 120 183; 110 144];

%% First we are opening the MNI template brain and applying the bounding box
MNI_name = 'MNI_ICBM152_T1_NLIN_ASYM_09c_BRAIN.vmr'
MNI_name_edges = 'ICBM452-IN-MNI152-SPACE_BRAIN_EDGES.vmr'
MNI_vmr = xff([rootdir MNI_name]);
MNI_vmr_edges = xff([rootdir MNI_name_edges]);

MNI_vmr_bbx = MNI_vmr.VMRData((bbx(1,1):bbx(1,2)), (bbx(2,1):bbx(2,2)), (bbx(3,1):bbx(3,2))); 
figure; sliceViewer(MNI_vmr_bbx);
title('Pons in MNI space from bbx')

MNI_vmr_edges_bbx = MNI_vmr_edges.VMRData((bbx(1,1):bbx(1,2)), (bbx(2,1):bbx(2,2)), (bbx(3,1):bbx(3,2))); 
figure; sliceViewer(MNI_vmr_edges_bbx);
title('Pons edges in MNI space from bbx')

figure
imshowpair(MNI_vmr_edges_bbx(:,:,22), MNI_vmr_bbx(:,:,22), "Scaling","joint")
title(['images before registration for subject', subs(pt)]);

MNI_vmr_edges_bbx = rescale(MNI_vmr_edges_bbx);

%% Here the bounding box is applied to the .vmr file and vtc file per subject. 
% The .vmr file will be used to register (using affine registration) to the MNI_vmr file, which results
% in a transformation matrix tform. This tform will be used to register (using
% imwarp) the VTC file better to MNI space

for pt = 1:numel(subs);
    % create bbx on vtc file
    d = [rootdir char(subs{pt}) out];
    f = [char(subs{pt}) file_name];
    subdir = [rootdir char(subs{pt}) out char(subs{pt}) file_name];
    vtc_new = vtc_apply_bbx(f, d, subdir, bbx_adj, 0);

    % apply bbx to vmr file
    anatomy_vmr_name = [rootdir char(subs{pt}) out char(subs{pt}) vmr_name];
    anatomy_vmr = xff(anatomy_vmr_name);
    anatomy_vmr_bbx = anatomy_vmr.VMRData((bbx(1,1):bbx(1,2)), (bbx(2,1):bbx(2,2)), (bbx(3,1):bbx(3,2)));
    figure; sliceViewer(anatomy_vmr_bbx);
    title('vmr anatomy');

    % Registration part
    [optimizer,metric] = imregconfig("monomodal");
    movingVolume = rescale(anatomy_vmr_bbx);
    fixedVolume = rescale(MNI_vmr_bbx);
    tform = imregtform(movingVolume, fixedVolume, 'affine', optimizer, metric, 'DisplayOptimization',true);

    % figure; sliceViewer(movingVolume);
    % title('Moving Volume affine');

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
    mseError_before = immse(fixedVolume, movingVolume);
    mseError(pt) = mseError_before;

    % Here the name and data of the adjusted vtc file (only containing the
    % earlier set bounding box (bbx)
    filename_vtc_bbx = '_fMRI_loc1_SCCTBL_3DMCTS_THPGLMF6c_undist_MNI_bbox_adj.vtc'
    subdir_vtc_bbx= [rootdir char(subs{pt}) out char(subs{pt}) filename_vtc_bbx];
    vtc_bbx = xff(subdir_vtc_bbx);

    size_VTC_bbx = size(vtc_bbx.VTCData);
    outputSizeRef = imref3d([size_VTC_bbx(2), size_VTC_bbx(3), size_VTC_bbx(4)]);

    new_vtc_adj = zeros(size_VTC_bbx);

    % Here the new vtc file is created which is registered to the pons by
    % using the earlier calculated tform (based on the affine registration
    % of the vmr files). Since imwarp can't handle 4D files, a for-loop is
    % created which warps the VTC files per slice.
    for n = 1:size_VTC_bbx(1);
        per_vtc_adj = squeeze(vtc_bbx.VTCData(n,:,:,:));
        new_vtc_adj(n,:,:,:) = imwarp(per_vtc_adj, tform, 'outputView', outputSizeRef);
    end

    % save new vtc data in new vtc file
    vtc_bbx.VTCData = new_vtc_adj;
    vtc_new_name = [char(subs{pt}) '_vtc_bbx_registered_to_MNI.vtc']
    vtc_bbx.SaveAs(vtc_new_name);

end 

