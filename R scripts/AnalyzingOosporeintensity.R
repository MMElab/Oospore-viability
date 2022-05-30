#Analysing intensity distributions of individual oospores
#Get ggplot
library(ggplot2)
library(tidyverse)
theme_set(
  theme_classic() + 
    theme(legend.position = "top")
)

Analysistype = 'UpperQuartile' # Pick either 'Mean','Integrated' or 'UpperQuartile'
Intensityname = paste("Intensity_", Analysistype,"Intensity_", sep="")
RedChannel = paste(Intensityname,"T_Red", sep="")
GreenChannel = paste(Intensityname,"FITC", sep="")
## Analyzing Single Dye dataset

#Loading data
Folder = 'C:\\Users\\vinkjo\\OneDrive - Victoria University of Wellington - STAFF\\Desktop\\Machine learning oospores\\74' #Set path to folder containing Image and Oospore BF file
Imagefilename = paste(Folder,"\\Image.csv",sep="")
Oosporefilename = paste(Folder,"\\Oospores_BF.csv",sep="")
Imagefile=read.csv(Imagefilename)
Oosporefile=read.csv(Oosporefilename)


# Add filenames to oosporefile
Imagefile=Imagefile[,c('FileName_BF_raw','ImageNumber')]
Mergedfile<-merge(Imagefile,Oosporefile,by.x='ImageNumber',by.y='ImageNumber')

# Separate filenames into columns and make long format data frame
Mergedfile <- separate(data = Mergedfile, col = FileName_BF_raw, into=c('1','dye','3','4','5','viability','7'), sep = " ")
Mergedfile$dye <- ifelse(Mergedfile$dye == '20uM',  gsub("20uM", "TOTO-3 iodide", Mergedfile$dye), Mergedfile$dye)

livecells <- Mergedfile %>% filter(viability == 'Viable')
deadcells <- Mergedfile %>% filter(viability == 'Non-viable')

## Scatter plots (can also do log scale if you remove comment)
ggplot(livecells, aes_string(x=GreenChannel, y=RedChannel)) +
  geom_point() +
  facet_wrap("dye")#+ scale_x_log10()+scale_y_log10()

ggplot(deadcells, aes_string(x=GreenChannel, y=RedChannel)) +
  geom_point() +
  facet_wrap("dye")#+ scale_x_log10()+scale_y_log10()

Mergedfile <- gather(Mergedfile, color, intensity, GreenChannel:RedChannel, factor_key=TRUE)
Mergedfile['intensity']=Mergedfile['intensity']*4

# Split dataset up in viable and non-viable
livecells <- Mergedfile %>% filter(viability == 'Viable')
deadcells <- Mergedfile %>% filter(viability == 'Non-viable')

## Can set minimum value if you want to use logarithmic scale and it contains negative values 
#livecells['intensity'][livecells['intensity'] < 1e-1] <- 1e-1
#deadcells['intensity'][deadcells['intensity']< 1e-1] <- 1e-1 

# Plot histograms (can also do log scale if you remove comment)
ggplot(livecells, aes(x=intensity, fill=color)) +
  geom_histogram(aes(y=..density..),colour = "black",bins=30,position='identity',alpha=0.4) +
  scale_fill_manual(values=c("green", "red")) +
  facet_wrap("dye")#+ scale_y_continuous(limits = c(0,10))+scale_x_log10(limits= c(0.09, 1))
ggplot(deadcells, aes(x=intensity, fill=color)) + 
  geom_histogram(aes(y=..density..),colour = "black",bins=30,position='identity',alpha=0.4) +
  scale_fill_manual(values=c("green", "red")) +
  facet_wrap("dye")#+ scale_y_continuous(limits = c(0,10))+scale_x_log10(limits= c(0.09, 1))

## Analyzing Heat Course

#Loading data
Folder = 'C:\\Users\\vinkjo\\OneDrive - Victoria University of Wellington - STAFF\\Desktop\\Machine learning oospores\\MJF58 Outputs 5.0_JV'
Imagefilename = paste(Folder,"\\Image.csv",sep="")
Oosporefilename = paste(Folder,"\\Oospores_BF.csv",sep="")
Imagefile=read.csv(Imagefilename)
Oosporefile=read.csv(Oosporefilename)

# Add filenames to oosporefile
Imagefile=Imagefile[,c('FileName_BF_raw','ImageNumber')]
Mergedfile<-merge(Imagefile,Oosporefile,by.x='ImageNumber',by.y='ImageNumber')

# Replace 4x filename with new number
Mergedfile$FileName_BF_raw <- gsub('1 4x', '3', Mergedfile$FileName_BF_raw)
Mergedfile$FileName_BF_raw <- gsub('2 4x', '4', Mergedfile$FileName_BF_raw)

# Order based on time
Mergedfile$time <-as.numeric(Mergedfile$time) # Convert to numeric for right ordering of time categories
Mergedfile <- Mergedfile[order(Mergedfile$time),]

# Separate filenames into columns and make long format data frame
Mergedfile <- separate(data = Mergedfile, col = FileName_BF_raw, into=c('strain','time','3','replicate','5'), sep = " ")
Mergedfile_long <- gather(Mergedfile, color, intensity, GreenChannel:RedChannel, factor_key=TRUE)
Mergedfile_long['intensity'][Mergedfile_long['intensity'] < 1e-5] <- 1e-5 

#Split dataset up by strain
strain_3770 <- Mergedfile_long %>% filter(strain == '3770')
strain_3772 <- Mergedfile_long %>% filter(strain == '3772')
strain_3770_wide <- Mergedfile %>% filter(strain == '3770')
strain_3772_wide <- Mergedfile %>% filter(strain == '3772')

# Plot histograms
ggplot(strain_3770, aes(x=intensity, fill=color)) +
  geom_histogram(colour = "black",bins=50,position='identity',alpha=0.4) +
  scale_fill_manual(values=c("green", "red")) +
  facet_wrap("time")#+ scale_x_log10()
ggplot(strain_3772, aes(x=intensity, fill=color)) +
  geom_histogram(colour = "black",bins=50,position='identity',alpha=0.4) +
  scale_fill_manual(values=c("green", "red")) +
  facet_wrap("time")#+ scale_x_log10()
# Plot scatter plots
ggplot(strain_3770_wide, aes_string(x=GreenChannel, y=RedChannel)) +
  geom_point() +
  facet_wrap("time")#+ scale_x_log10()+scale_y_log10()
ggplot(strain_3772_wide, aes_string(x=GreenChannel, y=RedChannel)) +
  geom_point() +
  facet_wrap("time")#+ scale_x_log10()+scale_y_log10()

# #Loading data
# Folder = 'C:\\Users\\vinkjo\\Downloads\\Mike Jochem datafiles\\Mike Jochem datafiles\\MJF58 4.0'
# Imagefilename = paste(Folder,"\\Image.csv",sep="")
# Oosporefilename = paste(Folder,"\\Oospores_BF.csv",sep="")
# Imagefile=read.csv(Imagefilename)
# Oosporefile=read.csv(Oosporefilename)
# 
# # Add filenames to oosporefile
# Imagefile=Imagefile[,c('FileName_BF_raw','ImageNumber')]
# Mergedfile<-merge(Imagefile,Oosporefile,by.x='ImageNumber',by.y='ImageNumber')
# Redcounted <- Mergedfile %>% filter(Children_Oospores_red_Count > 0)
# ggplot(Redcounted, aes_string(x="AreaShape_Area",y=RedChannel)) +
#   geom_point()
# Greencounted <- Mergedfile %>% filter(Children_Oospores_green_Count == 0)
# ggplot(Greencounted, aes_string(x=RedChannel,y=GreenChannel)) +
#   geom_point() + scale_x_log10() + scale_y_log10()

# ## Old plotting
# ggplot(Mergedfile, aes(x=RedChannel)) +
#   geom_histogram(fill = "red", colour = "black",bins=50)
# ggplot(Mergedfile, aes(x=GreenChannel)) +
#   geom_histogram(fill = "green", colour = "black",bins=50)
# ggplot(Mergedfile, aes(x=GreenChannel,y=RedChannel)) +
#   geom_point()
# ggplot(Mergedfile, aes(x=Intensity_MeanIntensity_FITC,y=Intensity_MeanIntensity_T_Red)) +
#   geom_point()
# ggplot(Mergedfile, aes(x=RedChannel,y=Intensity_MeanIntensity_T_Red)) +
#   geom_point()
# livecells <- Mergedfile %>% filter(RedChannel < 2)
# ggplot(livecells, aes(x=GreenChannel)) +
#   geom_histogram(fill = "green", colour = "black",bins=50)
# deadcells <- Mergedfile %>% filter(GreenChannel < 4)
# ggplot(deadcells, aes(x=RedChannel)) +
#   geom_histogram(fill = "red", colour = "black",bins=50)
# thresholdRed = 0.04
# thresholdGreen = 0.03
# Mergedfile['stain']=NaN
# Splitdye<-split(Mergedfile, Mergedfile$dye)
# Mergedfile['stain'][Mergedfile[GreenChannel]>thresholdGreen&Mergedfile[RedChannel]>thresholdRed] <- 'Double Stained'
# Mergedfile['stain'][Mergedfile[GreenChannel]>thresholdGreen&Mergedfile[RedChannel]<thresholdRed] <- 'SingleGreen'
# Mergedfile['stain'][Mergedfile[GreenChannel]<thresholdGreen&Mergedfile[RedChannel]>thresholdRed] <- 'SingleRed'
# Mergedfile['stain'][Mergedfile[GreenChannel]<thresholdGreen&Mergedfile[RedChannel]<thresholdRed] <- 'Unstained'
# for (dyefile in Splitdye)
# {
#   dyecolour = unique(dyefile['dye'])
#   print(as.character(dyecolour))
#   total <- nrow(dyefile)
#   stainnames <- c('Double Stained','SingleGreen','SingleRed','Unstained')
#   doublestained <- sum(dyefile[GreenChannel]>thresholdGreen & dyefile[RedChannel]>thresholdRed)/total
#   singlegreen <- sum(dyefile[GreenChannel]>thresholdGreen & dyefile[RedChannel]<thresholdRed)/total
#   singlered <- sum(dyefile[GreenChannel]<thresholdGreen & dyefile[RedChannel]>thresholdRed)/total
#   unstained <- sum(dyefile[GreenChannel]<thresholdGreen & dyefile[RedChannel]<thresholdRed)/total
#   stainvalues <- c(doublestained,singlegreen,singlered,unstained)
#   Sumdata = data.frame(stainnames,stainvalues)
#   print(ggplot(Sumdata, aes(y=stainvalues,x=stainnames)) + 
#     geom_bar(position="dodge", stat="identity")  +
#            ggtitle(as.character(dyecolour)))
#       #facet_wrap(~Isolate) +
#       
#           # ylab("Oospore Viability") +
#            #xlab("Time at 98 \u00B0C (min)") +
#            #labs(fill="") +
#            #scale_fill_manual(values=my_colours) +
#            #scale_y_continuous(limits = c(-0.07, 1.07), labels = scales::percent, breaks = c(0,0.5,1)) +
#            #() +
#            #theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust=1, size = rel(1)))
# }