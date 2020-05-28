## Step 1 - to create a merged dataset from Train and Test

## After downloading and unzipping the files, I first create my datasets for x_train, 
## y_train and subject_train. 
x_train <- read.table(file.path(pathdata, "train", "X_train.txt"), header = F)
y_train <- read.table(file.path(pathdata, "train", "y_train.txt"), header = F)
subject_train <- read.table(file.path(pathdata, "train", "subject_train.txt"), header = F)

# Now I create datasets for x_test, y_test and subject_test.
x_test <- read.table(file.path(pathdata, "test", "X_test.txt"),header = F)
y_test <- read.table(file.path(pathdata, "test", "y_test.txt"),header = F)
subject_test <- read.table(file.path(pathdata, "test", "subject_test.txt"),header = F)

## to read data in features, I create dataset for features
features <- read.table(file.path(pathdata, "features.txt"),header = F)

## to read data in activity labels, I create dataset for activity labels
act_labels <- read.table(file.path(pathdata, "activity_labels.txt"),header = F)

## Adding column variables to train
colnames(x_train) <- features[,2]
colnames(y_train) <- "activityId"
colnames(subject_train) <- "subjectId"
## Adding column variables to test
colnames(x_test) <- features[,2]
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
## Adding column variables to activity label
colnames(act_labels) <- c("activityId","activityType")

## the next step is to merge the train and test data 
merged_train <- x_train
merged_train['activityId'] <- y_train
merged_train['subjectId'] <- subject_train

merged_test <- x_test
merged_test['activityId'] <- y_test
merged_test['subjectId'] <- subject_test
Finalmerged <- rbind(as.matrix(merged_train), as.matrix(merged_test))

## Step 2. To extract mean and standard deviation of each measurement

## Read all the values that are available
colNames <- colnames(Finalmerged)
## Need to get a subset of all the mean and standards and the corresponding activityID and subjectID 
meanstd <- (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))
# Creating datafram of the required dataset
DT_meanstd <- Finalmerged[ , meanstd == TRUE]
DT_meanstd <- as.data.frame(DT_meanstd)


## Step 3 and 4. Naming the activities in the dataset with descriptive terms

Completewithlabels <- merge(DT_meanstd, act_labels, by='activityId', all.x=TRUE)

## Step 5. New tidy set has to be created and saved as table.
newtidyset <- aggregate(. ~subjectId + activityType, Completewithlabels, mean)
newtidyset <- newtidyset[order(newtidyset$subjectId, newtidyset$activityType),]

write.table(newtidyset, "newtidyset.txt", row.name=FALSE)
