library("plyr")
## Merges the training and the test sets to create one data set
x_test <- read.table("UCIHARDataset/test/X_test.txt", header = FALSE)
x_train <- read.table("UCIHARDataset/train/X_train.txt", header = FALSE)
subject_train <- read.table("UCIHARDataset/train/subject_train.txt", header = FALSE, col.names = "subject")
subject_test <- read.table("UCIHARDataset/test/subject_test.txt", header = FALSE, col.names = "subject")
y_test <- read.table("UCIHARDataset/test/y_test.txt", header = FALSE, col.names = "activity")
y_train <- read.table("UCIHARDataset/train/y_train.txt", header = FALSE, col.names = "activity")
activity_labels <- read.table("UCIHARDataset/activity_labels.txt", header = FALSE, col.names = c("activityid", "activity"))
features <- read.table("UCIHARDataset/features.txt", header = FALSE)

# Combining the Data with subjects
x_train <- cbind(x_train, subject_train, y_train)
x_test <- cbind(x_test, subject_test, y_test)

# Combine test and train data to single data frame
ardata <- rbind(x_test, x_train)

## You have now a single dataset called ardata

# Add columnnames from features to ardata
features <- as.vector(features$V2)
features <- c(features, "subject","activity")
names(ardata) <-  features

## Extracts only the measurements on the mean and standard deviation for each measurement
intrestingcolumns <- grep("-mean\\(\\)|-std\\(\\)", names(ardata))
intrestingcolumns <- c(intrestingcolumns, 562, 563)
intrestingcolumns <- sort(intrestingcolumns)
ardata <- subset(ardata, select = intrestingcolumns)
## Extraction complete

# Uses descriptive activity names to name the activities in the data set.
ardata$activity <- factor(ardata$activity, levels=activity_labels$activityid, label = activity_labels$activity)

## Create a second, independent tidy data set with the average of each variable for each activity and each subject
tidydata <- ddply(ardata,c('subject','activity'),function(ardata) mean=colMeans(ardata[,1:66]))
write.table(tidydata, file = "tidydata.txt", row.name = FALSE)