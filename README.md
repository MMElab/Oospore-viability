# Oospore-viability
Scripts that enable analysis of oospore viability assay (live/dead staining)

### Software Requirements
To run the entire pipeline you are required to install three pieces of software:
- R (Recommended to install Rstudio)
- Ilastik
- Cellprofiler

### Data format
The data format should consist of three tif images, one Brightfield (labeled BF), one Green (labeled FITC) and one Red (labeled T-Red) and should be contained within one folder. 

### Concepts
The idea of this pipeline is to use machine learning to identify single oospore regions within brightfield images and subsequently quantify the fluorescence in the red and green channel within those regions. We train two different ilastik classifiers one to identify oospore regions and one to identify edges of oospores, which allows us to separate oospores that are close together. The attached ilastik projects are trained on 4x microscopy images and therefore if you use any magnification or if your images differ widely from the images in the example dataset (Trial dataset) you need to retrain the classifiers using your own images. 

Subsequent running of the pipeline consists of three steps: (1) the data preparation step in which background correction and ilastik classification is automatically run (in R); (2) cell profiler, which extracts the information from the different channels based on the ilastik classifications; (3) . 

### Trial run pipeline
Attached is an example dataset which you can use to check if you can run all steps properly. To do so first run the R script Preparedataset.R. It will ask you to select the folder which contains your data (in our case Trial dataset). Subsequently it will ask you the location of your ilastik project files, the first one being Oospore_pixel and the second one being Oospore_edge. The program will now run for a couple of minutes to generate all the required images. 

