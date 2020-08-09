# setwd("C:/_projects/datasciencecourcera/Course3")

####################################################################################################
#1. Merges the training and the test sets to create one data set.
####################################################################################################
# Download the file

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filePath <- file.path(getwd(),"UCIdata.zip")

if(!file.exists("UCIdata.zip")){
  download.file(url,filePath, method = "curl") }; unzip("UCIdata.zip",files = NULL, exdir = ".")

## read data
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt") 

subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

###################################################################################################
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3 Uses descriptive activity names to name the activities in the data set
#4 Appropriately labels the data set with descriptive variable names.
##################################################################################################

# Match X data column names with Features
names(x_test) = features[,2]
names(x_train) = features[,2]

## merge data to create one data set
x_data <- rbind(x_train,x_test)
y_data <- rbind(y_train,y_test)

#### match y data with labels 
y_data <- merge(y_data,activity_labels,by.x = "V1"); names(y_data) = c("ActivityID","Activity")
subject_data <- rbind(subject_train,subject_test); names(subject_data) = "Subject"

#### merge
merged_data <- cbind(subject_data,y_data, x_data)

#extract the measurements
mean_std <- merged_data[,c(1,2,3, grep(('mean|std'),colnames(merged_data)))]

######################################################################################################################################################
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
###################################################################################################################################################

##install.packages("reshape2")
library(reshape2)
## Melt the data so we have a unique row for each combination of subject and acitivites
melt_test <- melt(mean_std,id = c("Subject", "Activity"))
tidy_data <- dcast(melt_test,formula = Subject +Activity~..., mean)

##write/save  tidy data as a text file
write.table(tidy_data, file = "tidydata.txt",row.name=FALSE)