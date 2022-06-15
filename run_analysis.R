pathdata <- file.path("C:/Users/dlivshits163814/OneDrive - Applied Materials/Desktop/Learning R/Getting Data", "UCI HAR Dataset")

#Reading training tables
xtrain <- read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain <- read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
subject_train = read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)

#Reading the testing tables
xtest <- read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest <- read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subject_test = read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)

#Read the features data
features <- read.table(file.path(pathdata, "features.txt"),header = FALSE)

#Read activity labels data
activityLabels <- read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

#Create Sanity and Column Values to the train data
colnames(xtrain) <- features[,2]
colnames(ytrain) <- "activityId"
colnames(subject_train) <- "subjectId"

#Create activity and subject IDs values to the test data
colnames(xtest) <- features[,2]
colnames(ytest) <- "activityId"
colnames(subject_test) <- "subjectId"

#Activity labels adding
colnames(activityLabels) <- c('activityId','activityType')

#Merge of the train and test datas
mrg_train <- cbind(ytrain, subject_train, xtrain)
mrg_test <- cbind(ytest, subject_test, xtest)

#Create the main data table merging both table tables - this is the outcome of 1
TotalData = rbind(mrg_train, mrg_test)

#Step to read all the values that are available
colNames <- colnames(TotalData)

#Subset of all the mean and standards and the corresponding activityID and subject Id 
mean_and_std = (grepl("activityId" , colNames) | 
                  grepl("subjectId" , colNames) | 
                  grepl("mean.." , colNames) | 
                  grepl("std.." , colNames)
                )

#Subset with the required data set
setForMeanAndStd <- TotalData[ , mean_and_std == TRUE]
setWithActivityNames <- merge(setForMeanAndStd, activityLabels, by='activityId', all.x=TRUE)

# New tidy (second) 
secondTidySet <- setWithActivityNames %>% group_by(activityId, subjectId) %>% summarize_all(funs(mean))
secondTidySet <- secondTidySet[order(secondTidySet$subjectId, secondTidySet$activityId),]

#Output a text file 
write.table(secondTidySet, file="./secondTidySet.txt", row.name=FALSE)

