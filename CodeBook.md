###The data
The raw data came from 30 **subjects** who performed six **activities**
(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone.
**3-axial** linear acceleration and 3-axial angular velocity were captured from the phone's **accelerometer** and **gyroscope**.
These signals were (through preprocessing, filtering, sampling etc) seperated into **body acceleration** and **gravity**.
The domains for calculation were **time** and **frequency**. From these, many other variables were estimated but for the current data, only the measurements of **mean** and **standard** deviation of each variable were selected. All the signal variables are normalized and bounded within [-1,1]

<br><br>
Thus, there are 6 categories that describe the variables.

--------------------------------------------
--------------------------------------------  
###Categories

* time or frequency
* Body or Gravity
* acceleromenter (Acc) or gyroscope (Gyro)
* signal, Jerk
* 3-axial (XYZ), magnitude (Mag)
* mean or sd

--------------------------------------------
--------------------------------------------  


###Variables  
```
1. subject				: subject number (range 1 to 30)
2. activity				: 6 activities
3. axis					: X, Y, Z or Magnitude
4. time_BodyAcc_mean			: time domain,body signal from accelometer, mean
5. time_BodyAcc_std			: time domain,body signal from accelometer, Std
6. time_GravityAcc_mean			: time domain,gravity from accelometer, mean
7. time_GravityAcc_std			: time domain,gravity from accelometer, std
8. time_BodyAccJerk_mean		: time domain,body jerk signal from accelometer, mean
9. time_BodyAccJerk_std			: time domain,body jerk signal from accelometer, std
10. time_BodyGyro_mean			: time domain,body signal from gyroscope, mean
11. time_BodyGyro_std			: time domain,body signal from gyroscope, std
12. time_BodyGyroJerk_mean		: time domain,body jerk signal from gyroscope, mean
13. time_BodyGyroJerk_std		: time domain,body jerk signal from gyroscope, std
14. frequency_BodyAcc_mean		: frequency domain,body signal from accelometer, mean
15. frequency_BodyAcc_std		: frequency domain,body signal from accelometer, std
16. frequency_BodyAccJerk_mean	: frequency domain,body jerk signal from accelometer, mean
17. frequency_BodyAccJerk_std	: frequency domain,body jerk signal from accelometer, std
18. frequency_BodyGyro_mean		: frequency domain,body signal from gyroscope, mean
19. frequency_BodyGyro_std		: frequency domain,body signal from gyroscope, std  

```
--------------------------------------------
--------------------------------------------  

