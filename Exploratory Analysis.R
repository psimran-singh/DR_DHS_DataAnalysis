#Run data management first
library(ggplot2)
library(dplyr)
library(gtsummary)

#Summary of all variables
summary(data2a)

#Looking at full dataset, how is age distributed?
agechart <- ggplot(data2a, aes(x=age)) + geom_density(fill="lightblue")
agechart

#Looking at full dataset, how are regions distributed?
regionchart <- ggplot(data2a, aes(x=region)) + geom_bar(stat="count")
regionchart

#So, region 0 represents largest share of dataset
#What is the rural/urban split in the regions?
regionchart2 <- ggplot(data2a, aes(fill=urban_rural, x=region)) + 
                geom_bar(position="dodge", stat="count")
regionchart2


#The regions clearly have very different urban/rural splits
#What is the urban/rural split in the overall dataset?
urbanruralchart <- ggplot(data2a, aes(x=urban_rural)) +
                   geom_bar(stat="count")
urbanruralchart

#Let's look at actual numbers and pcts instead
# 2-Way Frequency Table
attach(data2a)
mytable <- table(region,urban_rural)
mytable
prop.table(mytable, 1)
detach(data2a)

#For now I'll keep the dataset representative of all regions
#Let's look at the subset of the data we will sample from instead
summary(data4)
summarydata4 <- data4[,c(2:30)]
summarydata4 %>% tbl_summary

summarysample1 <- sample1[,c(2:30)]
summarysample1 %>% tbl_summary

ageplot <- ggplot(data4, aes(y=age)) + 
  geom_boxplot(alpha=0.3) +
  theme(legend.position="none")
ageplot

educationplot <- ggplot(data4, aes(y=years_of_education)) + 
  geom_boxplot(alpha=0.3) +
  theme(legend.position="none")
educationplot

agechart <- ggplot(data4, aes(x=age))+
  geom_bar(stat="count")+
  scale_x_continuous(breaks = data4$age) +
  theme_minimal() +
  ggtitle("Distribution of Age")+
  theme(plot.title = element_text(hjust = 0.5))
agechart

educationchart <- ggplot(data4, aes(x=years_of_education))+
  geom_bar(stat="count")+
  scale_x_continuous(breaks = data4$years_of_education) +
  theme_minimal() +
  ggtitle("Distribution of Years of Education")+
  theme(plot.title = element_text(hjust = 0.5))
educationchart
