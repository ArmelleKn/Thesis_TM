%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%%                                                                     %%%
%%%            MATLAB SCRIPT TO DETERMINE INTERACTION BETWEEN           %%%
%%%                     BARRINGTONS NUCLEUS AND new ROI                 %%%
%%%                             TRACK-PD data                           %%%
%%%                                                                     %%%
%%%                                                                     %%%
%%%                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This MATLAB script is able to calculate the interaction/correlation between
% Barrington's nucleus and our new found ROI. 

% made by: Armelle Knops, 10.07.24

%% Set Data
clear all; close all; clc; 

rootdir = 'C:\Users\armel\OneDrive\Documenten\TU_Delft_Master_II\TMjaar3\TRACK\Data\';
subs = {'TRACK-P001', 'TRACK-P003','TRACK-P004','TRACK-P005', 'TRACK-P006', 'TRACK-P007', 'TRACK-P016', 'TRACK-P018', 'TRACK-P019', 'TRACK-P022', 'TRACK-P023', 'TRACK-P024', 'TRACK-P025', 'TRACK-P026', 'TRACK-P028', 'TRACK-P031', 'TRACK-P033', 'TRACK-P034', 'TRACK-P038', 'TRACK-P039', 'TRACK-P041', 'TRACK-P043', 'TRACK-P045', 'TRACK-P046',  'TRACK-P080', 'TRACK-P110', 'TRACK-P111', 'TRACK-P112', 'TRACK-P113', 'TRACK-P115', 'TRACK-P116', 'TRACK-P117', 'TRACK-P118', 'TRACK-P119', 'TRACK-P121', 'TRACK-P122', 'TRACK-P124', 'TRACK-P125', 'TRACK-P126', 'TRACK-P127', 'TRACK-P130', 'TRACK-P135', 'TRACK-P136', 'TRACK-P137', 'TRACK-P138', 'TRACK-P140', 'TRACK-P142', 'TRACK-P143', 'TRACK-P146', 'TRACK-P147', 'TRACK-P148', 'TRACK-P149'}
subs_HC = {'TRACK-P001', 'TRACK-P004', 'TRACK-P005', 'TRACK-P006', 'TRACK-P016', 'TRACK-P022', 'TRACK-P028', 'TRACK-P043', 'TRACK-P116', 'TRACK-P117', 'TRACK-P121', 'TRACK-P135', 'TRACK-P138', 'TRACK-P140', 'TRACK-P142', 'TRACK-P143', 'TRACK-P147', 'TRACK-P148', 'TRACK-P149'}
subs_PD = {'TRACK-P003', 'TRACK-P007','TRACK-P018', 'TRACK-P019', 'TRACK-P023', 'TRACK-P024', 'TRACK-P025', 'TRACK-P026', 'TRACK-P031', 'TRACK-P033', 'TRACK-P034', 'TRACK-P038', 'TRACK-P039', 'TRACK-P041', 'TRACK-P045', 'TRACK-P046',  'TRACK-P080', 'TRACK-P110', 'TRACK-P111', 'TRACK-P112', 'TRACK-P113', 'TRACK-P115', 'TRACK-P118', 'TRACK-P119', 'TRACK-P122', 'TRACK-P124', 'TRACK-P125', 'TRACK-P126', 'TRACK-P127', 'TRACK-P130', 'TRACK-P136', 'TRACK-P137', 'TRACK-P146'}
subs_PD_noLUTS = {'TRACK-P024', 'TRACK-P033', 'TRACK-P039', 'TRACK-P041', 'TRACK-P110', 'TRACK-P112', 'TRACK-P119', 'TRACK-P122', 'TRACK-P124', 'TRACK-P130', 'TRACK-P136'}
subs_PD_LUTS = {'TRACK-P007', 'TRACK-P031', 'TRACK-P034', 'TRACK-P046', 'TRACK-P113', 'TRACK-P115', 'TRACK-P118', 'TRACK-P137'}

vtc_files_name = 'VTC_files\';
file_name = '_vtc_bbx_registered_to_MNI.vtc';

%bbx = [140 180; 120 185; 110 146];
bbx = [140 178; 120 183; 110 144];
%bbx_new = [140 178; 120 183; 110 144];
bbx_old = [132 174; 126 178; 110 145];

%% Load masks 
% Load mask of Barrington's nucleus 
Bar_maskfile = 'C:\Users\armel\OneDrive\Documenten\TU_Delft_Master_II\TMjaar3\TRACK\Data\Matlab_scripts\Barrington_MNI.vmr';
bar_mask = xff(Bar_maskfile);

% Load mask of Stripe
Stripe_MNI_maskfile = 'C:\Users\armel\OneDrive\Documenten\TU_Delft_Master_II\TMjaar3\TRACK\Data\VTC_files\Mask_stripe_MNI.nii';
Stripe_mask = niftiread(Stripe_MNI_maskfile);


%% Show masks in vmr without bbx
bar_mask_bbx = bar_mask.VMRData((bbx(1,1):bbx(1,2)), (bbx(2,1):bbx(2,2)), (bbx(3,1):bbx(3,2)));
bar_mask_bbx(bar_mask_bbx > 0) = 1;
figure; sliceViewer(bar_mask_bbx);
title('Barrington mask');

Stripe_mask_bbx = Stripe_mask(140:178, 120:183, 110:144);
% [140 178; 120 183; 110 144];
Stripe_mask_bbx(Stripe_mask_bbx > 0) = 1;
figure; sliceViewer(Stripe_mask_bbx);
title('Stripe mask');

% Choose group
sub = subs;
size_sub = size(sub);
size_sub = size_sub(2);

corr_all_sub = zeros(size_sub,1);

% stripe mask has 474 voxels
%% Calculate functional data (fMRI) in Barrington and PAG from VTC files and make CORRELATION MAPS
% Looping over every subject
%first_vol = squeeze(vtc.VTCData(1,:,:,:));
for pt = 1:numel(sub)
    subdir = [rootdir vtc_files_name char(sub{pt}) file_name];
    vtc = xff(subdir);

    % make zeros matrix for the eventual mean values of bar fmri data
    matrix_mean_bar = zeros(280, 256);
        
    % find the coordinates of bar mask
    voxel_ix_bar = find(bar_mask_bbx == 1);
        
    % Pay attention: NEW VTC file is used, named vtc_pons. 
    % This is the new vtc data based on the manual adjustment of the pons so it better fits in MNI space
    for vv = 1:numel(voxel_ix_bar);
        source_BN = vtc.VTCData(:,voxel_ix_bar(vv));
        matrix_mean_bar(:,vv) = source_BN;
    end
        
    % calculate the mean values of Bar with regard to the time, so of
    % all voxels in Barr while preserving the time component
    bar_mean = mean(matrix_mean_bar,2);
    
     % make zeros matrix for the eventual mean values of bar fmri data
    matrix_mean_stripe = zeros(280, 474);
        
    % find the coordinates of bar mask
    voxel_ix_stripe = find(Stripe_mask_bbx == 1);
        
    % Pay attention: NEW VTC file is used, named vtc_pons. 
    % This is the new vtc data based on the manual adjustment of the pons so it better fits in MNI space
    for bb = 1:numel(voxel_ix_stripe);
        source_stripe = vtc.VTCData(:,voxel_ix_stripe(bb));
        matrix_mean_stripe(:,bb) = source_stripe;
    end
        
    % calculate the mean values of Bar with regard to the time, so of
    % all voxels in Barr while preserving the time component
    stripe_mean = mean(matrix_mean_stripe,2);

    RL = corrcoef(bar_mean, stripe_mean)
    corr_all_sub(pt) = RL(2);

end % Here it means the loop ends

%% Calculate for PD patients
sub = subs_PD;
size_sub = size(sub);
size_sub = size_sub(2);

corr_PD_sub = zeros(size_sub,1);

% Looping over every subject
for pt = 1:numel(sub)
    subdir = [rootdir vtc_files_name char(sub{pt}) file_name];
    vtc = xff(subdir);

    % make zeros matrix for the eventual mean values of bar fmri data
    matrix_mean_bar = zeros(280, 256);
        
    % find the coordinates of bar mask
    voxel_ix_bar = find(bar_mask_bbx == 1);
        
    % Pay attention: NEW VTC file is used, named vtc_pons. 
    % This is the new vtc data based on the manual adjustment of the pons so it better fits in MNI space
    for vv = 1:numel(voxel_ix_bar);
        source_BN = vtc.VTCData(:,voxel_ix_bar(vv));
        matrix_mean_bar(:,vv) = source_BN;
    end
        
    % calculate the mean values of Bar with regard to the time, so of
    % all voxels in Barr while preserving the time component
    bar_mean = mean(matrix_mean_bar,2);
    
     % make zeros matrix for the eventual mean values of bar fmri data
    matrix_mean_stripe = zeros(280, 474);
        
    % find the coordinates of bar mask
    voxel_ix_stripe = find(Stripe_mask_bbx == 1);
        
    % Pay attention: NEW VTC file is used, named vtc_pons. 
    % This is the new vtc data based on the manual adjustment of the pons so it better fits in MNI space
    for bb = 1:numel(voxel_ix_stripe);
        source_stripe = vtc.VTCData(:,voxel_ix_stripe(bb));
        matrix_mean_stripe(:,bb) = source_stripe;
    end
        
    % calculate the mean values of Bar with regard to the time, so of
    % all voxels in Barr while preserving the time component
    stripe_mean = mean(matrix_mean_stripe,2);

    RL = corrcoef(bar_mean, stripe_mean);
    corr_PD_sub(pt) = RL(2);

end % Here it means the loop ends

%% Calculate for HC patients
sub = subs_HC;
size_sub = size(sub);
size_sub = size_sub(2);

corr_HC_sub = zeros(size_sub,1);

% Looping over every subject
for pt = 1:numel(sub)
    subdir = [rootdir vtc_files_name char(sub{pt}) file_name];
    vtc = xff(subdir);

    % make zeros matrix for the eventual mean values of bar fmri data
    matrix_mean_bar = zeros(280, 256);
        
    % find the coordinates of bar mask
    voxel_ix_bar = find(bar_mask_bbx == 1);
        
    % Pay attention: NEW VTC file is used, named vtc_pons. 
    % This is the new vtc data based on the manual adjustment of the pons so it better fits in MNI space
    for vv = 1:numel(voxel_ix_bar);
        source_BN = vtc.VTCData(:,voxel_ix_bar(vv));
        matrix_mean_bar(:,vv) = source_BN;
    end
        
    % calculate the mean values of Bar with regard to the time, so of
    % all voxels in Barr while preserving the time component
    bar_mean = mean(matrix_mean_bar,2);
    
     % make zeros matrix for the eventual mean values of bar fmri data
    matrix_mean_stripe = zeros(280, 474);
        
    % find the coordinates of bar mask
    voxel_ix_stripe = find(Stripe_mask_bbx == 1);
        
    % Pay attention: NEW VTC file is used, named vtc_pons. 
    % This is the new vtc data based on the manual adjustment of the pons so it better fits in MNI space
    for bb = 1:numel(voxel_ix_stripe);
        source_stripe = vtc.VTCData(:,voxel_ix_stripe(bb));
        matrix_mean_stripe(:,bb) = source_stripe;
    end
        
    % calculate the mean values of Bar with regard to the time, so of
    % all voxels in Barr while preserving the time component
    stripe_mean = mean(matrix_mean_stripe,2);

    RL = corrcoef(bar_mean, stripe_mean)
    corr_HC_sub(pt) = RL(2);

end % Here it means the loop ends

%% Calculate for PD noLUTS patients
sub = subs_PD_noLUTS;
size_sub = size(sub);
size_sub = size_sub(2);

corr_PD_noLUTS_sub = zeros(size_sub,1);

% Looping over every subject
for pt = 1:numel(sub)
    subdir = [rootdir vtc_files_name char(sub{pt}) file_name];
    vtc = xff(subdir);

    % make zeros matrix for the eventual mean values of bar fmri data
    matrix_mean_bar = zeros(280, 256);
        
    % find the coordinates of bar mask
    voxel_ix_bar = find(bar_mask_bbx == 1);
        
    % Pay attention: NEW VTC file is used, named vtc_pons. 
    % This is the new vtc data based on the manual adjustment of the pons so it better fits in MNI space
    for vv = 1:numel(voxel_ix_bar);
        source_BN = vtc.VTCData(:,voxel_ix_bar(vv));
        matrix_mean_bar(:,vv) = source_BN;
    end
        
    % calculate the mean values of Bar with regard to the time, so of
    % all voxels in Barr while preserving the time component
    bar_mean = mean(matrix_mean_bar,2);
    
     % make zeros matrix for the eventual mean values of bar fmri data
    matrix_mean_stripe = zeros(280, 474);
        
    % find the coordinates of bar mask
    voxel_ix_stripe = find(Stripe_mask_bbx == 1);
        
    % Pay attention: NEW VTC file is used, named vtc_pons. 
    % This is the new vtc data based on the manual adjustment of the pons so it better fits in MNI space
    for bb = 1:numel(voxel_ix_stripe);
        source_stripe = vtc.VTCData(:,voxel_ix_stripe(bb));
        matrix_mean_stripe(:,bb) = source_stripe;
    end
        
    % calculate the mean values of Bar with regard to the time, so of
    % all voxels in Barr while preserving the time component
    stripe_mean = mean(matrix_mean_stripe,2);

    RL = corrcoef(bar_mean, stripe_mean)
    corr_PD_noLUTS_sub(pt) = RL(2);

end % Here it means the loop ends

%% Calculate for PD LUTS patients
sub = subs_PD_LUTS;
size_sub = size(sub);
size_sub = size_sub(2);

corr_PD_LUTS_sub = zeros(size_sub,1);

% Looping over every subject
for pt = 1:numel(sub);
    subdir = [rootdir vtc_files_name char(sub{pt}) file_name];
    vtc = xff(subdir);

    % make zeros matrix for the eventual mean values of bar fmri data
    matrix_mean_bar = zeros(280, 256);
        
    % find the coordinates of bar mask
    voxel_ix_bar = find(bar_mask_bbx == 1);
        
    % Pay attention: NEW VTC file is used, named vtc_pons. 
    % This is the new vtc data based on the manual adjustment of the pons so it better fits in MNI space
    for vv = 1:numel(voxel_ix_bar);
        source_BN = vtc.VTCData(:,voxel_ix_bar(vv));
        matrix_mean_bar(:,vv) = source_BN;
    end
        
    % calculate the mean values of Bar with regard to the time, so of
    % all voxels in Barr while preserving the time component
    bar_mean = mean(matrix_mean_bar,2);
    
     % make zeros matrix for the eventual mean values of bar fmri data
    matrix_mean_stripe = zeros(280, 474);
        
    % find the coordinates of bar mask
    voxel_ix_stripe = find(Stripe_mask_bbx == 1);
        
    % Pay attention: NEW VTC file is used, named vtc_pons. 
    % This is the new vtc data based on the manual adjustment of the pons so it better fits in MNI space
    for bb = 1:numel(voxel_ix_stripe);
        source_stripe = vtc.VTCData(:,voxel_ix_stripe(bb));
        matrix_mean_stripe(:,bb) = source_stripe;
    end
        
    % calculate the mean values of Bar with regard to the time, so of
    % all voxels in Barr while preserving the time component
    stripe_mean = mean(matrix_mean_stripe,2);

    RL = corrcoef(bar_mean, stripe_mean);
    corr_PD_LUTS_sub(pt) = RL(2);

end % Here it means the loop ends

%% Calculate whether the difference in correlation between two groups is statistically significant
corr_all_sub_Z = 0.5 * log((1 + corr_all_sub) ./ (1 - corr_all_sub));
corr_HC_sub_Z = 0.5 * log((1 + corr_HC_sub) ./ (1 - corr_HC_sub));
corr_PD_sub_Z = 0.5 * log((1 + corr_PD_sub) ./ (1 - corr_PD_sub));
corr_PD_LUTS_sub_Z = 0.5 * log((1 + corr_PD_LUTS_sub) ./ (1 - corr_PD_LUTS_sub));
corr_PD_noLUTS_sub_Z = 0.5 * log((1 + corr_PD_noLUTS_sub) ./ (1 - corr_PD_noLUTS_sub));

% Significant difference between PD with or without LUTS
[h,p,stats] = ranksum(corr_PD_LUTS_sub_Z, corr_PD_noLUTS_sub_Z)

%figure; sliceViewer(first_vol, SliceDirection="X")