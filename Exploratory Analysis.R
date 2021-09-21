#Run data management first
library(ggplot2)
library(psych)

#Looking at full dataset, how are regions distributed?
regionchart <- ggplot(data2, aes(x=region)) + geom_bar(stat="count")
regionchart

#So, region 0 represents largest share of dataset
#What is the rural/urban split in the regions?
regionchart2 <- ggplot(data2, aes(fill=urban_rural, x=region)) + 
                geom_bar(position="dodge", stat="count")
regionchart2


#The regions clearly have very different urban/rural splits
#What is the urban/rural split in the overall dataset?
urbanruralchart <- ggplot(data2, aes(x=urban_rural)) +
                   geom_bar(stat="count")
urbanruralchart

#Let's look at actual numbers and pcts instead
# 2-Way Frequency Table
attach(data2)
mytable <- table(region,urban_rural)
mytable
prop.table(mytable, 1)

