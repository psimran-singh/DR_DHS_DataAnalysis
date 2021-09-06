setwd("~/Rutgers Fall 2021/Multivariate Methods/DR 2013 DHS Data/DR_2013_DHS Household Member Recode/DRPR61DT")

library(foreign)
data <- read.dta("DRPR61FL.DTA") #Household Recode

data <- subset(data,select=c("hv024", #Region of Residence
                             "hv025", #Urban or Rural
                             "hv101", #Relationship to Head of Household
                             "hv104", #Sex of HH Member
                             "hv105", #Age of HH Member
                             "hv115", #Marital Status of HH Member
                             "hv219", #Sex of HH Head
                             "hv220", #Age of HH Head
                             "hv225", #Share bathroom with other HH's
                             "hv227", #Has mosquito net
                             "hv237", #Anything done to water to make potable
                             "hv242", #HH has seperate room used as kitchen
                             "sh25", #
                             
                             "hv108"))

