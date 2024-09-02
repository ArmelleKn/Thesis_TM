%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%%                                                                     %%%
%%%            MATLAB SCRIPT TO DETERMINE INTERACTION BETWEEN           %%%
%%%                     BARRINGTONS NUCLEUS AND new ROI                 %%%
%%%                          fMRI bladder state data                    %%%
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
subs =  {'fMRI_OAB_1008', 'fMRI_OAB_1013', 'fMRI_OAB_2004','fMRI_OAB_2011','fMRI_OAB_2012','fMRI_OAB_2013','fMRI_OAB_2017'};
rootdir_vtc = 'C:\Users\armel\OneDrive\Documenten\TU_Delft_Master_II\TMjaar3\TRACK\Data\VTC_files\'
rootdir_vtc_old = 'Z:\FHML_MHeNs\Urology_Div3\Thijs de rijk\OAB fMRI\Data\'
fmr_files_empty = '\fmr_files\fmr_emptybladder\'
fmr_files_full = '\fmr_files\fmr_fullbladder\'
empty = 'empty_'

vtc_files_name = 'VTC_files\';
file_name = '_vtc_oldbbx_registered_to_MNI_affine.vtc'
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
bar_mask_bbx = bar_mask.VMRData((bbx_old(1,1):bbx_old(1,2)), (bbx_old(2,1):bbx_old(2,2)), (bbx_old(3,1):bbx_old(3,2)));
bar_mask_bbx(bar_mask_bbx > 0) = 1;
figure; sliceViewer(bar_mask_bbx);
title('Barrington mask');

Stripe_mask_bbx = Stripe_mask(132:174, 126:178, 110:145);
% [140 178; 120 183; 110 144];
Stripe_mask_bbx(Stripe_mask_bbx > 0) = 1;
figure; sliceViewer(Stripe_mask_bbx);
title('Stripe mask');

% Choose group
sub = subs;
size_sub = size(sub);
size_sub = size_sub(2);

corr_all_empty_olddata = zeros(size_sub,1);

% stripe mask has 474 voxels
%% Calculate functional data (fMRI) in Barrington and PAG from VTC files and make CORRELATION MAPS
% Looping over every subject
for pt = 1:numel(sub)
    subdir = [rootdir_vtc empty char(sub{pt}) file_name];
    vtc = xff(subdir);

    % make zeros matrix for the eventual mean values of bar fmri data
    matrix_mean_bar = zeros(420, 256);
        
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
    matrix_mean_stripe = zeros(420, 474);
        
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
    corr_all_empty_olddata(pt) = RL(2);

end % Here it means the loop ends

%% Calculate for PD patients
corr_all_full_olddata = zeros(size_sub,1);

% Looping over every subject
for pt = 1:numel(sub)
    subdir = [rootdir_vtc char(sub{pt}) file_name];
    vtc = xff(subdir);

    % make zeros matrix for the eventual mean values of bar fmri data
    matrix_mean_bar = zeros(420, 256);
        
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
    matrix_mean_stripe = zeros(420, 474);
        
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
    corr_all_full_olddata(pt) = RL(2);

end % Here it means the loop ends


%%
corr_all_empty_olddata_Z = 0.5 * log((1 + corr_all_empty_olddata) ./ (1 - corr_all_empty_olddata));
corr_all_full_olddata_Z = 0.5 * log((1 + corr_all_full_olddata) ./ (1 - corr_all_full_olddata));
[pval, h, stats] = signrank(corr_all_empty_olddata_Z, corr_all_full_olddata_Z);