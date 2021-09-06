setwd("~/Rutgers Fall 2021/Multivariate Methods/DR 2013 DHS Data/DR_2013_DHS Household Member Recode/DRPR61DT")

library(foreign)
data <- read.dta("DRPR61FL.DTA") #Household Recode

selectcolumns <- subset(data,select=c("hv024", #Region of Residence
                             "hv025", #Urban or Rural
                             "hv101", #Relationship to Head of Household
                             "hv104", #Sex of HH Member
                             "hv105", #Age of HH Member
                             "hv108", #Education in year for HH Member
                             "hv115", #Marital Status of HH Member
                             "hv129", #School Attendance status category
                             "hv140", #Member has birth certificate
                             "hv206", #HH has electricity
                             "hv207", #HH has radio
                             "hv208", #HH has TV
                             "hv209", #HH has fridge
                             "hv210", #HH has bicycle
                             "hv211", #HH has motorcycle
                             "hv212", #HH has car
                             "hv219", #Sex of HH Head
                             "hv220", #Age of HH Head
                             "hv221", #HH has telephone
                             "hv225", #Share bathroom with other HH's
                             "hv227", #Has mosquito net
                             "hv237", #Anything done to water to make potable
                             "hv242", #HH has seperate room used as kitchen
                             "hv244", #HH has land usable for agriculture
                             "hv245",  #Hectares of land usable for agriculture
                             "sh25" #Gotta figure this one out still
                             ))


