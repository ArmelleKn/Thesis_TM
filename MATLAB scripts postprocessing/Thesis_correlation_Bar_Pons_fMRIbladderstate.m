%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                                                                     %%%
%%%                                                                     %%%
%%%            MATLAB SCRIPT TO DETERMINE INTERACTION BETWEEN           %%%
%%%                     BARRINGTONS NUCLEUS AND Pons                    %%%
%%%                    Determines correlations between                  %%%
%%%                      cluster and correlation maps                   %%%
%%%                                                                     %%%
%%%                                                                     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This MATLAB script is able to calculate the interaction/correlation between
% Barrington's nucleus and Pons. 

% made by: Armelle Knops, 01.07.24

%% Set Data
clear all; close all; clc; 

rootdir = 'C:\Users\armel\OneDrive\Documenten\TU_Delft_Master_II\TMjaar3\TRACK\Data\';
%subs = {'TRACK-P001', 'TRACK-P003','TRACK-P004','TRACK-P005', 'TRACK-P006', 'TRACK-P007', 'TRACK-P016', 'TRACK-P018', 'TRACK-P019', 'TRACK-P022', 'TRACK-P023', 'TRACK-P024', 'TRACK-P025', 'TRACK-P026', 'TRACK-P028', 'TRACK-P031', 'TRACK-P033', 'TRACK-P034', 'TRACK-P038', 'TRACK-P039', 'TRACK-P041', 'TRACK-P043', 'TRACK-P045', 'TRACK-P046',  'TRACK-P080', 'TRACK-P110', 'TRACK-P111', 'TRACK-P112', 'TRACK-P113', 'TRACK-P115', 'TRACK-P116', 'TRACK-P117', 'TRACK-P118', 'TRACK-P119', 'TRACK-P121', 'TRACK-P122', 'TRACK-P124', 'TRACK-P125', 'TRACK-P126', 'TRACK-P127', 'TRACK-P130', 'TRACK-P135', 'TRACK-P136', 'TRACK-P137', 'TRACK-P138', 'TRACK-P140', 'TRACK-P142', 'TRACK-P143', 'TRACK-P146', 'TRACK-P147', 'TRACK-P148', 'TRACK-P149'}
%subs_HC = {'TRACK-P001', 'TRACK-P004', 'TRACK-P005', 'TRACK-P006', 'TRACK-P016', 'TRACK-P022', 'TRACK-P028', 'TRACK-P043', 'TRACK-P116', 'TRACK-P117', 'TRACK-P121', 'TRACK-P135', 'TRACK-P138', 'TRACK-P140', 'TRACK-P142', 'TRACK-P143', 'TRACK-P147', 'TRACK-P148', 'TRACK-P149'}
%subs_PD = {'TRACK-P003', 'TRACK-P007','TRACK-P018', 'TRACK-P019', 'TRACK-P023', 'TRACK-P024', 'TRACK-P025', 'TRACK-P026', 'TRACK-P031', 'TRACK-P033', 'TRACK-P034', 'TRACK-P038', 'TRACK-P039', 'TRACK-P041', 'TRACK-P045', 'TRACK-P046',  'TRACK-P080', 'TRACK-P110', 'TRACK-P111', 'TRACK-P112', 'TRACK-P113', 'TRACK-P115', 'TRACK-P118', 'TRACK-P119', 'TRACK-P122', 'TRACK-P124', 'TRACK-P125', 'TRACK-P126', 'TRACK-P127', 'TRACK-P130', 'TRACK-P136', 'TRACK-P137', 'TRACK-P146'}
%subs_PD_noLUTS = {'TRACK-P024', 'TRACK-P033', 'TRACK-P039', 'TRACK-P041', 'TRACK-P110', 'TRACK-P112', 'TRACK-P119', 'TRACK-P122', 'TRACK-P124', 'TRACK-P130', 'TRACK-P136'}
%subs_PD_LUTS = {'TRACK-P007', 'TRACK-P031', 'TRACK-P034', 'TRACK-P046', 'TRACK-P113', 'TRACK-P115', 'TRACK-P118', 'TRACK-P137'}
subs =  {'fMRI_OAB_1008', 'fMRI_OAB_1013', 'fMRI_OAB_2004','fMRI_OAB_2011','fMRI_OAB_2012','fMRI_OAB_2013','fMRI_OAB_2017'};
rootdir_vtc = 'C:\Users\armel\OneDrive\Documenten\TU_Delft_Master_II\TMjaar3\TRACK\Data\VTC_files\'
rootdir_vtc_old = 'Z:\FHML_MHeNs\Urology_Div3\Thijs de rijk\OAB fMRI\Data\'
fmr_files = '\fmr_files\fmr_fullbladder\'
empty = 'empty_'

vtc_files_name = 'VTC_files\';
%file_name = '_vtc_oldbbx_tonewbbx_registered_to_MNI_affine.vtc';
%file_name = '_SCCTBL_3DMCTS_THPGLMF6c_undist_256_sinc3_1x1.0_MNI_ALIGNED.vtc'
%file_name = '_vtc_oldbbx_registered_to_MNI_rigid.vtc'
file_name = '_vtc_oldbbx_registered_to_MNI_affine.vtc'

%bbx = [140 180; 120 185; 110 146];
%bbx = [140 178; 120 183; 110 144];
bbx = [132 174; 126 178; 110 145];

%% Load masks 
% Load mask of Barrington's nucleus 
Bar_maskfile = 'C:\Users\armel\OneDrive\Documenten\TU_Delft_Master_II\TMjaar3\TRACK\Data\Matlab_scripts\Barrington_MNI.vmr';
bar_mask = xff(Bar_maskfile);

% Load mask of Pons
Pons_MNI_maskfile = 'C:\Users\armel\OneDrive\Documenten\TU_Delft_Master_II\TMjaar3\TRACK\Data\Matlab_scripts\Pons_dilated_MNI.vmr';
Pons_mask = xff(Pons_MNI_maskfile);

%% Show masks in vmr without bbx
bar_mask_bbx = bar_mask.VMRData((bbx(1,1):bbx(1,2)), (bbx(2,1):bbx(2,2)), (bbx(3,1):bbx(3,2)));
bar_mask_bbx(bar_mask_bbx > 0) = 1;
figure; sliceViewer(bar_mask_bbx);
title('Barrington mask');

Pons_mask_bbx = Pons_mask.VMRData((bbx(1,1):bbx(1,2)), (bbx(2,1):bbx(2,2)), (bbx(3,1):bbx(3,2)));
Pons_mask_bbx(Pons_mask_bbx > 0) = 1;
figure; sliceViewer(Pons_mask_bbx);
title('Pons mask');

% Choose group
sub = subs;
size_sub = size(sub);
size_sub = size_sub(2);

% Adjust to which group you pick
%all_maps = zeros(size_sub,41,66,37);
%all_maps = zeros(size_sub, 39, 64, 35);
all_maps = zeros(size_sub, 43, 53, 36);

%% Calculate functional data (fMRI) in Barrington and Pons from VTC files and make CORRELATION MAPS
% Looping over every subject
for pt = 1:numel(sub);
    %subdir = [rootdir_vtc empty char(sub{pt}) file_name];
    subdir = [rootdir_vtc char(sub{pt}) file_name]
    vtc = xff(subdir);

    % make zeros matrix for the eventual mean values of bar fmri data
    matrix_mean_bar = zeros(420, 256);
    % matrix_mean_bar = zeros(420, 256);
        
    % find the coordinates of bar mask
    voxel_ix_bar = find(bar_mask_bbx == 1);
        
    for vv = 1:numel(voxel_ix_bar);
        source_BN = vtc.VTCData(:,voxel_ix_bar(vv));
        matrix_mean_bar(:,vv) = source_BN;
    end
        
    % calculate the mean values of Bar with regard to the time, so of
    % all voxels in Barr while preserving the time component
    bar_mean = mean(matrix_mean_bar,2);
        
    % Find the values of the masks of Pons and the corresponding fMRI data in VTC file, with calculation of the mean values in time of Barr

    % find the coordinates of Pons mask
    voxel_ix_Pons = find(Pons_mask_bbx == 1);
        
    % make zeros matrix for the fmri data of Pons 
    len = length(voxel_ix_Pons);
    matrix_Pons = zeros(420,len);
        
    % make zeros matrix for correlation coefficients
    matrix_cor = zeros(1,len);
        
    % Use the Pons mask in order to find the corresponding BOLD signals
    % in VTC file of Pons (saved in matrix_Pons), then correlate these values of Pons with mean
    % Bar. This data saved in matrix_cor
    for pp = 1:numel(voxel_ix_Pons);
        target_Pons = vtc.VTCData(:,voxel_ix_Pons(pp));
        matrix_Pons(:,pp) = target_Pons;
        RL = corrcoef(bar_mean, matrix_Pons(:,pp));
        matrix_cor(pp) = RL(2);
    end
        
    % Here we are gonna scale the values to normalize the data
    %Using Fisher Z-score
    matrix_cor_Z = 0.5 * log((1 + matrix_cor) ./ (1 - matrix_cor));

    % Make CORRELATION MAP between mean fmri data of Bar and every
    % voxel in Pons which is saved in matrix_cor.
    size_Pons = size(Pons_mask_bbx);
    map_Pons_bn = zeros(size_Pons(1), size_Pons(2), size_Pons(3));
        
    % Here the correlations of matrix_cor are put on the right place in
    % Pons in order to adequately visualize it and give the values the
    % right place. TAKE THE RIGHT VALUE AFTER NORMALIZATION
    for pp = 1:numel(voxel_ix_Pons);
        map_Pons_bn(voxel_ix_Pons(pp)) = matrix_cor_Z(pp);
    end

    % There are some NaN values, this way they will be replaced with
    % 0, otherwise the for loop doesn't go entirely
    map_Pons_bn(isnan(map_Pons_bn))=0;

    % Visualisation of comparison mean function in Barrington's nucleus
    % with every voxel in Pons
    cmap = parula(50);
    clim([-1 1])
    figure; sliceViewer(map_Pons_bn, "Colormap", cmap);
    colorbar
    title(['comparison mean function BN with every voxel in Pons for suject', sub(pt)]) 

    % Save CORRELATION MAPS, also to call them back again.
    % Important that there must be a map name 'Output' to save the
    % correlation maps in there
    ch0 = 'Output/';
    ch1 = sub(pt);
    ch1 = ch1{1};
    ch2 = 'Map_Pons_BN_Z_full_affine_oldbbx';
    % ch2 = 'Map_Pons_BN_Z_empty_affine_oldbbx';
    ch3 = '.mat';
    str1 = append(ch0,ch1,ch2,ch3);

    % make empty and difference map here and save them
    all_maps(pt,:,:,:) = map_Pons_bn;

    save(str1, "map_Pons_bn");
end % Here it means the loop ends

% Make average_map using all_maps variable and save it
average_map = squeeze(mean(all_maps,1));
save('Map_Pons_BN_Z_full_affine_oldbbx', "average_map");
%save('Map_Pons_BN_Z_empty_affine_oldbbx', "average_map");