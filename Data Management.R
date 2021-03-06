setwd("~/Rutgers Fall 2021/Multivariate Methods/DR 2013 DHS Data/DR_DHS_DataAnalysis")
library(foreign)
library(dplyr)

###IMPORTING DATA AND PICKING VARIABLES OF INTEREST###
data0 <- read.dta("DR_2013_DHS Household Member Recode/DRPR61DT/DRPR61FL.dta") #Household Member Recode

data1 <- subset(data0,select=c(
                             "hhid", #Household ID
                             "hv024", #Region of Residence
                             "hv025", #Urban or Rural
                             "hv101", #Relationship to Head of Household
                             "hv104", #Sex of HH Member
                             "hv105", #Age of HH Member
                             "hv108", #Education in year for HH Member
                             "hv115", #Marital Status of HH Member (N/A for Kids)
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
                             "hv245", #Hectares of land usable for agriculture
                             "sh25" #Education categorical variable
                             ))

###FORMATTING AND CREATING VARIABLES###
data2 <- data1
#Rename Variables
data2 <- data2 %>% rename(
                      "REGION"=hv024,
                      "URBAN_RURAL"=hv025,
                      "RELATION_TO_HH"=hv101,
                      "SEX"=hv104,
                      "AGE"=hv105,
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
                      "EDUCATION_LEVEL"=sh25
                      )
data2 <- data2 %>% rename_with(tolower)

#Create femalehead
data2$female_head <- data2$sex_of_head=="female"
#Create childofhead
data2$child_of_head <- data2$relation_to_hh=="son/daughter"
#Create household level household head marital status dummy variables
data2$married_head <- data2$relation_to_hh=="head" &
                      data2$marital_status=="married"
data2$together_head <- data2$relation_to_hh=="head" &
                       data2$marital_status=="living together"
data2$nevermarried_head <- data2$relation_to_hh=="head" &
                           data2$marital_status=="never married"
data2 <- data2 %>% mutate(div_wid_sep_head=ifelse(
                      relation_to_hh=="head" &
                      marital_status %in% 
                      c("divorced","not living together","widowed"),
                      TRUE,FALSE))

data2$hh_married_head <- NA
data2$hh_together_head <- NA
data2$hh_nevermarried_head <- NA
data2$hh_div_wid_sep_head <- NA
data2a=data.frame()
for (i in unique(data2$hhid)){
  temp=data2[which(data2$hhid==i),]
  temp$hh_married_head=sum(temp$married_head, na.rm=TRUE)
  temp$hh_together_head=sum(temp$together_head, na.rm=TRUE)
  temp$hh_nevermarried_head=sum(temp$nevermarried_head, na.rm=TRUE)
  temp$hh_div_wid_sep_head=sum(temp$div_wid_sep_head, na.rm=TRUE)
  data2a=rbind(data2a,temp)
}

#Create household level household head education level variable (LATER)
# data2a$hh_head_education <- NA
# data2b=date.frame()
# for(i in unique(data2b$hhid))


###LIMITING TO POPULATION OF INTEREST###
data3 <- data2a %>% filter(
#Limit the dataset to children aged 6-14
                          age > 5, age < 15,
#Remove missing values for child's education
                          years_of_education < 90,
#Only children of head
                          child_of_head==TRUE)


###CREATE ADDITIONAL VARIABLES###
#Create oldest_male_child
data3$oldest_child <- FALSE
data3$oldest_male_child <- FALSE
data3a=data.frame()
for (i in unique(data3$hhid)){
  temp=data3[which(data3$hhid==i),]
  temp$oldest_child[which(temp$age==max(temp$age))]=TRUE
  temp$oldest_male_child[which(temp$oldest_child==1 & temp$sex=="male")]=TRUE
  data3a=rbind(data3a,temp)
}

###REMOVE UNNECESSARY VARIABLES###
data4 <- subset(data3a, select = -c(married_head,
                                    together_head,
                                    div_wid_sep_head,
                                    nevermarried_head,
                                    sex_of_head,
                                    marital_status))


###CREATING RANDOM SAMPLE###
#Take a random sample
set.seed(1)
sample1 <- data4[sample(nrow(data4), 150), ]

#Recode Categorical Variables

#Summary
summary(sample1)

#Write the CSV for the Sample
write.csv(sample1,file="Sample1.csv")



