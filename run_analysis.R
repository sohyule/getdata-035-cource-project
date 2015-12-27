# for getdata-035, course_project
# 12/26/2015

library(data.table)
library(dplyr)
library(tidyr)

# read data in
# test
fread('test/X_test.txt',header=FALSE)->x.test
fread('test/y_test.txt',header=FALSE)->y.test
fread('test/subject_test.txt',header=FALSE)->subject.test

# train
fread('train/X_train.txt',header=FALSE)->x.train
fread('train/y_train.txt',header=FALSE)->y.train
fread('train/subject_train.txt',header=FALSE)->subject.train

# features
features<-fread("features.txt")
names(features)<-c("variableNum","variableName")

# activity
activity<-fread("activity_labels.txt")
names(activity)<-c("activityNum","activity")

# merge train and test data
x<-rbind(x.test,x.train)
y<-rbind(y.test,y.train)
subject<-rbind(subject.test,subject.train)
names(subject)<-"subject"

# add column names
names(x)<-features$variableName
# select only mean,std columns
new_x<-select(x,matches("mean|std"))
# but drop meanFreq columns
new_x<-select(new_x,-contains("meanFreq"))

# change y to activity
new_y<-activity[y$V1,]

# cbind all three (10299 rows, 76 columns)
dt<-cbind(subject,new_y,new_x)
dim(dt)

# create means for each subject and each activity
meanData<-dt[, lapply(.SD,mean), .SDcols=4:ncol(dt),by=.(subject,activity)]
meanData<-meanData[order(subject,activity)]
dim(meanData) # 180 rows, 75 columns


#  reshape
#  X, Y, Z and Magnitude become long
#  because they violate Hadley's rule 
#  Column headers are values, not variable names

# xnames<-grep(".+_X",names(meanData),value=T)
# ynames<-grep(".+_Y",names(meanData),value=T)
# znames<-grep(".+_Z",names(meanData),value=T)
# magnames<-grep("Mag",names(meanData),value=T)

xcols<-grep(".+-X",names(meanData))
ycols<-grep(".+-Y",names(meanData))
zcols<-grep(".+-Z",names(meanData))
mcols<-grep("Mag",names(meanData))

#  "frequency_BodyBodyGyroJerkMag_mean" and "frequency_BodyBodyGyroJerkMag_std"
#  have no matching XYZ values. drop them
mcols<-mcols[-c(17,18)]
# check
names(meanData)[mcols]


# separate meanData into X,Y,Z and Mag columns data
# change the names so they can be rbind'ed later
# and add a column for axis

# X
xdt<-select(meanData,subject,activity,xcols)
names(xdt)<-gsub("-X","",names(xdt))
xdt$axis<-"X"

# Y
ydt<-select(meanData,subject,activity,ycols)
names(ydt)<-gsub("-Y","",names(ydt))
ydt$axis<-"Y"

# Z
zdt<-select(meanData,subject,activity,zcols)
names(zdt)<-gsub("-Z","",names(zdt))
zdt$axis<-"Z"

# Magnitude
mdt<-select(meanData,subject,activity,mcols)
names(mdt)<-gsub("Mag","",names(mdt))
mdt$axis<-"Mag"
# there are typos in column names
names(mdt)<-gsub("BodyBody","Body",names(mdt))

# combine them back to make a long tidy data

# rbind wouldn't accept different columns names
# thus it also checks the manipulations are correct
tidyData<-rbind(xdt,ydt,zdt,mdt) # 720 rows (30 subjects x 6 activity x 4 axis) and 19 columns

# change column names more readable
names<-names(tidyData)
names<-gsub('^f','frequency_',names)
names<-gsub('^t','time_',names)
names<-gsub('\\(\\)','',names) # rid of parentheses
names<-gsub('-','_',names)
names(tidyData)<-names


# rearrange columns
tidyData<-tidyData[,c(1,2,19,3:18),with=FALSE]
tidyData<-tidyData[order(subject,activity,axis)]

write.table(tidyData,file="tidyData.txt",row.names=FALSE)
