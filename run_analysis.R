
##  downloand and unzips source data file
dataurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("UCI HAR Dataset.zip")){
        download.file(dataurl,"UCI HAR Dataset.zip")
        unzip("UCI HAR Dataset.zip")
}

## Reading in data and naming columns
activity <- read.table("UCI HAR Dataset/activity_labels.txt")
        colnames(activity) <- c("code", "activity")
features <- read.table("UCI HAR Dataset/features.txt")
        colnames(features) <- c("num", "features")
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt")
        colnames(subjecttest) <- "subject"
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
        colnames(xtest) <- features$features
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
        colnames(ytest) <- "code"
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt")
        colnames(subjecttrain) <- "subject"
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
        colnames(xtrain) <- features$features
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
        colnames(ytrain) <- "code"

        
## Merges the training and the test sets to create one data set
subject <- rbind(subjecttest, subjecttrain)
x <- rbind(xtest, xtrain)
y <- rbind(ytest, ytrain)
combined <- cbind(subject, x, y)


## Extracts only the measurements on the mean and standard deviation for each measurement.
library(dplyr)
combined <- data.frame(combined)
selectdata <- select(combined, subject, code, contains("mean"), contains("std"))


## Uses descriptive activity names to name the activities in the data set
library(tibble)
selectdata <- add_column(selectdata, "activity" = activity[selectdata$code, 2], .after = 2)


## Appropriately labels the data set with descriptive variable names.
names(selectdata)[2] = "activitynumber"
names(selectdata)<-gsub("Acc", "accelerometer", names(selectdata))
names(selectdata)<-gsub("Gyro", "gyroscope", names(selectdata))
names(selectdata)<-gsub("BodyBody", "body", names(selectdata))
names(selectdata)<-gsub("Mag", "magnitude", names(selectdata))
names(selectdata)<-gsub("^t", "time", names(selectdata))
names(selectdata)<-gsub("^f", "frequency", names(selectdata))
names(selectdata)<-gsub("tBody", "timeBody", names(selectdata))
names(selectdata)<-gsub("-mean()", "mean", names(selectdata), ignore.case = TRUE)
names(selectdata)<-gsub("-std()", "std", names(selectdata), ignore.case = TRUE)
names(selectdata)<-gsub("-freq()", "frequency", names(selectdata), ignore.case = TRUE)



## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
finaldata <- selectdata %>%
        group_by(subject, activity) %>%
        summarise_all(funs(mean))
write.table(finaldata, "finaldata.txt", row.name=FALSE)

