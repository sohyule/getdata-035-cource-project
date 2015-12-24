
#Getting and Cleaning Data, course-project
#12/24/2015

#setwd("../UCI HAR Dataset")
#getwd()

library(data.table)

#read data in
#test
fread('test/X_test.txt',header=FALSE)->x.test
fread('test/y_test.txt',header=FALSE)->y.test
fread('test/subject_test.txt',header=FALSE)->subject.test

#train
fread('train/X_train.txt',header=FALSE)->x.train
fread('train/y_train.txt',header=FALSE)->y.train
fread('train/subject_train.txt',header=FALSE)->subject.train

#features
features<-fread("features.txt")
names(features)<-c("variableNum","variableName")

#activity
activity<-fread("activity_labels.txt")
names(activity)<-c("activityNum","activity")

#merge train and test data
x<-rbind(x.test,x.train)
y<-rbind(y.test,y.train)
subject<-rbind(subject.test,subject.train)
names(subject)<-"subject"

#from features, pick only mean and sd columns
mean_sd_columns<-grep("mean()|std()",features$variableName)
new_features<-features[mean_sd_columns,]
#meanFreq() columns are still in there, drop them
meanFreq_columns<-grep("meanFreq",new_features$variableName)
new_features<-new_features[-meanFreq_columns,]

#change the variable names more descriptive
new_features$variableName<-gsub('^f','frequency_',new_features$variableName)
new_features$variableName<-gsub('^t','time_',new_features$variableName)
new_features$variableName<-gsub('\\(\\)','',new_features$variableName)
new_features$variableName<-gsub('-','_',new_features$variableName)

#pick only mean, sd columns from x
x<-x[,new_features$variableNum,with=FALSE]
#name them
names(x)<-new_features$variableName

#do not use merge, merge does NOT preserve the original order!
#use y$activityNum as index because activity's row names is equal to activityNum
new_y<-activity[y$V1,]

#cbind all three and create the final data
dt<-cbind(subject,new_y,x)

tidyData<-dt[, lapply(.SD,mean), .SDcols=4:69,by=.(subject,activity)]
tidyData<-tidyData[order(subject,activity)]
dim(tidyData)

write.table(tidyData,file="tidyData.txt",row.names=FALSE)

