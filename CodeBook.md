A code book that describes the variables, the data, and any transformations or work that you performed to clean up the data 
called CodeBook.md.  Look after the ## to see what each variable, data, and transformations mean:

##Need to install packages if you do not have them: 
##Restarting R may be required after installing the packages:
Package: data.table = Description: data.table inherits from data.frame. 
It offers fast subset, fast grouping, fast update, fast ordered joins and list columns in a short and flexible syntax, for faster development. 
It is inspired by A[B] syntax in R where A is a matrix and B is a 2-column matrix. 
Since a data.table is a data.frame, it is compatible with R functions and packages that only accept data.frame.

Package: reshape2 = Description: Flexibly restructure and aggregate data using just two
    functions: melt and dcast (or acast).

##Set working directory to folder that contains all of the needed files: UCI HAR Dataset

##Read activity labels, features, X and y test data, X and y train data, and subject test and train data, into a table:
actvtylbls = get the acitivity labels text file and read it into a table.
features = get the features text file and read it into a table, looking at two columns.
Xtest = get the X test data text file and read it into a table.
ytest = get the y test data text file and read it into a table.
subjtest = get the subject testing data text file and read it into a table.
subjtrain = get the subject training data text file and read it into a table.
xtrain = get the X training data text file and read it into a table.
ytrain = get the y training data text file and read it into a table.

##Uses descriptive activity names to name the activities in the test data sets:
names(Xtest) = features ##Description: Functions to get or set the names of the Xtest object
ytest[,2] = actvtylbls[ytest[,1]]  ##For y test data get the columns names
names(ytest) = c("Activity_ID", "Activity_Label") ##For y test data set the columns names
names(subjtest) = "subject" ##For subject test data set the column name to subject

##Uses descriptive activity names to name the activities in the train data sets:
names(xtrain) = features ##Description: Functions to get or set the names of the Xtrain object
ytrain[,2] = actvtylbls[ytrain[,1]] ##For y train data get the columns names
names(ytrain) = c("Activity_ID", "Activity_Label")  ##For y train data set the columns names
names(subjtrain) = "subject" ##For subject train data set the column name to subject

##Extracts only the measurements on the mean and standard deviation for each measurement of x test and x train:
extrfeatrmsrmts <- grepl("mean|std", features) ##Calculate the mean and standard deviation on the measurements of x test and x train variables.
Xtest = Xtest[,extrfeatrmsrmts] ##Extracts only the measurements on the mean and standard deviation for each measurement of x test
xtrain = xtrain[,extrfeatrmsrmts] ##Extracts only the measurements on the mean and standard deviation for each measurement of x train:

##Bind test and train data:
testdata <- cbind(as.data.table(subjtest), ytest, Xtest) ##Column bind testing data sets
traindata <- cbind(as.data.table(subjtrain), ytrain, xtrain) ##Column bind the training data sets

##Merges the training and the test sets to create one data set.
mergeddataset = rbind(testdata, traindata)

##Appropriately labels the data set with descriptive variable names: 
idandlabels = c("subject", "Activity_ID", "Activity_Label") ##Set labels subject, acitivities, and labels
datasetlabels = setdiff(colnames(mergeddataset), idandlabels) ##set different merged data sets with ids and labels
meltdata = melt(mergeddataset, id = idandlabels, measure.vars = datasetlabels) ##Convert the data set object into a molten data frame.

##From the data set in step 4, creates a second, 
##independent tidy data set with the average of each variable for each activity and 
##each subject:
tidydata   = dcast(meltdata, subject + Activity_Label ~ variable, mean) ##Cast functions Cast a molten data frame into an array or data frame.
write.table(tidydata, file = "~/tidydata.txt",  row.name = FALSE) ##write out the tidy data to the text file.
