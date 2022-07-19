# Import packages
library(tidyverse)
library(Rcolorbrewer)
library(reshape2)
theme_set(
  theme_classic())


#Import data (Change if location is different)
library(readr)
data_raw <- read_csv("C:\\Users\\vinkjo\\OneDrive - Victoria University of Wellington - STAFF\\Desktop\\Machine learning oospores\\58\\newtrial\\Image.csv")

#file processing
dataframe<-separate(data = data_raw, 
               col = FileName_BF_raw, 
               sep = " ", 
               into = c("X1", "X2","X3","X4","X5"))

# ANOVA statistics 
# dataframe$sample <- paste(dataframe$X1,dataframe$X4,dataframe$X5)
# dataframe[c('Count_Oospores_red','Count_Oospores_dual','Count_Oospores_green','Count_Oospores_unstained')]<-dataframe[c('Count_Oospores_red','Count_Oospores_dual','Count_Oospores_green','Count_Oospores_unstained')]/dataframe$Count_Oospores_BF
# dataframe$Red = dataframe$Count_Oospores_red+dataframe$Count_Oospores_dual
# dataframe$Green = dataframe$Count_Oospores_green+dataframe$Count_Oospores_dual
# dataframe$NotRed = dataframe$Count_Oospores_BF-dataframe$Red
# dataframe$NotGreen = dataframe$Count_Oospores_BF-dataframe$Green
# dataframe$Green = asin(sqrt(dataframe$Green))
# ezModel <- ezANOVA(data=dataframe,dv=.(Green),wid=.(sample),between=.(X1),within(X2),detailed = TRUE)


data_wide<-data %>% 
  select(X1,X2, Count_Oospores_green, Count_Oospores_dual, Count_Oospores_red, Count_Oospores_unstained, Count_Oospores_BF)

names(data_wide)<-c("Isolate","Time",
                    "Viable", "Damaged","Non-viable","Unstained",
                    "Total")

data_wide$Viable<- (data_wide$Viable/data_wide$Total)
data_wide$Damaged<- (data_wide$Damaged/data_wide$Total)
data_wide$'Non-viable'<- (data_wide$'Non-viable'/data_wide$Total)
data_wide$Unstained<- (data_wide$Unstained/data_wide$Total)

#converting data from wide to long format
data_long <- pivot_longer(data_wide,
                          'Viable':'Unstained',
                          names_to = "Viability",
                          values_to = "Percentage")

#
data_long$Isolate<- gsub("3770", "NZFS 3770", data_long$Isolate)
data_long$Isolate<- gsub("3772", "NZFS 3772", data_long$Isolate)

#calculating errors
melted <- melt(data_long, id.vars=c("Isolate", "Time", "Viability", "Percentage"))
grouped <- group_by(melted, Viability, Isolate, Time)
Sum.data <- summarise(grouped, mean=mean(Percentage), sd=sd(Percentage))

#Extra code for bar graph
Sum.data$Time <- factor(Sum.data$Time, levels = c("0", "10", "30", "60", "120", "240", "1440"))
Sum.data$Viability <- factor(Sum.data$Viability, levels = c("Viable", "Damaged", "Non-viable", "Unstained"))
my_colours <- c("#abdda4","#fdae61","#d7191c","grey")
Isolate1 <- Sum.data %>% filter(Isolate == 'NZFS 3770')
Isolate2 <- Sum.data %>% filter(Isolate == 'NZFS 3772')

#Bar graph with errorbars
ggplot(Sum.data, aes(fill=Viability, y=Sum.data$mean, x=Time)) + 
  geom_bar(position="dodge", stat="identity") +
  facet_wrap(~Isolate) +
  geom_errorbar(aes(x=Time, ymin=mean-sd/sqrt(3), ymax=mean+sd/sqrt(3)), width=0.5, colour="black", alpha=0.5, size=0.5, position = position_dodge(0.9)) +
  ylab("Oospore Viability") +
  xlab("Time at 98 \u00B0C (min)") +
  labs(fill="") +
  scale_fill_manual(values=my_colours) +
  scale_y_continuous(limits = c(-0.07, 1.07), labels = scales::percent, breaks = c(0,0.5,1)) +
  #theme_bw() +
  theme(text = element_text(size = 22,face="bold")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust=1))
ggplot(Isolate1, aes(fill=Viability, y=Isolate1$mean, x=Time)) + 
  geom_bar(position="dodge", stat="identity") +
  facet_wrap(~Isolate) +
  geom_errorbar(aes(x=Time, ymin=mean-sd, ymax=mean+sd), width=0.5, colour="black", alpha=0.5, size=0.5, position = position_dodge(0.9)) +
  ylab("Oospore Viability") +
  xlab("Time at 98 \u00B0C (min)") +
  labs(fill="") +
  scale_fill_manual(values=my_colours) +
  scale_y_continuous(limits = c(-0.07, 1.07), labels = scales::percent, breaks = c(0,0.5,1)) +
  #theme_bw() +
  theme(text = element_text(size = 22,face="bold")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust=1))
ggplot(Isolate2, aes(fill=Viability, y=Isolate2$mean, x=Time)) + 
  geom_bar(position="dodge", stat="identity") +
  facet_wrap(~Isolate) +
  geom_errorbar(aes(x=Time, ymin=mean-sd, ymax=mean+sd), width=0.5, colour="black", alpha=0.5, size=0.5, position = position_dodge(0.9)) +
  ylab("Oospore Viability") +
  xlab("Time at 98 \u00B0C (min)") +
  labs(fill="") +
  scale_fill_manual(values=my_colours) +
  scale_y_continuous(limits = c(-0.07, 1.07), labels = scales::percent, breaks = c(0,0.5,1)) +
  #theme_bw() +
  theme(text = element_text(size = 22,face="bold")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, vjust=1))
