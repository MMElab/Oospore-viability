## Script is made  to initialize the 
## Data requirements:
## - In one folder you have the brightfield, GFP (FITC) and RFP (T_Red) files (.tif)
## - Ilastik is installed in the following location '"C:\\Program Files\\ilastik-1.3.3post3\\ilastik.exe"' (if not change path name below)
## You will be asked the location of the folder that you want to analyze and the location of the two ilastik projects (normal and edge)

# Install packages
if (require("tiff") == False) {
  install.packages('tiff')}
library('tiff')

## Prepare files for analysis
folder = choose.dir(default = "", caption = "Select folder")
project = choose.files(default = "", caption = "Select Ilastik Project")
edgeproject = choose.files(default = "", caption = "Select Edge Project")
files <- list.files(path=folder, pattern="*BF*", full.names=TRUE, recursive=FALSE)

lapply(files, function(x) { 
a = readTIFF(x)
if (!(is.na(dim(a)[3]))){
  a <- rowSums(a, dims = 2)
}
writeTIFF(a,bits.per.sample=16,paste(substr(x,1,nchar(x)-3),'converted.tif',sep=""))
})

FITCfiles <- list.files(path=folder, pattern="*FITC*", full.names=TRUE, recursive=FALSE)
T_Redfiles <- list.files(path=folder, pattern="*Red*", full.names=TRUE, recursive=FALSE)
fluorescencefiles = append(FITCfiles,T_Redfiles)

lapply(fluorescencefiles, function(x) {
  a = readTIFF(x)
  background = quantile(a,0.7)
  a = a-background
  a[a<0]=0
  writeTIFF(a,bits.per.sample=16,paste(substr(x,1,nchar(x)-4),'_backgroundsubtracted.tif',sep=""))
})

## Run ilastik on entire folder
convertedfiles <- list.files(path=folder, pattern="*converted.tif", full.names=TRUE, recursive=FALSE)
lapply(convertedfiles, function(x) {
  system(paste('"C:\\Program Files\\ilastik-1.3.3post3\\ilastik.exe"',
              " --headless",
              " --project=",
              shQuote(edgeproject),
              " --raw_data=",
              shQuote(x),
              " --export_source=Probabilities",sep=""),intern=TRUE)
})
lapply(convertedfiles, function(x) {
  system(paste('"C:\\Program Files\\ilastik-1.3.3post3\\ilastik.exe"',
               " --headless",
               " --project=",
               shQuote(project),
               " --raw_data=",
               shQuote(x),
               " --export_source=Probabilities",sep=""),intern=TRUE)
})