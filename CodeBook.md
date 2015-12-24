###The data
The raw data came from 30 **subjects** who performed six **activities**
(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone.
**3-axial** linear acceleration and 3-axial angular velocity were captured from the phone's **accelerometer** and **gyroscope**.
These signals were (through preprocessing, filtering, sampling etc) seperated into **body acceleration** and **gravity**.
The domains for calculation were **time** and **frequency**. From these, many other variables were estimated but for this tidy data, only the measurements of **mean** and **standard** deviation of each variable were selected.

Thus, there are 6 categories that denote the variables.

###Dimensions
```
* time or frequency
* Body or Gravity
* acceleromenter (Acc) or gyroscope (Gyro)
* signal, Jerk, magnitude (Mag)
* 3-axial (XYZ)
* mean or sd

```
###Examples
```
- time_BodyAcc_mean_X       : time domain, body acceleration signal from accelerometer, mean, X axis
- time_BodyAcc_std_X        : time domain, body acceleration from accelerometer, standard deviation, X axis
- time_GravityAcc_mean_Z    : time domain, gravity signal from accelerometer, mean, Z axis
- time_BodyAccJerk_std_Y    : time domain, body jerk signal from accelerometer, standard deviation, Y axis
- frequency_BodyGyro_mean_X : frequency domain, body signal from gyroscope, mean, X axis
- frequency_BodyAccMag_mean : frequency domain, body signal from accelerometer, magnitude, mean
```

The means of these 66 variables were computed for each subject for each activity resulting in 180 rows (30 subjects * 6 activities).


###Variables
```
     1	subject 
     2	activity
     3	time_BodyAcc_mean_X 
     4	time_BodyAcc_mean_Y 
     5	time_BodyAcc_mean_Z 
     6	time_BodyAcc_std_X
     7	time_BodyAcc_std_Y
     8	time_BodyAcc_std_Z
     9	time_GravityAcc_mean_X
    10	time_GravityAcc_mean_Y
    11	time_GravityAcc_mean_Z
    12	time_GravityAcc_std_X 
    13	time_GravityAcc_std_Y 
    14	time_GravityAcc_std_Z 
    15	time_BodyAccJerk_mean_X 
    16	time_BodyAccJerk_mean_Y 
    17	time_BodyAccJerk_mean_Z 
    18	time_BodyAccJerk_std_X
    19	time_BodyAccJerk_std_Y
    20	time_BodyAccJerk_std_Z
    21	time_BodyGyro_mean_X
    22	time_BodyGyro_mean_Y
    23	time_BodyGyro_mean_Z
    24	time_BodyGyro_std_X 
    25	time_BodyGyro_std_Y 
    26	time_BodyGyro_std_Z 
    27	time_BodyGyroJerk_mean_X
    28	time_BodyGyroJerk_mean_Y
    29	time_BodyGyroJerk_mean_Z
    30	time_BodyGyroJerk_std_X 
    31	time_BodyGyroJerk_std_Y 
    32	time_BodyGyroJerk_std_Z 
    33	time_BodyAccMag_mean
    34	time_BodyAccMag_std 
    35	time_GravityAccMag_mean 
    36	time_GravityAccMag_std
    37	time_BodyAccJerkMag_mean
    38	time_BodyAccJerkMag_std 
    39	time_BodyGyroMag_mean 
    40	time_BodyGyroMag_std
    41	time_BodyGyroJerkMag_mean 
    42	time_BodyGyroJerkMag_std
    43	frequency_BodyAcc_mean_X
    44	frequency_BodyAcc_mean_Y
    45	frequency_BodyAcc_mean_Z
    46	frequency_BodyAcc_std_X 
    47	frequency_BodyAcc_std_Y 
    48	frequency_BodyAcc_std_Z 
    49	frequency_BodyAccJerk_mean_X
    50	frequency_BodyAccJerk_mean_Y
    51	frequency_BodyAccJerk_mean_Z
    52	frequency_BodyAccJerk_std_X 
    53	frequency_BodyAccJerk_std_Y 
    54	frequency_BodyAccJerk_std_Z 
    55	frequency_BodyGyro_mean_X 
    56	frequency_BodyGyro_mean_Y 
    57	frequency_BodyGyro_mean_Z 
    58	frequency_BodyGyro_std_X
    59	frequency_BodyGyro_std_Y
    60	frequency_BodyGyro_std_Z
    61	frequency_BodyAccMag_mean 
    62	frequency_BodyAccMag_std
    63	frequency_BodyBodyAccJerkMag_mean 
    64	frequency_BodyBodyAccJerkMag_std
    65	frequency_BodyBodyGyroMag_mean
    66	frequency_BodyBodyGyroMag_std 
    67	frequency_BodyBodyGyroJerkMag_mean
    68	frequency_BodyBodyGyroJerkMag_std 
```

###run_analysis.R
I used only data.table package.

library(data.table)

* read in test data
```
fread('test/X_test.txt',header=FALSE)->x.test
fread('test/y_test.txt',header=FALSE)->y.test
fread('test/subject_test.txt',header=FALSE)->subject.test
```
* read in train data
```
fread('train/X_train.txt',header=FALSE)->x.train
fread('train/y_train.txt',header=FALSE)->y.train
fread('train/subject_train.txt',header=FALSE)->subject.train
```
* features
```
features<-fread("features.txt")
names(features)<-c("variableNum","variableName")
```
* activity
```
activity<-fread("activity_labels.txt")
names(activity)<-c("activityNum","activity")
```

* merge train and test data
```
x<-rbind(x.test,x.train)
y<-rbind(y.test,y.train)
subject<-rbind(subject.test,subject.train)
names(subject)<-"subject"
```

* using grep() extract, from 561 variables, the column numbers and variables names that have mean() and std() as a part of variable name
```
mean_sd_columns<-grep("mean()|std()",features$variableName)
new_features<-features[mean_sd_columns,]
meanFreq_columns<-grep("meanFreq",new_features$variableName)
new_features<-new_features[-meanFreq_columns,]
```

* using gsub() change the variable names more descriptive
```
new_features$variableName<-gsub('^f','frequency_',new_features$variableName)
new_features$variableName<-gsub('^t','time_',new_features$variableName)
new_features$variableName<-gsub('\\(\\)','',new_features$variableName)
new_features$variableName<-gsub('-','_',new_features$variableName)
```

* from the dataset x, using new_feature's column numbers, select mean and sd columns, 
* using new_feature's column names, name the selected columns
```
x<-x[,new_features$variableNum,with=FALSE]
names(x)<-new_features$variableName
```

* this was a tricky part for me because I neglected and forgot that merge() sorts the results
* and merging the sorted activity data with y created incomprehensible data 
* because subjects were no longer lined up with their activities.
* instead, used y as an index for activity (because activity$activityNum and activity's row.names were identical)
```
new_y<-activity[y$V1,]
```

* create the final data with all three
```
dt<-cbind(subject,new_y,x)
```
* use data.table's lapply and by to create mean of the columns for each subject and each activity
* and save the result
```
tidyData<-dt[, lapply(.SD,mean), .SDcols=4:69,by=.(subject,activity)]
tidyData<-tidyData[order(subject,activity)]
write.table(tidyData,file="tidyData.txt",row.names=FALSE)
```
