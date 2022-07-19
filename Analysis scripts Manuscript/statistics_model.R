## Only works with Image.csv from 
library(ggplot2)
library(tidyverse)

# import data
Folder = choose.dir(default = "", caption = "Select Figure 1-4 folder")
Imagefilename = paste(Folder,"\\Image.csv",sep="")
Oosporefilename = paste(Folder,"\\Oospores_BF.csv",sep="")
Imagefile=read.csv(Imagefilename)
Oosporefile=read.csv(Oosporefilename)

# Prepare data
Imagefile <- separate(data = Imagefile, col = FileName_BF_raw, into=c('1','dye','3','4','5','viability','7'), sep = " ")
Imagefile$dye <- gsub("20uM", "TOTO-3", Imagefile$dye)
Summary <- Imagefile
Summary[c('Count_Oospores_red','Count_Oospores_dual','Count_Oospores_green','Count_Oospores_unstained')]<-Summary[c('Count_Oospores_red','Count_Oospores_dual','Count_Oospores_green','Count_Oospores_unstained')]/Summary$Count_Oospores_BF
Summary$Red = Summary$Count_Oospores_red+Summary$Count_Oospores_dual
Summary$Green = Summary$Count_Oospores_green+Summary$Count_Oospores_dual
Summary$NotRed = Summary$Count_Oospores_BF-Summary$Red
Summary$NotGreen = Summary$Count_Oospores_BF-Summary$Green

# Select which dye you want to test (Default FDA)
SubSummary <- subset(Summary,dye=='FDA')
# Transform asin sqrt (select which colour)
x <- asin(sqrt(SubSummary[c(1,2,3),'Green']))
y <- asin(sqrt(SubSummary[c(4,5,6),'Green']))
# T test
t.test(x,y)


## Old statistics method
# #x <- SubSummary[c(1,2,3,4,5,6),c('Count_Oospores_dual','Count_Oospores_red','Count_Oospores_green','Count_Oospores_unstained')]
# 
# comp.test( x[c(1:6),], ina, R= 2, test = "james" )
# 
# Data.xtabs = xtabs(Count ~ Allele + Habitat + Location,
#                    data=Data)
# 
# Summary <- Imagefile
# Summary$Red = Summary$Count_Oospores_red+Summary$Count_Oospores_dual
# Summary$Green = Summary$Count_Oospores_green+Summary$Count_Oospores_dual
# Summary$NotRed = Summary$Count_Oospores_BF-Summary$Red
# Summary$NotGreen = Summary$Count_Oospores_BF-Summary$Green
# Summary <- pivot_longer(Summary,c('Green','NotGreen'),names_to = "Stain",values_to = "Percentage_value")
# SubSummary <- subset(Summary,dye=='SYTO9')
# SubSummary$Replicate = SubSummary$'7'
# SubSummary <- SubSummary %>% 
#   mutate(Replicate = str_replace(Replicate, "_.*", ""))
# SubSummary.xtabs = xtabs(Percentage_value ~ viability + Stain + Replicate,
#                    data=SubSummary)
# 
# mantelhaen.test(SubSummary.xtabs)
# woolf_test(SubSummary.xtabs)
# BreslowDayTest(SubSummary.xtabs)
# oddsratio(SubSummary.xtabs)
# 
# 
# ## Heat course data
# Subdata <- subset(data,X2==10)
# Subdata[c(5:8),'ImageNumber']=c(1:4)
# Subdata[c(1:4),'ImageNumber']=c(1:4)
# Subdata = Subdata[-9,]
# Summary <- Subdata
# Summary$Red = Summary$Count_Oospores_red+Summary$Count_Oospores_dual
# Summary$Green = Summary$Count_Oospores_green+Summary$Count_Oospores_dual
# Summary$NotRed = Summary$Count_Oospores_BF-Summary$Red
# Summary$NotGreen = Summary$Count_Oospores_BF-Summary$Green
# Summary <- pivot_longer(Summary,c('Green','NotGreen'),names_to = "Stain",values_to = "Percentage_value")
# Summary.xtabs = xtabs(Percentage_value ~ X1 + Stain + ImageNumber,data=Summary)
# mantelhaen.test(Summary.xtabs)
# woolf_test(Summary.xtabs)
# BreslowDayTest(Summary.xtabs)
# oddsratio(Summary.xtabs)

