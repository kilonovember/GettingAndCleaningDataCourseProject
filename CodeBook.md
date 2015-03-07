# Getting and Cleaning Data Class Project
This document, entitled "CodeBook.md" gives detailed instructions and 
explanations for preparing the assignment.



A group of 30 persons was divided into two groups. Each group performed the
same set of six actvities described in the researchers' paper as:

- WALKING
- WALKING_UPSTAIRS
- WALKING_DOWNSTAIRS
- SITTING
- STANDING
- LAYING

(note: Even native speakers of English have trouble with the distinction
between "lay", a transitive verb, and "lie" an instransitive verb. The 
authors of this study appear not to be native English speakers.)

The assignment instructions:

>You should create one R script called run_analysis.R that does the following. 
>
>1. Merges the training and the test sets to create one data set.
>2. Extracts only the measurements on the mean and standard deviation for each measurement.
>3. Uses descriptive activity names to name the activities in the data set
>4. Appropriately labels the data set with descriptive variable names. 
>
>From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

(further note: This is my second attempt at this course. I found this task too difficult to complete on time last month. After reflection, it came easier this time, and I am submitting it in the first week of the course. 

The instructions and the source material were not at all clear at first reading. A skeptic might be forgiven in concluding that either the task was deliberately designed to be incomprehensible, or that the researchers who prepared the orginal work gave no thought to any third party who might wish to analye their data.

So if this is your first attempt, it's not you, it's the material.)

**I found it convenient to alter the order of the steps. Don't let that throw you. Read down the file, taking the steps in the order presented rather than in numerical order.**

###Variable Names###

|Name             |Created on Line #|Decription                                    |Referred to on Line #|
|-----------------|     |-----------------|----------------------------------------------|---------------------|
|trainTable       |13               |a table to hold the data from X_train.txt        |21|
|testTable        |17               |a table to hold the data from X_test.txt         |21|
|CombinedDataSets |21               |a table to hold combined trainTable and testTable|29,33|
|colHeads         |25               |a table to hold the data from features.txt       |29|
|SelectedData     |33               |a subset of CombinedDataSets holding only columns with mean and standard deviation data|61|
|trainActivity    |37               |a vector to hold training activity identifiers   |45|
|testActivity     |41               |a vector to hold testing activity identifiers    |45|
|activity         |45               |a vector to hold the merged trainActivity and testActivity identifers|50,51,52,53,54,55|
|ActivitiesSelectedData|59          |a table comprised of the activity text values bound to the SelectedData table|75|
|trainingSubjIDs|64                 |a vector to hold the training subject identifiers|71|
|testSubjIDs    |68                 |a vector to hold the testing subject identifiers|71|
|subject        |71                 |a vector to hold the merged training and testing subject identifiers|75|
|Step.5.1.SelectedData|75           |a table comprised of the subject identifiers bound to the ActivitiesSelectedData table|79, 92,94,96,110|
|unique.subjects |89                |an ordered vector of subject identifiers|92,104,107,110|
|unique.activities|90               |an ordered vector of activitty identifiers|92,105,108,110|
|df.averages      |92               |a data frame to hold the tidy data set|96,107,108,110,121,125|
|row.counter      |102              |an iterator variable for populating df.averages|106,107,108,110|




## 1. Merges the training and the test sets to create one data set.

The first thing we need note is what a test or train set comprises.
A test or train set is comprised of three files:

- *X_test.txt*, *y_test.txt*,*subject_test.txt*
- *X_train.txt*, *y_train.txt*, *subject_train.txt*
 

These are located in the test and train directories.

*X_test.txt* or *X_train.txt* contains the bulk of the information. 

	Each has 561 columns of data on the direct *measurements* (e.g., tBodyAcc-max()-X, tBodyAcc-max()-	Y, tBodyAcc-max()-Z) and *statistics* computed from the measurements (e.g., tBodyAcc-mean()-X, 	tBodyAcc-mean()-Y, tBodyAcc-mean()-Z).
	It looks like this when viewed in a spreadsheet:

|                |                 |                |     |
|----------------|-----------------|----------------|-----|
|  2.8858451e-001| -2.0294171e-002 |-1.3290514e-001 | ... |  
|  2.7841883e-001| -1.6410568e-002 |-1.2352019e-001 | ... |
|  ...           |  ...            |  ...           | ... |
                                                     
Figure 1.

(The elipses represent the last 558 columns and the balance of the rows.)
	
	Each row contains data one one of the subjects performing one of the actvities at one attempt or trial.  So, which activity does each row correspond to and to which subject?

***y_test.txt* or *y_train.txt***

	This file contains the actiivty identifers for each row of the data in X_test.txt. Activity identifiers are integers identifying the the activities performed by each subject as recorded in each row of X_test.txt or X_train.txt. 
	It looks like this:
|   |
|---|
|  1|
|  1|
|...|		
|...|
|...|
|  6|

Figure 2.

(The elipses represent all the intervening *activity* idendifiers.)

The integers aren't enlightening, but they do correspond to the integers in the *activity_labels.txt* file (see below), so we will do a one-to-one mapping and extract the "Descriptions" strings and put them in the output table to make it less cryptic.

***activity_labels.txt***

	This file consists of two columns, one contains integers corresponding the the integers in *y_test.txt*, and the other contains the words describing the activity identified by the integer. So, in this file we find:
		
|ID|Description       |
|--|------------------|
|1 |WALKING           |
|2 |WALKING_UPSTAIRS  |
|3 |WALKING_DOWNSTAIRS|
|4 |SITTING           |
|5 |STANDING          |
|6 |LAYING            |

Figure 3.

	
### ***subject_test.txt* or *subject_train.txt***

	This file contains a list of integers identifying the subjects participating in the test and train groups.
	
	In other words, if we create a vector of the values in subject_test.txt, and create a second vector of the values in y_test.txt, then cbind() them into a table, looking down these columns we can see which subject-activity combination corresponds to a given row in X_test.txt. But hold off on merging the subject identifiers for now. That comes in part 4. 
	
	The list of subjects would look like this:
	

|   |
|---|
|  1|
|  1|
|  1|
|...|
|...|
|...|
| 30|

Figure 4.

(The elipses represent all the intervening *subject* idendifiers.)



### ***features.txt***

	The column headers for the columns in *X_test.txt* and *X_train.txt* are contained in a file named *features.txt*. The 561 items in this file are the text (i.e., the descriptions) of the values in the columns found in *X_test.txt* and *X_train.txt*.
	
|                   |
|-------------------|
|1 tBodyAcc-mean()-X|
|2 tBodyAcc-mean()-Y|
|2 tBodyAcc-mean()-Z|
|      ...          |

Figure 5.

(The elipsis once again standing in for the remaining values.)

### The result of merging the files will look like this:

|Subject|Activity|tBodyAcc-mean()-X|tBodyAcc-mean()-Y|tBodyAcc-mean()-Z| ...|
|-------|--------|-----------------|-----------------|-----------------|----|
|1      |WALKING |   2.8858451e-001| -2.0294171e-002 |-1.3290514e-001  | ...|
|1      |WALKING |   2.7841883e-001| -1.6410568e-002 |-1.2352019e-001  | ...|
|  ...  | ...    |  ...            |  ...            | ...             | ...|

Figure 6.

Working this part out from the scanty description in the source material took far longer than it should have done. We students spent a great deal of time agonizing over this, as evidenced by the discussion forum.


### Ready to Merge Test and Train Data Sets


First we read the X_test.txt and X_train.txt into data frames:

	> trainTable <- read.table("./train/X_train.txt", sep="")
	> testTable <- read.table("./test/X_test.txt", sep="")

That done, we next merge the two with an rbind() command:

	> CombinedDataSets <- rbind(trainTable, testTable)
This gives us a single table which looks like this.

|              V1|               V2|              V3| ... |
|----------------|-----------------|----------------|-----|
|  2.8858451e-001| -2.0294171e-002 |-1.3290514e-001 | ... |  
|  2.7841883e-001| -1.6410568e-002 |-1.2352019e-001 | ... |
|  ...           |  ...            |  ...           | ... |
                                                     
Figure 7.

At this point it will make the going easier if we rename the columns using the names from the *features.txt* file.

	> # read features.txt into a vector
	> colHeads <- read.table("features.txt")
	> # rename columns of CombinedDataSets
	> names(CombinedDataSets) <- colHeads
	
### Now CombinedDataSets will look like this:

|tBodyAcc-mean()-X |tBodyAcc-mean()-Y|tBodyAcc-mean()-Z| ... |
|------------------|-----------------|-----------------|-----|
|    2.8858451e-001| -2.0294171e-002 | -1.3290514e-001 | ... |  
|    2.7841883e-001| -1.6410568e-002 | -1.2352019e-001 | ... |
|    ...           |  ...            |   ...           | ... |

Figure 8.


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

After looking at the ***features.txt*** file, I identified these columns as being those of interest. Your mileage may vary.:

|   |                              |  |   |                              | 
|---|------------------------------|  |---|------------------------------| 
|  1|tBodyAcc-mean()-X             |  |254|tBodyGyroJerkMag-std()        | 
|  2|tBodyAcc-mean()-Y             |  |266|fBodyAcc-mean()-X             | 
|  3|tBodyAcc-mean()-Z             |  |267|fBodyAcc-mean()-Y             | 
|  4|tBodyAcc-std()-X              |  |268|fBodyAcc-mean()-Z             | 
|  5|tBodyAcc-std()-Y              |  |269|fBodyAcc-std()-X              | 
|  6|tBodyAcc-std()-Z              |  |270|fBodyAcc-std()-Y              | 
| 41|tGravityAcc-mean()-X          |  |271|fBodyAcc-std()-Z              | 
| 42|tGravityAcc-mean()-Y          |  |294|fBodyAcc-meanFreq()-X         | 
| 43|tGravityAcc-mean()-Z          |  |295|fBodyAcc-meanFreq()-Y         | 
| 44|tGravityAcc-std()-X           |  |296|fBodyAcc-meanFreq()-Z         | 
| 45|tGravityAcc-std()-Y           |  |345|fBodyAccJerk-mean()-X         | 
| 46|tGravityAcc-std()-Z           |  |346|fBodyAccJerk-mean()-Y         | 
| 81|tBodyAccJerk-mean()-X         |  |347|fBodyAccJerk-mean()-Z         | 
| 82|tBodyAccJerk-mean()-Y         |  |348|fBodyAccJerk-std()-X          | 
| 83|tBodyAccJerk-mean()-Z         |  |349|fBodyAccJerk-std()-Y          | 
| 84|tBodyAccJerk-std()-X          |  |350|fBodyAccJerk-std()-Z          | 
| 85|tBodyAccJerk-std()-Y          |  |373|fBodyAccJerk-meanFreq()-X     | 
| 86|tBodyAccJerk-std()-Z          |  |374|fBodyAccJerk-meanFreq()-Y     | 
|121|tBodyGyro-mean()-X            |  |375|fBodyAccJerk-meanFreq()-Z     | 
|122|tBodyGyro-mean()-Y            |  |424|fBodyGyro-mean()-X            | 
|123|tBodyGyro-mean()-Z            |  |425|fBodyGyro-mean()-Y            | 
|124|tBodyGyro-std()-X             |  |426|fBodyGyro-mean()-Z            | 
|125|tBodyGyro-std()-Y             |  |427|fBodyGyro-std()-X             | 
|126|tBodyGyro-std()-Z             |  |428|fBodyGyro-std()-Y             | 
|161|tBodyGyroJerk-mean()-X        |  |429|fBodyGyro-std()-Z             | 
|162|tBodyGyroJerk-mean()-Y        |  |452|fBodyGyro-meanFreq()-X        | 
|163|tBodyGyroJerk-mean()-Z        |  |453|fBodyGyro-meanFreq()-Y        | 
|164|tBodyGyroJerk-std()-X         |  |454|fBodyGyro-meanFreq()-Z        | 
|165|tBodyGyroJerk-std()-Y         |  |503|fBodyAccMag-mean()            | 
|166|tBodyGyroJerk-std()-Z         |  |504|fBodyAccMag-std()             | 
|201|tBodyAccMag-mean()            |  |513|fBodyAccMag-meanFreq()        | 
|202|tBodyAccMag-std()             |  |516|fBodyBodyAccJerkMag-mean()    | 
|214|tGravityAccMag-mean()         |  |517|fBodyBodyAccJerkMag-std()     | 
|215|tGravityAccMag-std()          |  |526|fBodyBodyAccJerkMag-meanFreq()| 
|227|tBodyAccJerkMag-mean()        |  |529|fBodyBodyGyroMag-mean()       | 
|228|tBodyAccJerkMag-std()         |  |530|fBodyBodyGyroMag-std()        | 
|240|tBodyGyroMag-mean()           |  |539|fBodyBodyGyroMag-meanFreq()   | 
|241|tBodyGyroMag-std()            |  |542|fBodyBodyGyroJerkMag-mean()   | 
|253|tBodyGyroJerkMag-mean()       |  |543|fBodyBodyGyroJerkMag-std()    | 
|   |                              |  |552|fBodyBodyGyroJerkMag-meanFreq()|

Figure 9.

What all these features have in common are these strings which identify them as pertaining to mean and standard deviation:

- mean
- std

I will use a regular expression function to pull only these columns.

	> SelectedData <- CombinedDataSets[,grep(colnames(CombinedDataSets),pattern="*mean*|*std*")]

This operation is dense with activity, so a little explanation is in order. Let's look at the inner-most part.

	colnames(CombinedDataSets): This function pulls all the column names from the data set into a vector.
	
Moving out, we get the the *grep()* function.

	grep(colnames(CombinedDataSets),pattern="*mean*|*std*"): grep() searches the column names, looking for those which contain either mean (*mean*) or standard deviation (*std*) in the string of characters comprising the name.
	
The outermost part subsets the data frame, selecting all rows from those columns whose names match the regular expression *pattern="*mean*|*std*"*

	CombinedDataSets[,grep(colnames(CombinedDataSets),pattern="*mean*|*std*")])

Our new object, SelectedData, looks like the table in Figure 8., except that it contains only those columns with mean and standard deviation data.


## 4. Appropriately labels the data set with descriptive variable names.

This was already accomplished in the step above immediately preceding Figure 8.



## 3. Uses descriptive activity names to name the activities in the data set

	# Read the train activity identifiers into a list
	> trainActivity <- scan("./train/y_train.txt")
	
	# Read the test activity identifiers to into a list
	> testActivity <- scan("./test/y_test.txt")

	# Combine the train and test
	> activity <- c(trainActivity, testActivity)

	
#### Replace the integer values in the activity list with the text equivalents as called out in *activity_labels.txt*

	> activity[activity == 1] <- "WALKING"
	> activity[activity == 2] <- "WALKING_UPSTAIRS"
	> activity[activity == 3] <- "WALKING_DOWNSTAIRS"
	> activity[activity == 4] <- "SITTING"
	> activity[activity == 5] <- "STANDING"
	> activity[activity == 6] <- "LAYING"

#### Bind the activities column to the table

	> ActivitiesSelectedData <- cbind(activity, SelectedData)

This results in a table with this appearance:

| activity   |tBodyAcc-mean()-X| tBodyAcc-mean()-Y |tBodyAcc-mean()-Z| ... |
|------------|-----------------|------------------|------------------|-----|
|STANDING    |   2.8858451e-001|   -2.0294171e-002|   -1.3290514e-001| ... |
|STANDING    |   2.7841883e-001|   -1.6410568e-002|   -1.2352019e-001| ... |
|STANDING    |     ...         |     ...          |      ...         | ... |
| ...        |     ...         |     ...          |      ...         | ... |

Figure 10.

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

	# Read the training subject identifiers into a list
	> trainingSubjIDs <- scan("./train/subject_train.txt")

	# Read the test subject identifiers into a list.
	> testSubjIDs <- scan("./test/subject_test.txt")

	# Combine the two subject identifier vectors.
	> subject <- c(trainingSubjIDs, testSubjIDs)

	# Bind the subjectIDs to the data table
	> Step.5.1.SelectedData <- cbind(subject,Activities-SelectedData)
	
	# Sort the data frame by subject, activity for ease of debugging later
	#
	> Step.5.1.SelectedData <- Step.5.1.SelectedData[order(as.numeric(as.character(subject)), activity),]


The data frame Step.5.1.SelectedData looks like this:

|subject  |activity    |tBodyAcc-mean()-X| tBodyAcc-mean()-Y|tBodyAcc-mean()-Z| ... |
|---------|------------|-----------------|------------------|-----------------|-----|
|1        |STANDING    |   2.8858451e-001|   -2.0294171e-002|  -1.3290514e-001| ... |
|1        |STANDING    |   2.7841883e-001|   -1.6410568e-002|  -1.2352019e-001| ... |
|1        |STANDING    |  2.7841883e-001 |   -1.6410568e-002|  -1.2352019e-001| ... |
| ...     | ...        |     ...         | ...              | ...             | ... |

Figure 11.

At this point, all the data which was supplied in pieces has been re-assembled into a single table. What remains is possibly the most challenging part, subsetting the data by subject and activity, computing the "average" (I'm going to assume that what's wanted is the mean of each activity's value.) the re-assembly the pieces once again into a single table.

The first question is, 

#####"Do I use a set-wise approach, keeping the spirit of delcarative programming, or do I use a set of nested for-loops, and go back to an imperative stye of programming?" #####

Well, maybe in a few months, but at this point I'm going to use an imperative style. I'll select a subset for each subject and activity, then compute the mean value for each measurement over the set of measurements for that activity for that subject.

First I'll create a new data frame to hold the data. This will have the same columns as *ActivitiesSelectedData* and one row for every unique combination of *subject* and *activity*.

	# Create a new data frame to hold the averages.
	> unique.subjects <- sort(unique(subject))
	> unique.activities <- unique(activity)
  
	> df.averages <- data.frame(matrix(NA, nrow=length(unique.subjects) * length(unique.activities), ncol=length(colnames(Step.5.1.SelectedData))))
  
	# Assign the same column names as Step.5.1.SelectedData
	#
	> names(df.averages) <- names(Step.5.1.SelectedData)

 I initialize a counter variable for looping through each combination of subject and activity. Then I loop through each measurement column and compute the mean of each subject/activity/measurement combination and update the value in the appropriate row/column.

	> row.counter <- 0
  
	> for(s in 1:length(unique.subjects)){
    	for(a in 1:length(unique.activities)){
      		row.counter <- row.counter + 1
      		df.averages[row.counter,1] <- unique.subjects[s]
      		df.averages[row.counter,2] <- unique.activities[a]
      		for(m in 3:81){
        		df.averages[row.counter,m] <- mean(Step.5.1.SelectedData[,m][Step.5.1.SelectedData$subject == unique.subjects[s] & Step.5.1.SelectedData$activity == unique.activities[a]])
      		}
    	}
	}




