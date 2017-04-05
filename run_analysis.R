#####################################################################################################################################
#     Create one R script called run_analysis.R that does the following:                                                            #
#                                                                                                                                   #
#           1. Merges the training and the test sets to create one data set.                                                        #
#           2. Extracts only the measurements on the mean and standard deviation for each measurement.                              #
#           3. Uses descriptive activity names to name the activities in the data set                                               #
#           4. Appropriately labels the data set with descriptive activity names.                                                   #
#           5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.    #
#####################################################################################################################################


# Review required installations
if (!require("data.table")) {
      install.packages("data.table")
}

if (!require("reshape2")) {
      install.packages("reshape2")
}

require("data.table")
require("reshape2")


#Load data
# Load: activity labels
activity_labels <- read.table("C:/Users/Igpal/DataScienceRepo/UCI HAR Dataset/activity_labels.txt")[,2]

# Load: data column names
features <- read.table("C:/Users/Igpal/DataScienceRepo/UCI HAR Dataset/features.txt")[,2]

# Load Test data (X_test, Y_test and subject_test).
X_test <- read.table("C:/Users/Igpal/DataScienceRepo/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("C:/Users/Igpal/DataScienceRepo/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("C:/Users/Igpal/DataScienceRepo/UCI HAR Dataset/test/subject_test.txt")

# Load Train data (X_train, y_train and subject_train).
X_train <- read.table("C:/Users/Igpal/DataScienceRepo/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("C:/Users/Igpal/DataScienceRepo/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("C:/Users/Igpal/DataScienceRepo/UCI HAR Dataset/train/subject_train.txt")
names(X_train) = features

# Assign column names
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

# Extract only the measurements on the mean and standard deviation for each measurement.
# Extract mean and standard deviation.
extract_features <- grepl("mean|std", features)

names(X_test) = features

# Extract mean and std deviation for X_test
X_test = X_test[,extract_features]

# Load activity labels
y_test[,2] = activity_labels[y_test[,1]]

names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

# Extract mean and std deviation for X_train
X_train = X_train[,extract_features]


# Merge test and train data
# Bind data
test_data <- cbind(as.data.table(subject_test), y_test, X_test)
train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge data
data = rbind(test_data, train_data)


# Descriptive activity names to name the activities in the data set  
id_labels = c("subject", "Activity_ID", "Activity_Label")
data_labels = setdiff(colnames(data), id_labels)
melt_data = melt(data, id_labels, data_labels)


# Creates a second, independent tidy data set with the average of each variable for each activity and each subject
tidy_data   = dcast(melt_data, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt", row.names = FALSE)
