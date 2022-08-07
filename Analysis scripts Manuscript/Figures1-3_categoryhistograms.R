## Analyzing Single Dye dataset
# Import packages
theme_set(
  theme_classic())
library(ggplot2)
library(tidyverse)

#Loading data
Folder = choose.dir(default = "", caption = "Select Figure 1-4 folder")
Imagefilename = paste(Folder,"\\Image.csv",sep="")
Oosporefilename = paste(Folder,"\\Oospores_BF.csv",sep="")
Imagefile=read.csv(Imagefilename)
Oosporefile=read.csv(Oosporefilename)

#Split up Datafile and split into dye and viable non viable
Imagefile <- separate(data = Imagefile, col = FileName_BF_raw, into=c('1','dye','3','4','5','viability','7'), sep = " ")
Imagefile$dye <- gsub("20uM", "TOTO-3", Imagefile$dye)
Imagefile['combinedname'] <- paste(Imagefile$dye,Imagefile$viability,sep='_')

Summary <- Imagefile
Summary[c('Count_Oospores_red','Count_Oospores_dual','Count_Oospores_green','Count_Oospores_unstained')]<-Summary[c('Count_Oospores_red','Count_Oospores_dual','Count_Oospores_green','Count_Oospores_unstained')]/Summary$Count_Oospores_BF*100
Summary <- pivot_longer(Summary,'Count_Oospores_BF':'Count_Oospores_unstained',names_to = "Stain",values_to = "Percentage_value")
Summary <- Summary %>% 
  group_by(combinedname,Stain) %>% 
  summarise(Percentage=mean(Percentage_value),std=sd(Percentage_value))
Summary <- subset(Summary, Stain != 'Count_Oospores_BF')
Summary$Stain <- as.factor(Summary$Stain)
levels(Summary$Stain) <- c("Both", "Green","Red","Unstained")    

# ## Alternative for MTT dataset
# 
# Summary <- Imagefile
# Summary[c('Count_Oospores_green','Count_Oospores_unstained')]<-Summary[c('Count_Oospores_green','Count_Oospores_unstained')]/Summary$Count_Oospores_BF*100
# Summary <- pivot_longer(Summary,c('Count_Oospores_green','Count_Oospores_unstained'),names_to = "Stain",values_to = "Percentage_value")
# Summary <- Summary %>% 
#   group_by(combinedname,Stain) %>% 
#   summarise(Percentage=mean(Percentage_value),std=sd(Percentage_value))
# Summary <- subset(Summary, Stain != 'Count_Oospores_BF')
# Summary$Stain <- as.factor(Summary$Stain)
# levels(Summary$Stain) <- c("Stained","Unstained")  

# Plotting function
plotfun <- function(x)
{
  folder = 'C:\\Users\\vinkjo\\OneDrive - Victoria University of Wellington - STAFF\\Desktop\\Machine learning oospores\\Trial'
  my_colours <- c("#fdae61","#abdda4","#d7191c","grey")
  # #MTT alternative
  # my_colours <- c("#abdda4","grey")
  mplot <- ggplot(x, aes(fill=Stain, y=Percentage,x=Stain)) + 
    geom_bar(position="dodge", stat="identity") + #facet_wrap(~dye,scales='free') +
    geom_errorbar( aes(x=Stain, ymin=ifelse(Percentage-std < 0, 0, Percentage-std), ymax=Percentage+std), width=0.3, colour="black", alpha=0.9, size=1.3) +
    ylab('Fraction of Oospores (%)') +
    xlab("Stain")+
    #labs(fill="") +
    scale_fill_manual(values=my_colours) +
    theme(legend.position="none",text = element_text(size = 24,face="bold"))+
    scale_y_continuous(limits = c(0, 107),breaks=c(0,50,100))
  filename <- paste(folder,'\\',x[1,'combinedname'],'.pdf',sep='')
  ggsave(filename,height=5,width=6.7)
  return(mplot)
}
# Run plotting function for every de,viability combination and save automatically
LData2 <- split(Summary,Summary$combinedname)
Lplots <- lapply(LData2,plotfun)

# Old
# Sum over the triplicates
#Summary <- Imagefile %>% 
#  group_by(combinedname) %>% 
#  summarise(Frequency_BF = sum(Count_Oospores_BF),Frequency_dual = sum(Count_Oospores_dual),Frequency_green = sum(Count_Oospores_green),Frequency_red = sum(Count_Oospores_red),Frequency_unstained = sum(Count_Oospores_unstained),sd_dual = 100*sd(Count_Oospores_dual/Count_Oospores_BF),sd_red = 100*sd(Count_Oospores_red/Count_Oospores_BF), sd_green = 100*sd(Count_Oospores_green/Count_Oospores_BF),sd_unstained = 100*sd(Count_Oospores_unstained/Count_Oospores_BF))
#Summary[c('Frequency_BF','Frequency_red','Frequency_dual','Frequency_green','Frequency_unstained')]<-Summary[c('Frequency_BF','Frequency_red','Frequency_dual','Frequency_green','Frequency_unstained')]/Summary$Frequency_BF*100

#Summary[c('Count_Oospores_red','Count_Oospores_dual','Count_Oospores_green','Count_Oospores_unstained')]<-Summary[c('Count_Oospores_red','Count_Oospores_dual','Count_Oospores_green','Count_Oospores_unstained')]/Summary$Count_Oospores_BF*100
#Summary <- Summary %>%
#  pivot_longer(Summary,'Count_Oospores_BF':'Count_Oospores_unstained',names_to = "Stain",values_to = "Percentage") %>%
#  summarise(Frequency_BF = sum(Count_Oospores_BF),Frequency_dual = sum(Count_Oospores_dual),Frequency_green = sum(Count_Oospores_green),Frequency_red = sum(Count_Oospores_red),Frequency_unstained = sum(Count_Oospores_unstained),sd_dual = 100*sd(Count_Oospores_dual/Count_Oospores_BF),sd_red = 100*sd(Count_Oospores_red/Count_Oospores_BF), sd_green = 100*sd(Count_Oospores_green/Count_Oospores_BF),sd_unstained = 100*sd(Count_Oospores_unstained/Count_Oospores_BF))
# Change dataformat and naming of stain channels
#Summary <- Imagefile %>%
#  pivot_longer(c(-combinedname, -ImageNumber), names_to = "type") %>% 
#  group_by(combinedname, type)%>%
#  summarise(mn = mean(value),
#            sd = sd(value))

