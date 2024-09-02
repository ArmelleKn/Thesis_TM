#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul  1 14:33:16 2021

@author: rutten 
Adjusted by Armelle 2024
"""


import os

rootdir= 'Z:/FHML_MHeNs/Urology_Div3/Thijs de rijk/TRACK/SB01/Out/' #'/Volumes/Data/FHML/M7044/DATA/raw_data/'
#subj= ['TRACK-P002', 'TRACK-P003', 'TRACK-P004', 'TRACK-P005', 'TRACK-P006', 'TRACK-P007', 'TRACK-P008', 'TRACK-P009', 'TRACK-P010'] #['TRACK-P001'] #['SB01','SB02','SB03','SB04','SB05','SB06','SB07','SB08','SB09','SB10','SB11','SB12','SB13','SB14','SB15','SB16',
      #'SB17','SB18','SB19','SB20','SB21','SB22','SB23','SB24','SB25']
#subj = ['TRACK-P003']
#subj= ['TRACK-P001', 'TRACK-P002', 'TRACK-P003', 'TRACK-P004', 'TRACK-P005', 'TRACK-P006', 'TRACK-P007', 'TRACK-P008', 'TRACK-P009', 'TRACK-P010', 'TRACK-P011', 'TRACK-P012', 'TRACK-P013', 'TRACK-P014', 'TRACK-P015', 'TRACK-P016', 'TRACK-P017', 'TRACK-P018', 'TRACK-P019', 'TRACK-P020', 'TRACK-P021', 'TRACK-P022', 'TRACK-P023', 'TRACK-P024', 'TRACK-P025', 'TRACK-P026', 'TRACK-P027', 'TRACK-P028', 'TRACK-P029', 'TRACK-P030', 'TRACK-P031', 'TRACK-P032', 'TRACK-P033', 'TRACK-P034', 'TRACK-P035', 'TRACK-P036', 'TRACK-P037', 'TRACK-P038', 'TRACK-P039', 'TRACK-P040', 'TRACK-P041', 'TRACK-P042', 'TRACK-P043', 'TRACK-P044', 'TRACK-P045', 'TRACK-P046', 'TRACK-P047', 'TRACK-P048', 'TRACK-P049', 'TRACK-P050', 'TRACK-P051', 'TRACK-P052', 'TRACK-P053', 'TRACK-P054', 'TRACK-P055', 'TRACK-P056', 'TRACK-P057', 'TRACK-P058', 'TRACK-P059', 'TRACK-P060', 'TRACK-P061', 'TRACK-P062', 'TRACK-P063', 'TRACK-P064', 'TRACK-P065', 'TRACK-P066', 'TRACK-P067', 'TRACK-P068', 'TRACK-P069', 'TRACK-P070', 'TRACK-P071', 'TRACK-P072', 'TRACK-P073', 'TRACK-P074', 'TRACK-P075', 'TRACK-P076', 'TRACK-P077', 'TRACK-P078', 'TRACK-P079', 'TRACK-P080', 'TRACK-P081', 'TRACK-P082', 'TRACK-P083', 'TRACK-P084', 'TRACK-P085', 'TRACK-P086', 'TRACK-P088', 'TRACK-P089', 'TRACK-P090','TRACK-P091', 'TRACK-P092', 'TRACK-P093', 'TRACK-P094', 'TRACK-P095', 'TRACK-P096', 'TRACK-P097', 'TRACK-P098', 'TRACK-P099', 'TRACK-P100', 'TRACK-P101', 'TRACK-P102', 'TRACK-P103', 'TRACK-P104', 'TRACK-P105', 'TRACK-P106', 'TRACK-P107', 'TRACK-P108', 'TRACK-P109', 'TRACK-P110', 'TRACK-P111', 'TRACK-P112', 'TRACK-P113', 'TRACK-P114', 'TRACK-P115', 'TRACK-P116', 'TRACK-P117', 'TRACK-P118', 'TRACK-P119', 'TRACK-P120', 'TRACK-P121', 'TRACK-P122', 'TRACK-P123', 'TRACK-P124', 'TRACK-P125', 'TRACK-P126', 'TRACK-P127', 'TRACK-P128', 'TRACK-P129', 'TRACK-P130', 'TRACK-P131', 'TRACK-P132', 'TRACK-P133', 'TRACK-P134', 'TRACK-P135', 'TRACK-P136', 'TRACK-P137', 'TRACK-P138', 'TRACK-P139', 'TRACK-P140', 'TRACK-P141', 'TRACK-P142', 'TRACK-P143', 'TRACK-P144', 'TRACK-P145', 'TRACK-P146', 'TRACK-P147', 'TRACK-P148', 'TRACK-P149', 'TRACK-P150', 'TRACK-P151'] 
subj = ['TRACK-P004', 'TRACK-P005']
rootOUT= 'Z:/FHML_MHeNs/Urology_Div3/Thijs de rijk/TRACK/SB01/Out/'

rootF='ASIA1_001_fMRI_loc1'
rootFpp = 'ASIA1_001_fMRI_SCCTBL_3DMCTS_THPGLMF6c.fmr'
rootV= 'fMRI_ASIA1_001_ana_ISO_IIHC.vmr' #'ASIA1_001_MPRAGE_IIHC.vmr'
rootVMNI='ASIA1_001_MPRAGE_IIHC_ACPC_MNI.vmr'
rootIA = 'ASIA1_001_fMRI_SCCTBL_3DMCTS_THPGLMF6c-TO-ASIA1_001_MPRAGE_IIHC_IA.trf'
rootFA = 'ASIA1_001_fMRI_SCCTBL_3DMCTS_THPGLMF6c-TO-ASIA1_001_MPRAGE_IIHC_BBR_FA.trf'
rootMNI = 'ASIA1_001_MPRAGE_IIHC_ACPC_TO_MNI_a12.trf'

rootVMR = 'fMRI_ASIA1_001_ana_ISO_IIHC.vmr'#fMRI_TRACK-P002_ana.vmr

vtcresolution = 3

pp_steps = ['SCCTBL', '3DMCTS', 'THPGLMF8c']
thpf_cutoff_Hz = 0.01

fmr_preprocessing = True
fmr_coregistration = False
fmr_vtccreation = False

for isubj in subj:
    
    if fmr_preprocessing:
        print('Starting fmr pre-processing for subject ' + isubj + '...')
        dirname=rootdir+isubj+'/'
    
        infile = rootdir + rootF + '.fmr'
        infile = infile.replace('ASIA1_001',isubj)
        infile = infile.replace('SB01', isubj)
        print(infile)
  
        fmr_doc = bv.open(infile)
        sctc_pass = fmr_doc.correct_slicetiming_using_timingtable(1)
        if sctc_pass:
            print('Slice scan-time correction performed successfully for subject ' + isubj + '.')
        else:
            print('Slice scan-time correction failed for subject ' + isubj + '!')        
    
        fmr_doc.close()
    

        infile = rootdir + rootF + '_' + pp_steps[0] + '.fmr'
        infile = infile.replace('ASIA1_001',isubj)
        infile = infile.replace('SB01', isubj)
        print(infile)
        fmr_doc = bv.open(infile)
        motion_pass = fmr_doc.correct_motion_ext(0,2,True,100,True,True)
        if motion_pass:
            print('Motion correction performed successfully for subject ' + isubj + '.')
        else:
            print('Motion correction failed for subject ' + isubj + '!')        

        fmr_doc.close()
    
        infile = rootdir + rootF + '_' + pp_steps[0] + '_' + pp_steps[1] + '.fmr'
        infile = infile.replace('ASIA1_001',isubj)
        infile = infile.replace('SB01', isubj)
        print(infile)
        fmr_doc = bv.open(infile)
        #nrofcycles = round(thpf_cutoff_Hz/((fmr_doc.TR/1000)/fmr_doc.n_volumes))
        nrofcycles = 6
        thpf_pass = fmr_doc.filter_temporal_highpass_glm_fourier(nrofcycles)
        if thpf_pass:
            print('Temporal high-pass filter performed successfully for subject ' + isubj + '.')
        else:
            print('Temporal high-pass filter failed for subject ' + isubj + '!')       

        fmr_doc.close()
    
        if sctc_pass and motion_pass and thpf_pass:
            print('Saving .fmr file...')
            file_name_save = rootdir + rootFpp
            file_name_save = file_name_save.replace('ASIA1_001',isubj)
            file_name_save = file_name_save.replace('SB01', isubj)
            
            print(file_name_save)
            fmr_doc.save_as(file_name_save)
            
            print('Clearing up files...')
            infile = rootdir + rootF + '_' + pp_steps[0] + '.fmr'
            infile = infile.replace('ASIA1_001',isubj)
            infile = infile.replace('SB01', isubj)
            fmr_doc = bv.open(infile)
            fmr_doc.remove()

            infile = rootdir + rootF + '_' + pp_steps[0] + '_' + pp_steps[1] + '.fmr'
            infile = infile.replace('ASIA1_001',isubj)
            infile = infile.replace('SB01', isubj)
            fmr_doc = bv.open(infile)
            fmr_doc.remove()
    
    if fmr_coregistration:
        print('Starting coregistration for subject ' + isubj + '...')    
        dirname=rootdir+isubj+'/'
        infile = dirname + rootVMR
        infile = infile.replace('ASIA1_001',isubj)
        print(infile)

        vmr_doc = bv.open(infile)
        
        
        infile = dirname + rootFpp
        infile = infile.replace('ASIA1_001',isubj)

        cor_pass = vmr_doc.coregister_fmr_to_vmr_using_bbr(file_name_save) #file_name_save)   
        if cor_pass:
            print('Coregistration succesfull for ' + isubj)
        else:
            print('Coregistration failed for ' + isubj + '!')
            
        #vmr_doc.close()
            
    if fmr_vtccreation:
        print('Starting vtc creation for subject ' + isubj + '...')    
        print('Files used:')
        

        dirname=rootdir+isubj+'/'
        
        infile = dirname + rootVMNI
        infile = infile.replace('ASIA1_001',isubj)
        print(infile)
        
        fmrname = dirname + rootFpp
        fmrname = fmrname.replace('ASIA1_001',isubj)     
        print(fmrname)
        
        IAname = dirname + rootIA
        IAname = IAname.replace('ASIA1_001',isubj)
        print(IAname)
        
        FAname = dirname + rootFA
        FAname = FAname.replace('ASIA1_001',isubj)
        print(FAname)
        
        MNIname = dirname + rootMNI
        MNIname = MNIname.replace('ASIA1_001',isubj)
        print(MNIname)

        
        VTCname = fmrname
        VTCname = VTCname.replace('.fmr','_MNI.vtc')


        vmr_doc = bv.open(infile)


        vtcpass = vmr_doc.create_vtc_in_mni_space(fmrname, IAname, FAname, MNIname, VTCname, vtcresolution, 2, 100, 2)
        if vtcpass:
            print('VTC file succesfully created: ' + VTCname)
        else:
            print('VTC creation failed for ' + isubj + '!')
        
            
        

