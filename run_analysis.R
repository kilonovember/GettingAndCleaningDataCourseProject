run_analysis <- function(save.to.file = FALSE, file.path = "./tidy-data.set.txt"){
	# run_analysis.R
	# This program was prepared by Chas. Knell as the course project
	# the Getting and Cleaning Data course offered by Coursera and 
	# Johns Hopkins University.
	# 
	# The code here is explained in the CodeBook.md file which accompanies it.
	# Comments in this code will refer to the noted section of the CodeBook.md
	# file.
	#
	# Create a data table from *X_train.txt* in the "train" directory.
	#
  trainTable <- read.table("./UCI HAR Dataset/train/X_train.txt", sep="")
	
	# Create a second data table from *X_test.txt* in the "test" directory.
	#
  testTable <- read.table("./UCI HAR Dataset/test/X_test.txt", sep="")
	
	# Combine the tables
	#
  CombinedDataSets <- rbind(trainTable, testTable)

  # read features.txt into a vector
  #
  colHeads <- as.character(read.table("./UCI HAR Dataset/features.txt")[2][,1])
    
  # rename columns of CombinedDataSets
  #
  names(CombinedDataSets) <- colHeads
  
  # Subset the columns containing data on mean and standard deviation
  #
  SelectedData <- CombinedDataSets[,grep(colnames(CombinedDataSets),pattern="*mean*|*std*")] 
  
  # Read the train activity identifiers into a list
  #
  trainActivity <- scan("./UCI HAR Dataset/train/y_train.txt")
  
  # Read the test activity identifiers to into a list
  # 
  testActivity <- scan("./UCI HAR Dataset/test/y_test.txt")

  # Combine the train and test
  #
  activity <- c(trainActivity, testActivity)

  # Replace the integer values in the activity list with the text equivalents 
  # as called out in *activity_labels.txt*
  #
  activityLabels <- scan("./UCI HAR Dataset/activity_labels.txt", what="character")
  activityTextValues <- activityLabels[c(2,4,6,8,10,12)]
  activity[activity == 1] <- "WALKING" 
  activity[activity == 2] <- "WALKING_UPSTAIRS"
  activity[activity == 3] <- "WALKING_DOWNSTAIRS"
  activity[activity == 4] <- "SITTING"
  activity[activity == 5] <- "STANDING"
  activity[activity == 6] <- "LAYING"

  # Bind the activities column to the table
  #
  ActivitiesSelectedData <- cbind(activity, SelectedData)

  # ... creates a second, independent tidy data set with the average of each variable for each activity and each subject.
  # Read the training subject identifiers into a list
  #
  trainingSubjIDs <- scan("./UCI HAR Dataset/train/subject_train.txt")
  
  # Read the test subject identifiers into a list
  #
  testSubjIDs <- scan("./UCI HAR Dataset/test/subject_test.txt")
  
  # Combine the two subject identifier vectors.
  subject <- c(trainingSubjIDs, testSubjIDs)
  
  # Bind the subjectIDs to the data table
  #
  Step.5.1.SelectedData <- cbind(subject,ActivitiesSelectedData)
  
  # Sort the data frame by subject, activity for ease of debugging later
  #
  Step.5.1.SelectedData <- Step.5.1.SelectedData[order(as.numeric(as.character(subject)), activity),]
  
  # Create a new data frame to hold the averages.
  # As there are 30 subjects and six activities, the data frame
  # containing the mean value for each measurement will have
  # 180 rows (6 x 30), and since I have identified 79 measures
  # to be reported, there will be 81 columns (i.e., subject + activity + 79 measures).
  #
  # Create vectors for the unique subject identifiers and the unique activity identifiers
  # 
  unique.subjects <- sort(unique(subject))
  unique.activities <- unique(activity)
  
  df.averages <- data.frame(matrix(NA, nrow=length(unique.subjects) * length(unique.activities), ncol=length(colnames(Step.5.1.SelectedData))))
  
  # Assign the same column names as Step.5.1.SelectedData
  #
  names(df.averages) <- names(Step.5.1.SelectedData)
   
  
  # I initialize a counter variable for looping through each
  # combination of subject and activity.

  row.counter <- 0
  
  for(s in 1:length(unique.subjects)){
    for(a in 1:length(unique.activities)){
      row.counter <- row.counter + 1
      df.averages[row.counter,1] <- unique.subjects[s]
      df.averages[row.counter,2] <- unique.activities[a]
      for(m in 3:81){
        df.averages[row.counter,m] <- mean(Step.5.1.SelectedData[,m][Step.5.1.SelectedData$subject == unique.subjects[s] & Step.5.1.SelectedData$activity == unique.activities[a]])
      }
    }
  }
  
  # This section deals with saving the data to a file.
  # If none of the optional parameters are provided when calling the function, 
  # this section will have no effect.
  #
  
  if(save.to.file == TRUE & file.path != ""){
    write.table(df.averages, file.path, row.name=FALSE)
  }else if(save.to.file == TRUE & file.path == ""){
    stop("You have asked to save the file, but failed to provide a file name and path.")
  }else if(save.to.file == FALSE & file.path != ""){
    stop("File path supplied, but save.to.file is set to FALSE.")
  }
  df.averages
}

