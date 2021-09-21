data2$oldest_male_child <- NA
data2a=data.frame()
for (i in unique(data2$hhid)){
  temp=data2[which(data2$hhid==i),]
  temp$oldest_child[which(temp$age==max(temp$age))]=1
  temp$oldest_male_child[which(temp$oldest_male==1 & temp$sex=="male")]
  data2a=rbind(data2a,temp)
}

############################

demo<- data.frame(HH_id = c(1,1,1,2,2,2),
                  age=c(1:6),
                  gender  = c("male", "male", "female"),
                  animals = c("dog", "dog", "cat"),
                  stringsAsFactors = FALSE)

demo$dummy=0

ttt=data.frame()
for (i in unique(demo$HH_id)){
  tmpdf=demo[which(demo$HH_id==i),]
  tmpdf$dummy[which(tmpdf$age==max(tmpdf$age))]=1
  ttt=rbind(ttt,tmpdf)
}

ttt




summary(data2)
