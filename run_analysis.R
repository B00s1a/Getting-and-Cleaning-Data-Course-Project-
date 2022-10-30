library("dplyr")
library("data.table")

# reading common files for both datasets

features <- read.table("features.txt", col.names = c("featureID", "featureName"))
activityLabels <- read.table("activity_labels.txt", col.names = c("labelID", "activityLabel")) %>%
                  mutate(activityLabel = tolower(activityLabel)) 

# function to read the data from both folders, test and train

readSet <- function(folderName)
{
  resultList <- list()
  
  resultList[["Data"]] <- read.table (paste0 (folderName
                                            , "/X_"
                                            , folderName
                                            , ".txt"))
  
  resultList[["Labels"]] <- read.table (paste0 (folderName
                                              , "/y_"
                                              , folderName
                                              , ".txt")
                                      , col.names = "labelID")
  
  resultList[["Subjects"]] <- read.table (paste0 (folderName
                                               , "/subject_"
                                               , folderName
                                               , ".txt")
                                       , col.names = "subjectID")
      
  return (resultList)
}

# function to tidy up the raw data

prepareForMerge <- function(dataSet, features, activities)
{
  colnames(dataSet[["Data"]]) <- features
  dataSet[["Data"]] <- cbind(dataSet[["Data"]], dataSet[["Labels"]])
  dataSet[["Data"]] <- cbind(dataSet[["Data"]], dataSet[["Subjects"]])
  

  dataSet[["Data"]] <- dataSet[["Data"]] %>%
                       merge(y = activities, by = "labelID")
  
  return(dataSet[["Data"]])
  
}

# creating the list for data from both folders

importedData <- c("test", "train") %>%
                sapply(FUN = readSet, USE.NAMES = TRUE, simplify = FALSE) %>%
                lapply(FUN = prepareForMerge
                     , features = features$featureName
                     , activities = activityLabels) %>%
                rbindlist() %>%
                select(subjectID, activityLabel, matches("-mean\\(\\)|-std\\(\\)")) %>%
                rename_with(.fn = function(inNamesVec)
                                 {
                                  return(sapply(inNamesVec
                                              , FUN = function(inName)
                                   {
                                    if (grepl("mean",inName)) inName <- sub("mean\\(\\)", "Mean", inName)
                                    else if (grepl("std",inName)) inName <- sub("std\\(\\)", "Std", inName)
                                    
                                    inName <- gsub("-", "", inName)
                                    return(inName)
                                   }))
                                  }) 

# Creating new data set with mean values of selected before columns

importedDataMean <- importedData %>%
                    group_by(activityLabel, subjectID) %>%
                    summarise_at(vars(-group_cols()), mean)

write.table(importedDataMean, "TidyDataSet.txt", row.names = FALSE)










