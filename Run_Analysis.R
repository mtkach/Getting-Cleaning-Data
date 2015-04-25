# Following R script does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, independent tidy data 
##    set with the average of each variable for each activity and each subject.


setwd("~/Desktop/Coursera/Getting Cleaning Data")

## Get required data

x_train <-read.table("~/Desktop/Coursera/Getting Cleaning Data/X_train.txt", header = FALSE)

x_test <-read.table("~/Desktop/Coursera/Getting Cleaning Data/X_test.txt", header = FALSE)

y_train <-read.table("~/Desktop/Coursera/Getting Cleaning Data/y_train.txt", header = FALSE)

y_test <-read.table("~/Desktop/Coursera/Getting Cleaning Data/y_test.txt", header = FALSE)

activity_labels <-read.table("~/Desktop/Coursera/Getting Cleaning Data/activity_labels.txt")

subject_test <-read.table("~/Desktop/Coursera/Getting Cleaning Data/subject_test.txt", header = FALSE)

subject_train <-read.table("~/Desktop/Coursera/Getting Cleaning Data/subject_train.txt", header = FALSE)

data_subject <- rbind(subject_train, subject_test)
data_y <- rbind(y_train, y_test)
data_x <- rbind(x_train, x_test)

names(data_subject) <- c("subject")
names(data_y) <- c("activity")


features <- read.table("~/Desktop/Coursera/Getting Cleaning Data/features.txt", head = FALSE)
names(data_x) <- features$V2

## Consolidating data

bind_data <- cbind(data_subject, data_y)
data <- cbind(data_x, bind_data)

## Calculating Mean and Standar Deviation

CalcData <- features$V2[grep("mean\\(\\)|std\\(\\)", features$V2) ]

##Subset
selectNames <- c(as.character(CalcData), "subject", "activity")
data <- subset (data, select = selectNames)

## Appropriate labels

names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

## tidy output

library(plyr);
output <-aggregate(. ~subject + activity, data, mean)
output <- output[order(output$subject, output$activity), ]

write.table(output, file = "tidydataset.txt", row.name = FALSE)




