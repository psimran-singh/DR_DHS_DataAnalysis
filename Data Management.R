setwd("~/Rutgers Fall 2021/Multivariate Methods/DR 2013 DHS Data/DR_2013_DHS Household Member Recode/DRPR61DT")

library(foreign)
library(dplyr)

data <- read.dta("DRPR61FL.DTA") #Household Recode

data1 <- subset(data,select=c("hv024", #Region of Residence
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
                             "hv225", #Share bathroom with other HH's
                             "hv237", #Anything done to water to make potable
                             "hv244", #HH has land usable for agriculture
                             "hv245",  #Hectares of land usable for agriculture
                             "sh25" #HH education level
                             ))

###Formatting variables###
data2 <- data1
#Rename Variables
data2 <- data2 %>% rename(
                      "REGION"=hv024,
                      "URBAN_RURAL"=hv025,
                      "RELATION_TO_HH"=hv101,
                      "AGE"=hv104,
                      "SEX"=hv105,
                      "YEARS_OF_EDUCATION"=hv108,
                      "MARITAL_STATUS"=hv115,
                      "SCHOOL_ATTENDANCE_STATUS"=hv129,
                      "BIRTH_CERTIFICATE"=hv140,
                      "HAS_ELECTRICITY"=hv206,
                      "HAS_RADIO"=hv207,
                      "HAS_TV"=hv208,
                      "HAS_FRIDGE"=hv209,
                      "HAS_BIKE"=hv210,
                      "HAS_MOTORCYCLE"=hv211,
                      "HAS_CAR"=hv212,
                      "SEX_OF_HEAD"=hv219,
                      "AGE_OF_HEAD"=hv220,
                      "SHARE_BATHROOM"=hv225,
                      "WATER_TREATED"=hv237,
                      "HAS_AGROLAND"=hv244,
                      "ACRES_AGROLAND"=hv245,
                      "HH_HEAD_EDUCATION"=sh25)
data2 <- data2 %>% rename_with(tolower)

# #Create femalehead
# data2$femalehead <- data2$hv219=="female"
# #Create childofhead
# data2$childofhead <- data2$hv101=="son/daughter"



data3 <- data2 %>% filter(
#Limit the dataset to children aged 6-14
                          hv105 > 5, hv105 < 15,
#Remove missing values for child's education
                          hv108 <90,
#Only children of head
                          childofhead==TRUE)

