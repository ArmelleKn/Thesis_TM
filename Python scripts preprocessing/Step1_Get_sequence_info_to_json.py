#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr  8 10:06:09 2022


@author: Job & adjusted by Armelle
"""

import glob,json,os
import numpy as np
import subprocess
import sys
import glob
import json
import os

# Check if pydicom is installed
try:
    import pydicom
except ImportError:
    # If pydicom is not installed, install it
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pydicom"])
    # Attempt to import pydicom again after installation
    import pydicom


global loccount,runcount,PAcount

#%% 
#rootdir= 'C:/Users/armel/OneDrive/Documenten/TU_Delft_Master_II/TMjaar3/TRACK/Data/'   #'/Volumes/Data-1/FHML/M7044/DATA/raw_data/'
rootdir= 'Z:/FHML_MHeNs/Urology_Div3/Thijs de rijk/TRACK/'
#subj=['ASIA1_001','ASIA1_002','ASIA1_003','ASIA1_004','ASIA1_005','ASIA1_006','ASIA1_007','ASIA1_008','ASIA1_009','ASIA1_010',
      #'ASIA2_001','ASIA2_002','ASIA2_003','ASIA2_004','ASIA2_005','ASIA2_006','ASIA2_007','ASIA2_008','ASIA2_009','ASIA2_010','ASIA2_011','ASIA2_012']
#subj= ['TRACK-P011', 'TRACK-P012', 'TRACK-P013', 'TRACK-P014', 'TRACK-P015', 'TRACK-P016', 'TRACK-P017', 'TRACK-P018', 'TRACK-P019', 'TRACK-P020', 'TRACK-P021', 'TRACK-P022', 'TRACK-P023', 'TRACK-P024', 'TRACK-P025', 'TRACK-P026', 'TRACK-P027', 'TRACK-P028', 'TRACK-P029', 'TRACK-P030', 'TRACK-P031', 'TRACK-P032', 'TRACK-P033', 'TRACK-P034', 'TRACK-P035', 'TRACK-P036', 'TRACK-P037', 'TRACK-P038', 'TRACK-P039', 'TRACK-P040', 'TRACK-P041', 'TRACK-P042', 'TRACK-P043', 'TRACK-P044', 'TRACK-P045', 'TRACK-P046', 'TRACK-P047', 'TRACK-P048', 'TRACK-P049', 'TRACK-P050'] 
#subj= ['TRACK-P051', 'TRACK-P052', 'TRACK-P053', 'TRACK-P054', 'TRACK-P055', 'TRACK-P056', 'TRACK-P057', 'TRACK-P058', 'TRACK-P059', 'TRACK-P060', 'TRACK-P061', 'TRACK-P062', 'TRACK-P063', 'TRACK-P064', 'TRACK-P065', 'TRACK-P066', 'TRACK-P067', 'TRACK-P068', 'TRACK-P069', 'TRACK-P070', 'TRACK-P071', 'TRACK-P072', 'TRACK-P073', 'TRACK-P074', 'TRACK-P075', 'TRACK-P076', 'TRACK-P077', 'TRACK-P078', 'TRACK-P079', 'TRACK-P080', 'TRACK-P081', 'TRACK-P082', 'TRACK-P083', 'TRACK-P084', 'TRACK-P085', 'TRACK-P086', 'TRACK-P088', 'TRACK-P089', 'TRACK-P090','TRACK-P091', 'TRACK-P092', 'TRACK-P093', 'TRACK-P094', 'TRACK-P095', 'TRACK-P096', 'TRACK-P097', 'TRACK-P098', 'TRACK-P099', 'TRACK-P100', 'TRACK-P101', 'TRACK-P102', 'TRACK-P103', 'TRACK-P104', 'TRACK-P105', 'TRACK-P106', 'TRACK-P107', 'TRACK-P108', 'TRACK-P109', 'TRACK-P110', 'TRACK-P111', 'TRACK-P112', 'TRACK-P113', 'TRACK-P114', 'TRACK-P115', 'TRACK-P116', 'TRACK-P117', 'TRACK-P118', 'TRACK-P119', 'TRACK-P120', 'TRACK-P121', 'TRACK-P122', 'TRACK-P123', 'TRACK-P124', 'TRACK-P125', 'TRACK-P126', 'TRACK-P127', 'TRACK-P128', 'TRACK-P129', 'TRACK-P130', 'TRACK-P131', 'TRACK-P132', 'TRACK-P133', 'TRACK-P134', 'TRACK-P135', 'TRACK-P136', 'TRACK-P137', 'TRACK-P138', 'TRACK-P139', 'TRACK-P140', 'TRACK-P141', 'TRACK-P142', 'TRACK-P143', 'TRACK-P144', 'TRACK-P145', 'TRACK-P146', 'TRACK-P147', 'TRACK-P148', 'TRACK-P149', 'TRACK-P150', 'TRACK-P151'] #['SB26','SB27','SB29','SB30','SB31','SB32','SB33','SB34','SB35']] #['SB26','SB27','SB29','SB30','SB31','SB32','SB33','SB34','SB35']
subj = ['TRACK-P002']
#subj = ['TRACK-P099', 'TRACK-P100', 'TRACK-P101', 'TRACK-P102', 'TRACK-P103', 'TRACK-P104', 'TRACK-P105', 'TRACK-P106', 'TRACK-P107', 'TRACK-P108', 'TRACK-P109', 'TRACK-P110', 'TRACK-P111', 'TRACK-P112', 'TRACK-P113', 'TRACK-P114', 'TRACK-P115', 'TRACK-P116', 'TRACK-P117', 'TRACK-P118', 'TRACK-P119', 'TRACK-P120', 'TRACK-P121', 'TRACK-P122', 'TRACK-P123', 'TRACK-P124', 'TRACK-P125', 'TRACK-P126', 'TRACK-P127', 'TRACK-P128', 'TRACK-P129', 'TRACK-P130', 'TRACK-P131', 'TRACK-P132', 'TRACK-P133', 'TRACK-P134', 'TRACK-P135', 'TRACK-P136', 'TRACK-P137', 'TRACK-P138', 'TRACK-P139', 'TRACK-P140', 'TRACK-P141', 'TRACK-P142', 'TRACK-P143', 'TRACK-P144', 'TRACK-P145', 'TRACK-P146', 'TRACK-P147', 'TRACK-P148', 'TRACK-P149', 'TRACK-P150', 'TRACK-P151'] 
#%% get sequenc#['SB26','SB27','SB29','SB30','SB31','SB32','SB33','SB34','SB35']
#%% get sequence info
def get_input_dir():
    infiles=sorted(glob.glob(dirname+'*.IMA'))
    xx=infiles[0].split('.',3)
    name_exp='.'.join(xx[0:-1])
    
    if any(name_exp not in s for s in infiles):
        print('Data from multiple scan sessions within this folder. Only the data with the following name will be considered:\n %s' %(name_exp.replace(dirname, '')))
        #remove data with different name
        infiles=[s for s in infiles if name_exp in s]
        
    #%% get dicom numbers
    zz=[int(s.split('.',5)[3]) for s in infiles]
    sequences=np.unique(zz,return_index=True,return_counts=True)
    
    #%% get protocol names
    dict1={}
    prts=[]
    for ii,iseq in enumerate(sequences[0]):
        idcm=pydicom.dcmread(infiles[sequences[1][ii]])
        iprt=idcm.SeriesDescription
        dict1['protocol'+str(ii)]={'name':iprt,'dicom number':iseq,'number of volumes':sequences[2][ii],'first volume':infiles[sequences[1][ii]]}
        print('DICOM number: %d\t%s (%d)' %(iseq,iprt,sequences[2][ii]))
        prts.append(iprt)
            
    dict1['protocols']=prts
    
    return dict1

def loop_dict(dict1,iprt):
    # ff=[key for key, value in dict1.items() if type(value) is dict if iprt in list(value.values())]
    
    # if len(ff)==1:
    #     ff=''.join(ff)
    # return ff
    ff = ''
    for key, value in dict1.items():
        if type(value) is dict:
            if iprt in value['name']:
                ff = key
                break
                
    return ff
                    


#%% start loop
for isubj in subj:
    
    dirname=rootdir+isubj+'/'
    
    print(isubj)
    dict1=get_input_dir()
    
    datatypes=['anatomy_UNI','fMRI_loc','fMRI_run','fMRI_PA']
    loccount = 1
    runcount = 1
    PAcount = 1
    dict2={}
    
    
    for thisprot in dict1:
        if type(dict1[thisprot]) is dict:
            
            if 'mbep2d_iPAT3_MB2_1pt25' in dict1[thisprot]['name']:
                if dict1[thisprot]['number of volumes'] == 5: # PA
                    idata='fMRI_PA' + str(PAcount)
                    print(idata + ' (' + str(dict1[thisprot]['number of volumes'].item()) + ')')
                    dict2[idata]={'run_nr':PAcount,'first volume':dict1[thisprot]['first volume'],'number of volumes':dict1[thisprot]['number of volumes'].item(),'protocol':None,'dicom number': dict1[thisprot]['dicom number'].item(),'BV flag':True,'options':None}
                    
                    xdcm=pydicom.dcmread(dict1[thisprot]['first volume'])
                    dict2[idata]['matrix size']=xdcm.AcquisitionMatrix[0]
                    dict2[idata]['number of slices']=xdcm[0x0019, 0x100a].value
                    dict2[idata]['mosaic size']=xdcm.Rows
                    
                    PAcount = PAcount + 1
                elif dict1[thisprot]['number of volumes'] == 280: # LOC
                
                    idata='fMRI_loc' + str(loccount)  
                    print(idata + ' (' + str(dict1[thisprot]['number of volumes'].item()) + ')')
                    dict2[idata]={'run_nr':loccount,'first volume':dict1[thisprot]['first volume'],'number of volumes':dict1[thisprot]['number of volumes'].item(),'protocol':None,'dicom number': dict1[thisprot]['dicom number'].item(),'BV flag':True,'options':None}  
                    
                    xdcm=pydicom.dcmread(dict1[thisprot]['first volume'])
                    dict2[idata]['matrix size']=xdcm.AcquisitionMatrix[0]
                    dict2[idata]['number of slices']=xdcm[0x0019, 0x100a].value
                    dict2[idata]['mosaic size']=xdcm.Rows
                    
                    loccount = loccount + 1
                else:
                        print('Protocol ' + dict1[thisprot]['name'] + ' seems to be incomplete (' + str(dict1[thisprot]['number of volumes']) + ' volumes).')
            elif 'UNI_Images' in dict1[thisprot]['name']:    
                idata='anatomy_UNI'
                print(idata + ' (' + str(dict1[thisprot]['number of volumes'].item()) + ')')
                xdcm=pydicom.dcmread(dict1[thisprot]['first volume'])
                dict2[idata]={'run_nr':1,'first volume':dict1[thisprot]['first volume'],'number of volumes':dict1[thisprot]['number of volumes'].item(),'protocol':None,'dicom number': dict1[thisprot]['dicom number'].item(),'Rows':xdcm.Rows,'Columns':xdcm.Columns,'BV flag':True,'options':None}
            elif 'UNI_' in dict1[thisprot]['name']:  
                idata='anatomy_UNI'
                print(idata + ' (' + str(dict1[thisprot]['number of volumes'].item()) + ')')
                xdcm=pydicom.dcmread(dict1[thisprot]['first volume'])
                dict2[idata]={'run_nr':1,'first volume':dict1[thisprot]['first volume'],'number of volumes':dict1[thisprot]['number of volumes'].item(),'protocol':None,'dicom number': dict1[thisprot]['dicom number'].item(),'Rows':xdcm.Rows,'Columns':xdcm.Columns,'BV flag':True,'options':None}
    
    
    dictdump = json.dumps(dict2, indent=4)
    print(dict2)
    file1=open(dirname+isubj+'_sequence_info.json', 'w')
    file1.write(dictdump)
    file1.close()

    print()
    


