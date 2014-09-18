---
title: "Getting and Cleaning Data - Course Project"
---

# Project files:
run_Analysis.R  -- script that reads, merges, reshapes and summarizes the data
CodeBook.md     -- description of variables
Readme.md       -- description of the steps of the analysis (you are reading it now)

# Data and Setup
The data used for this project was downloaded from this url:
<a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" /a>

The archive "getdata-projectfiles-UCI HAR Dataset.zip" was extracted using an external application (e.g. Winrar).
All files required for the analysis are contained in a folder named "UCI HAR Dataset".
For the R code in "run_analysis.R" to work, this folder must be placed as is in the working directory.
The paths to the different parts of the dataset can also be adjusted in the R script if needed.

# Step 1 -- Reading data

Paths to the various parts of the dataset can be modified if needed if the base structure has been altered for some reason.
All pieces of the data are read and put into variables, in this order:

1. features (main)        : 2-column dataset. 2nd column has the names of all the variables in the dataset
2. activity_labels (main) : 2-column dataset that allows translation between activity labels and activity numbers
3. x_test (test)          : values of all the test variables for all activities and subjects
4. y_test (test)          : activity number (1 to 6) for all the records in x_test data frame
5. subject_test (test)    : 1-column data frame with subject IDs for all records in x_test
6. x_train (train)        : values of all the train variables for all activities and subjects
7. y_train (train)        : activity number (1 to 6) for all the records in x_train data frame
8. subject_train (train)  : 1-column data frame with subject IDs for all records in x_train

# Step 2 - Labeling columns and merging data

Test (x_test) and train (x_train) datasets are merged using 'rbind()'.
x_train and x_test are removed from memory after the merging.
Column names, taken from the 'features' variable, are then added to the merged dataset. 

# Step 3 - Extracting desired measurements

Since only variables that are means and standard deviation of measurements are needed, we extract those from the merged dataset.
This is achieved by:
- Creating an empty logical vector 'select'. This vector will hold TRUE values for all columns that we wish to keep
- Looping over all columns of the merged dataset, we look for variables that contain either "mean()" or "std()" in the name.
- For every matching column name, a TRUE value is added to 'select'. Otherwise a FALSE value is added.
- Columns are then extracting using the conditions from the 'select' vector 

# Step 4 - Adding subject and activity information 

Activity labels are added to the extracted dataset. This is done by:
- Merging 'y_test' and 'y_train', containing ID code of activities
- Substituting activity code number for activity names from 'activity_labels'
- Convert activity labels vector to a factor variable and add it to the extracted dataset as a new column

Subject IDs are obtained by merging 'subject_test' and 'subject_train' using 'rbind()'.
Subject IDs are converted to a factor variable and added to the dataset as a new column.

# Step 5 - Summarizing data and writing output file

Data is summarized using the 'melt()' and 'dcast()' functions.
The output is an average of all 66 measurements, by subject and activity.
The output data is then written in a text file using 'write.table()'
