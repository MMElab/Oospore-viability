library(ggplot2)
library(dplyr)
library(data.table)
library(tidyverse)
theme_set(
  theme_classic())
## Loading data
Folder = choose.dir(default = "", caption = "Select Figure 6 folder")
Imagefilename = paste(Folder,"\\Image.csv",sep="")
Oosporefilename = paste(Folder,"\\Oospores_BF.csv",sep="")
Imagefile=read.csv(Imagefilename)
Oosporefile=read.csv(Oosporefilename)

## Calculate percentage of oospores are green vs green+red
Imagefile <- separate(data = Imagefile, col = FileName_BF_raw, into=c('strain','percentage','restofname'), sep = " ")
Imagefile['PercentageOospores'] <- Imagefile['Count_Oospores_green']/(Imagefile['Count_Oospores_green']+Imagefile['Count_Oospores_red'])
Imagefile['PercentageOospores'] <- Imagefile['PercentageOospores']*100

## Only use strain 3770
Imagefile <- Imagefile %>% filter(strain == '3770')
## Convert percentage column into number
Imagefile$percentage<-gsub("%","",as.character(Imagefile$percentage))
Imagefile$percentage <- as.numeric(Imagefile$percentage)
## Make data table to calculate mean and standard error of the mean
DT <- data.table(Imagefile[c('percentage','PercentageOospores')])
MeanandStd <- DT[, sapply(.SD, function(x) list(mean=mean(x), sd=sd(x)/sqrt(3))), by=percentage]
# Do regression
Regression <- lm(PercentageOospores~percentage, data=Imagefile)
## Add R2
lb1 <- paste("R^2 == ", format(summary(Regression)$r.squared,digits=3))
## Plot
ggplot(MeanandStd, aes(x=percentage, y=V1))+
  geom_point(size = 3,colour="black")+
  theme(text = element_text(size = 22,face="bold"))  +
  geom_abline(intercept = Regression$coefficients['(Intercept)'], slope = Regression$coefficients['percentage'],color="grey",size =1)+
  geom_errorbar(aes(ymin=V1-V2, ymax=V1+V2), width=.5,
                position=position_dodge(0.05),size =0.5)+
  xlab('Untreated oospores (%)')+
  ylab('Measured viable oospores (%)')+ 
  geom_text(aes(90, 5), label = lb1,parse=TRUE,size=8)
