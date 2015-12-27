# getdata-035-cource-project
Getting and Cleaning Data Course Project



The R script 'run_analysis.R' assumes that the current folder has two subfolders **train** and **test** with their 3 data files (x, y, subject) in each, and two files **features.txt**, **activity_labels.txt**.   
"run_analysis.R", downloaded in the current folder will create tidyData.txt (790 rows, 19 columns) when run.


Mainly functions from data.table and select from dplyr were used. Also two simple regex functions (grep and gsub) were used to change the column names,and select them when necessary.

The raw data (train and test combined) was 10299 lines and 561 columns.

Only the columns whose names include "mean()" or "std()" were selected from the beginning, and combinded with subject and activity files.

Then the means of those columns for each subject and each activity were computed. This part was simple.

One of Hadley's rules -- Column headers are values, not variable names -- was judged to apply to the current data, and accordingly X, Y, Z and magnitude columns were stacked into a single column (from wide to long format).
This process was complicated!

All the columns for X, Y, Z and Magnitude were selected into separate data tables (making sure that their column names were matched), then were rbind'ed.

The resulting tidy data has subject, activity, axis and the means for 16 variables which are means and standard deviations themseleves.

The description of the variables is in the file CodeBook.md.

 



