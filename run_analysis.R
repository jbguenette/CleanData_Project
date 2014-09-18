##########################################################
## Work title: Course Project
## Course title: Getting and Cleaning Data
## University: John Hopkins Bloomberg School of Public Health
## Coursera.org
## September 17th, 2014
## Extra Documentation : CodeBook.md, Readme.md
##########################################################

# Set local working directory (used only during development for convenience)
# setwd("C:/Users/Héron/Documents/Data Science Specialization/03_Getting and Cleaning Data/Week 3")

## STEP 1 - READING DATA
#########################

# Path variables to locations of all parts of the dataset: main, test and train
main_dir <- "./UCI HAR Dataset/"
test_dir <- "./UCI HAR Dataset/test/"
train_dir <- "./UCI HAR Dataset/train/"

# Load global data from the main directory
features <- read.table(paste(main_dir, "features.txt", sep=""))
activity_labels <- read.table(paste(main_dir, "activity_labels.txt", sep=""))

# Load all test data files
x_test <- read.table(paste(test_dir, "x_test.txt", sep=""))
y_test <- read.table(paste(test_dir, "y_test.txt", sep=""))
subject_test <- read.table(paste(test_dir, "subject_test.txt", sep=""))

# Load all train data files
x_train <- read.table(paste(train_dir, "x_train.txt", sep=""))
y_train <- read.table(paste(train_dir, "y_train.txt", sep=""))
subject_train <- read.table(paste(train_dir, "subject_train.txt", sep=""))

## STEP 2 - LABELING COLUMNS AND MERGING DATA
#########################

# Merge test and train datasets and remove originals from memory
x_merged <- rbind(x_test, x_train)
remove(x_test)
remove(x_train)

# Apply column names to merged dataset
colnames(x_merged) <- features[,2]

## STEP 3 - EXTRACTING DESIRED MEASUREMENTS
#########################

# Extract all columns containing means and standard deviations (std) of
#    measurements
select <- logical()
for(i in 1:ncol(x_merged)){
    select <- c(select, grepl("mean()", colnames(x_merged[i]), fixed = TRUE) 
                | grepl("std()", colnames(x_merged[i]), fixed = TRUE))
}
x_extract <- x_merged[,select]

## STEP 4 - ADDING SUBJECT AND ACTIVITY INFORMATION 
#########################

# Add activity labels to extracted dataset. Steps to achieve this:
# - Merge 'y_test' and 'y_train', containing ID code of activities
# - Substitute activity code number for activity names from 'activity_labels'
# - Convert activity labels vector to a factor variable and
#     add it to the extracted dataset as a new column
y <- rbind(y_test, y_train)
for(i in 1:nrow(y))  y[i,1] <- as.character(activity_labels[y[i,1], 2])
x_extract$activity <- factor(y[,1])

# Add subject IDs, from 'subject_test' and 'subject_train' as a new column
# Convert 'subject' variable to a factor variable
x_extract$subject <- rbind(subject_test, subject_train)
x_extract$subject <- factor(unlist(x_extract$subject))

## STEP 5 - SUMMARIZING DATA AND WRITING OUTPUT FILE
#########################

# Summarize data: all 66 variables are averaged by subject and activity
library(reshape2)
x_melt <- melt(x_extract, id=c("subject", "activity"), 
               measure.vars=colnames(x_extract)[1:66])
x_cast <- dcast(x_melt, subject + activity ~ variable, mean)

# Write summarized data into a text file
write.table(x_cast, "tidyData.txt", row.names = FALSE)
