# GettingAndCleaningDataCourseProject
For the Getting and Cleaning Data Course Project

This project was completed in a single function. It was not intended for re-use, so I saw no value in breaking the various parts into separate functions.

You can execute the function by entering run_analysis() in your R console or RStudio.
The function is coded with the assumption that your data will be contained in a sub-directory one level below your working directory. That sub-directory is expected to be named "UCI HAR Dataset". If you followed the project instructions, that will be the name of the directory which contains all the data needed to execute the function.

The function has two optional parameters:
  
  o save-to-file is set by default to FALSE
  
  o file.path is set by default to tidy-data.txt
  
If you wish to save the file to the default file, enter save-to-file=TRUE in the function's signature.
Likewise, you can change the file path and name by entering a filepath/name combination as the value of the file.path parameter.
