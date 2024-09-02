#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Jul  1 14:33:16 2021



@author: rutten
Adjusted by Armelle 2024
"""

import os

#%%
rootdir= 'P:/FHML_MHeNs/Urology_Div3/Thijs de rijk/TRACK/SB01/Out/' #'/Volumes/Data/FHML/M7044/DATA/raw_data/'
#subj = ['TRACK-P003']
#subj= ['TRACK-P001', 'TRACK-P002', 'TRACK-P003', 'TRACK-P004', 'TRACK-P005', 'TRACK-P006', 'TRACK-P007', 'TRACK-P008', 'TRACK-P009', 'TRACK-P010', 'TRACK-P011', 'TRACK-P012', 'TRACK-P013', 'TRACK-P014', 'TRACK-P015', 'TRACK-P016', 'TRACK-P017', 'TRACK-P018', 'TRACK-P019', 'TRACK-P020', 'TRACK-P021', 'TRACK-P022', 'TRACK-P023', 'TRACK-P024', 'TRACK-P025', 'TRACK-P026', 'TRACK-P027', 'TRACK-P028', 'TRACK-P029', 'TRACK-P030', 'TRACK-P031', 'TRACK-P032', 'TRACK-P033', 'TRACK-P034', 'TRACK-P035', 'TRACK-P036', 'TRACK-P037', 'TRACK-P038', 'TRACK-P039', 'TRACK-P040', 'TRACK-P041', 'TRACK-P042', 'TRACK-P043', 'TRACK-P044', 'TRACK-P045', 'TRACK-P046', 'TRACK-P047', 'TRACK-P048', 'TRACK-P049', 'TRACK-P050', 'TRACK-P051', 'TRACK-P052', 'TRACK-P053', 'TRACK-P054', 'TRACK-P055', 'TRACK-P056', 'TRACK-P057', 'TRACK-P058', 'TRACK-P059', 'TRACK-P060', 'TRACK-P061', 'TRACK-P062', 'TRACK-P063', 'TRACK-P064', 'TRACK-P065', 'TRACK-P066', 'TRACK-P067', 'TRACK-P068', 'TRACK-P069', 'TRACK-P070', 'TRACK-P071', 'TRACK-P072', 'TRACK-P073', 'TRACK-P074', 'TRACK-P075', 'TRACK-P076', 'TRACK-P077', 'TRACK-P078', 'TRACK-P079', 'TRACK-P080', 'TRACK-P081', 'TRACK-P082', 'TRACK-P083', 'TRACK-P084', 'TRACK-P085', 'TRACK-P086', 'TRACK-P088', 'TRACK-P089', 'TRACK-P090','TRACK-P091', 'TRACK-P092', 'TRACK-P093', 'TRACK-P094', 'TRACK-P095', 'TRACK-P096', 'TRACK-P097', 'TRACK-P098', 'TRACK-P099', 'TRACK-P100', 'TRACK-P101', 'TRACK-P102', 'TRACK-P103', 'TRACK-P104', 'TRACK-P105', 'TRACK-P106', 'TRACK-P107', 'TRACK-P108', 'TRACK-P109', 'TRACK-P110', 'TRACK-P111', 'TRACK-P112', 'TRACK-P113', 'TRACK-P114', 'TRACK-P115', 'TRACK-P116', 'TRACK-P117', 'TRACK-P118', 'TRACK-P119', 'TRACK-P120', 'TRACK-P121', 'TRACK-P122', 'TRACK-P123', 'TRACK-P124', 'TRACK-P125', 'TRACK-P126', 'TRACK-P127', 'TRACK-P128', 'TRACK-P129', 'TRACK-P130', 'TRACK-P131', 'TRACK-P132', 'TRACK-P133', 'TRACK-P134', 'TRACK-P135', 'TRACK-P136', 'TRACK-P137', 'TRACK-P138', 'TRACK-P139', 'TRACK-P140', 'TRACK-P141', 'TRACK-P142', 'TRACK-P143', 'TRACK-P144', 'TRACK-P145', 'TRACK-P146', 'TRACK-P147', 'TRACK-P148', 'TRACK-P149', 'TRACK-P150', 'TRACK-P151'] 
#subj = ['TRACK-P006', 'TRACK-P007']
#subj = ['TRACK-P002']
#subj= ['TRACK-P007', 'TRACK-P009', 'TRACK-P014', 'TRACK-P016', 'TRACK-P018', 'TRACK-P019']
#subj = ['TRACK-P022', 'TRACK-P023', 'TRACK-P024', 'TRACK-P025', 'TRACK-P026', 'TRACK-P028', 'TRACK-P031', 'TRACK-P033', 'TRACK-P034', 'TRACK-P038', 'TRACK-P039', 'TRACK-P041', 'TRACK-P043', 'TRACK-P045', 'TRACK-P046']
#subj = ['TRACK-P113', 'TRACK-P114', 'TRACK-P117', 'TRACK-P118', 'TRACK-P120', 'TRACK-P121', 'TRACK-P123', 'TRACK-P141', 'TRACK-P142', 'TRACK-P143', 'TRACK-P146', 'TRACK-P147', 'TRACK-P148', 'TRACK-P149', 'TRACK-P151'] 
#subj = ['TRACK-P038', 'TRACK-P039', 'TRACK-P041', 'TRACK-P042', 'TRACK-P043', 'TRACK-P045', 'TRACK-P046']
#subj = ['TRACK-P130', 'TRACK-P134', 'TRACK-P135', 'TRACK-P136', 'TRACK-P137', 'TRACK-P138', 'TRACK-P140', 'TRACK-P141', 'TRACK-P142', 'TRACK-P143', 'TRACK-P146', 'TRACK-P147', 'TRACK-P148', 'TRACK-P149', 'TRACK-P151'] 
#subj = ['TRACK-P025', 'TRACK-P026', 'TRACK-P028', 'TRACK-P031', 'TRACK-P033', 'TRACK-P034', 'TRACK-P038', 'TRACK-P039', 'TRACK-P041', 'TRACK-P043', 'TRACK-P045', 'TRACK-P046']
#subj = ['TRACK-P142', 'TRACK-P143', 'TRACK-P146', 'TRACK-P147', 'TRACK-P148', 'TRACK-P149']
#subj = ['TRACK-P006', 'TRACK-P009', 'TRACK-P010']
#subj = ['TRACK-P111', 'TRACK-P114', 'TRACK-P117', 'TRACK-P118', 'TRACK-P120', 'TRACK-P121']
subj = ['TRACK-P024', 'TRACK-P137', 'TRACK-P142', 'TRACK-P149']
rootOUT= 'P:/FHML_MHeNs/Urology_Div3/Thijs de rijk/TRACK/SB01/Out/'

rootF='ASIA1_001_fMRI_loc1'
rootFpp = 'ASIA1_001_fMRI_loc1_SCCTBL_3DMCTS_THPGLMF6c_undist.fmr'

rootV='ASIA1_001_MPRAGE_IIHC.vmr'
#rootVMNI='ASIA1_001_MPRAGE_IIHC_ACPC_MNI.vmr'
rootVMNI = 'ASIA1_001_anatomy_UNI_ISO_IIHC.vmr'
rootIA = 'ASIA1_001_fMRI_loc1_SCCTBL_3DMCTS_THPGLMF6c_undist-TO-ASIA1_001_anatomy_UNI_ISO_IIHC_IA.trf'
rootFA = 'ASIA1_001_fMRI_loc1_SCCTBL_3DMCTS_THPGLMF6c_undist-TO-ASIA1_001_anatomy_UNI_ISO_IIHC_BBR_FA.trf'
rootMNI = 'ASIA1_001_anatomy_UNI_ISO_IIHC_TO_MNI_a12_adjBBX.trf'

rootVMR = 'ASIA1_001_anatomy_UNI_ISO_IIHC.vmr'#fMRI_TRACK-P002_ana.vmr

vtcresolution = 1

fmr_vtccreation = True

for isubj in subj:
    
            
    if fmr_vtccreation:
        print('Starting vtc creation for subject ' + isubj + '...')    
        print('Files used:')
        

        dirname=rootdir+isubj+'/'
        
        infile_reg = rootdir + rootVMNI
        infile_reg = infile_reg.replace('ASIA1_001',isubj)
        infile_reg = infile_reg.replace('SB01', isubj)
        print(infile_reg)
        
        fmrname = rootdir + rootFpp
        fmrname = fmrname.replace('ASIA1_001',isubj)  
        fmrname = fmrname.replace('SB01', isubj)   
        print(fmrname)
        
        IAname = rootdir + rootIA
        IAname = IAname.replace('ASIA1_001',isubj)
        IAname = IAname.replace('SB01',isubj)
        print(IAname)
        
        FAname = rootdir + rootFA
        FAname = FAname.replace('ASIA1_001',isubj)
        FAname = FAname.replace('SB01',isubj)
        print(FAname)
        
        MNIname = rootdir + rootMNI
        MNIname = MNIname.replace('ASIA1_001',isubj)
        MNIname = MNIname.replace('SB01',isubj)
        print(MNIname)

        
        VTCname = fmrname
        VTCname = VTCname.replace('.fmr','_MNI.vtc')


        vmr_doc2 = bv.open(infile_reg)
        vmr_doc2.normalize_to_mni_space() 


        vtcpass = vmr_doc2.create_vtc_in_mni_space(fmrname, IAname, FAname, MNIname, VTCname, vtcresolution, 2, 100, 2)
        if vtcpass:
            print('VTC file succesfully created: ' + VTCname)
        else:
            print('VTC creation failed for ' + isubj + '!')
        
            
        

