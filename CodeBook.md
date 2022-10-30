The code saved in run_analysis.R performs the reading, tidying and analysing the data.

The data consist of diverse measurements of movement of a person by phone features. 

The raw data consist of a main folder with two folders with datasets (test and train) and two common files for both datasets, features.txt and activity_labels.txt. The idea is to merge two datasets (test and train) and tidy the dataset using additional files in the folders (to rename columns, to add new columns, etc.).

The full task consist of requirements for run_analysis.R:

    1. Merges the training and the test sets to create one data set.

    2. Extracts only the measurements on the mean and standard deviation for each measurement. 

    3. Uses descriptive activity names to name the activities in the data set

    4. Appropriately labels the data set with descriptive variable names. 

    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The description of variables used in run_analysis.R:

features - the data frame with information about the names of the measured features. Corresponds to the columns in the datasets train and test. 

activityLabels - the data frame with information about the names of activities that were recorded during measurements. 

readSet - the function to read the dataset. 
  
prepareForMerge - the function to tidy the raw dataset. 

importedData - the data frame of merged datasets with tidy data (with tidy names of columns, merged additional columns, etc.).

importedDataMean - the final data frame with required analysis performed on importedData.

The steps of the run_analysis.R:

1. Reading two common files for both datasets: features and activityLabels.

2. Creating the function "readSet" to read the dataset from a folder. In addition, reading the files with information about the activityID and subjectID from the same folder as dataset for further analysis. 

3. Creating a function "prepareFoMerge" to tidy up the dataset:
  - naming columns of dataset using features data frame
  - adding columns with labelID and subjectID
  - merging the data frame with activityLabels to dataset with a key "labelID" (task 3).
  
4. Creating a new data frame importedData by merging two datasets:
  - calling the function readSet on two datasets
  - calling the function prepareForMerge on two datasets
  - merging both datasets into one by row join (task 1)
  - selecting only required from task columns (task 2)
  - renaming the columns into tidy requirements (task 4)
  
5. Creating a new data frame importedDataMean:
  - grouping the data by each activity and each subject (task 5)
  - summarizing by the mean value for each variable in each group (task 5)
  
  Resulting data consist of the following columns: 
  - activityLabel - name of the activity
  - subjectID - ID of the person 
  - 66 columns from the original dataset that correspond to requirements of task 2 (mean or std) that contain averaged values for each activity and each subject.
  
6. Saving the importedDataMean into .txt file.

System version:
R version 4.2.1 (2022-06-23 ucrt) -- "Funny-Looking Kid"
Copyright (C) 2022 The R Foundation for Statistical Computing
Platform: x86_64-w64-mingw32/x64 (64-bit)
