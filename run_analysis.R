##You should create one R script called run_analysis.R that does the following. 
##Merges the training and the test sets to create one data set.
##Extracts only the measurements on the mean and standard deviation for each measurement. 
##Uses descriptive activity names to name the activities in the data set
##Appropriately labels the data set with descriptive variable names. 
##From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and 
##each subject.

##Need to install packages if you do not have them: 
##Restarting R may be required after installing the packages:
if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

##install.packages("data.table")
##install.packages("reshape2")

##Call needed library packages:
library("data.table")
library("reshape2")

##Set working directory
setwd("~/UCI HAR Dataset/")

##Read activity labels, features, X and y test data, X and y train data, and subject test and train data, into a table:
actvtylbls <- read.table("~/UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("~/UCI HAR Dataset/features.txt")[,2]
Xtest <- read.table("~/UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("~/UCI HAR Dataset/test/y_test.txt")
subjtest <- read.table("~/UCI HAR Dataset/test/subject_test.txt")
subjtrain <- read.table("~/UCI HAR Dataset/train/subject_train.txt")
xtrain <- read.table("~/UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("~/UCI HAR Dataset/train/y_train.txt")

##Uses descriptive activity names to name the activities in the test data sets:
names(Xtest) = features
ytest[,2] = actvtylbls[ytest[,1]]
names(ytest) = c("Activity_ID", "Activity_Label")
names(subjtest) = "subject"

##Uses descriptive activity names to name the activities in the train data sets:
names(xtrain) = features
ytrain[,2] = actvtylbls[ytrain[,1]]
names(ytrain) = c("Activity_ID", "Activity_Label")
names(subjtrain) = "subject"

##Extracts only the measurements on the mean and standard deviation for each measurement:
extrfeatrmsrmts <- grepl("mean|std", features)
Xtest = Xtest[,extrfeatrmsrmts]
xtrain = xtrain[,extrfeatrmsrmts]

##Bind test and train data:
testdata <- cbind(as.data.table(subjtest), ytest, Xtest)
traindata <- cbind(as.data.table(subjtrain), ytrain, xtrain)

##Merges the training and the test sets to create one data set.
mergeddataset = rbind(testdata, traindata)

##Appropriately labels the data set with descriptive variable names: 
idandlabels = c("subject", "Activity_ID", "Activity_Label")
datasetlabels = setdiff(colnames(mergeddataset), idandlabels)
meltdata = melt(mergeddataset, id = idandlabels, measure.vars = datasetlabels)

##From the data set in step 4, creates a second, 
##independent tidy data set with the average of each variable for each activity and 
##each subject:
tidydata   = dcast(meltdata, subject + Activity_Label ~ variable, mean)
write.table(tidydata, file = "~/tidydata.txt",  row.name = FALSE)
