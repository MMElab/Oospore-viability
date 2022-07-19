# -*- coding: utf-8 -*-
"""
Created on Thu Apr 14 18:06:19 2022

@author: vinkjo
"""

# Import functions
import cv2
import numpy as np
import pandas as pd
import os
from pathlib import Path
import skimage.draw
import matplotlib.pyplot as plt
import h5py
import tifffile
import shutil

# Folder to correct (folder should contain subfolders for each day of the experiment) 
multifolder = 'C:\\Users\\vinkjo\\OneDrive - Victoria University of Wellington - STAFF\\Desktop\\14_04_Oospore viability'
multifolder = 'C:\\Users\\vinkjo\\OneDrive - Victoria University of Wellington - STAFF\\Desktop\\Doitagain'
multifolderpath = Path(multifolder)
for folderpath in multifolderpath.glob("*FDA*"):
    folder = str(folderpath)+'\\'
    if not os.path.isdir(folder+'processedfolder'):
        os.mkdir(folder+'processedfolder')
    for filein in folderpath.glob("*BF*"):
        number=str(filein).split('_')[-1][:-4]
        condition = str(folder).split('\\')[-2]
        newfilename = folder + 'processedfolder\\' + '3770_'+ condition + '_' + number + '_'
        #newfilename = 'C:\\Users\\vinkjo\\140422_Oosporeviability\\' + '3770_'+ condition + '_' + number + '_'
        newfilename_bf = newfilename + 'BF.tif'
        FITCfilein = folder + 'FOV_'+number+'_C0001.tif'
        newfilename_FITC = newfilename + 'FITC.tif'
        TRedfilein = folder + 'FOV_'+number+'_C0002.tif'
        newfilename_TRed = newfilename + 'T_Red.tif'        
        bf = tifffile.imread(filein)
        bf = np.sum(bf,axis=2)
        shutil.copyfile(Path(FITCfilein), Path(newfilename_FITC))
        shutil.copyfile(TRedfilein, newfilename_TRed)
        # fitc = tifffile.imread(FITCfilein)
        # tred = tifffile.imread(TRedfilein)
        tifffile.imsave(newfilename_bf,data=bf)
        # tifffile.imsave(newfilename_FITC,data=fitc)
        # tifffile.imsave(newfilename_TRed,data=tred)
        
        