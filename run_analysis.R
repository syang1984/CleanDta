# Install the Package first if you have not done so.

install.packages("plyr")


library(plyr)

# Step 1: Merge training and test sets to create one dataset

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# Create "x" dataset
x_data <- rbind(x_train, x_test)

# Create "y" dataset
y_data <- rbind(y_train, y_test)

# Create "subject" dataset
subject_data <- rbind(subject_train, subject_test)

# Step 2: Extract the measurements on the mean and standard deviation for each measurement

features <- read.table("features.txt")

# Get only the columns with mean() or std() in their names
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# Subset the desired columns
x_data <- x_data[, mean_and_std_features]

# Correct the column names
names(x_data) <- features[mean_and_std_features, 2]

# Step 3: Apply descriptive activity names to label the activities in the dataset

activities <- read.table("activity_labels.txt")

# Update values with correctly labeled activity names
y_data[, 1] <- activities[y_data[, 1], 2]

# Correct column name
names(y_data) <- "activity"

# Step 4: Label the data set with descriptive variable names accurately

# Correct column name
names(subject_data) <- "subject"

# Bind all the data into a single dataset
all_data <- cbind(x_data, y_data, subject_data)

# Step 5: Create a second, independent tidy data set with the average of each variable
# for each activity and each subject


# 66 <- 68 columns but the last two (activity & subject)
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

# Create output file
write.table(averages_data, "averagedata.txt", row.name=FALSE)