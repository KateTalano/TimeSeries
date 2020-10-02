
# Working With Time Series Data

# Creator: Kate Talano
# Date: September 2020

#This code was written to quickly build a time series dataset given a series of repetitive files. 
#In order for the output dataset to be correctly labeled by date, all files should be named in a 'YYYYMMDD' format. 
# Note that this code was built by a non-cs major, and therefore focuses on functionality rather than code efficiency. 
# So long as the code is credited where appropriate, users of this are welcome to learn from, modify, and extract
# helpful sections of code as they please. 

#SECTION 1: Setting up Your Workspace

# Set WORKING DIRECTORY
setwd("") #Set Working Directory (this should be the folder under which the datafiles are stored)

#Import Required R Packages
require("foreign")
require("purrr")
require("magrittr")
require("dplyr")
require("tidyverse")
library(readr)

# Define CONSTANTS
filelist <-list.files(pattern="*.dbf") #specify what type of file(s) to import (.dbf, .txt, .csv)
timeseries_attribute <- "T_positive" #the column name of the attribute to keep and compare across time
key_attribute <- "COUNTY" #the attribute that uniquely identifies each entity
add_attribute <- "COUNTYNAME" #an additional attribute that unique identifies each entity


#Define FUNCTIONS

# Opens a file, strips it to only contain the attributes specified, and renames 
# the timeseries attribute to be a date code "_YYYMMDD", using the file's name
# Args:
#   file: .dbf file path
#   key_attribute: identifying variable
#   add_attribute: 2nd identifying variable
#   timeseries_attribute: name of column attribute to keep
#
# Returns a cleaned dataframe 

strip_data <- function(file, timeseries_attribute, key_attribute, add_attribute){
  readfile <- read.dbf(file, as.is=FALSE)
  filecode <- str_sub(file,-8,-5) #(-) starts indexing from end
  df <- readfile[,c(key_attribute, add_attribute, timeseries_attribute), drop=FALSE]
  names(df)[names(df)==timeseries_attribute]<- paste("_",filecode) #changes the name of the timeseries attribute to be "_YYYMMDD"
  return(df)
}


# Builds a joined dataframe given a list of files, and the column to keep
# Args:
#   filelist: list of .dbf files
#   timeseries_attribute: name of column attribute to keep
#
# Returns a joined dataframe, and prints a list of 
#the filenames in which the column does not exist

build_dataset <- function(filelist, timeseries_attribute, key_attribute, add_attribute){
  for (f in filelist){ #for each file in the filelist
    readfile <- read.dbf(f) #opens the file
    if(c(timeseries_attribute) %in% names(readfile)){ #checks to see if the attribute we are interested in exists within the file
      if (!exists("dataset")){ #this creates the dataset if it doesn't yet exist using the output of the "strip_data" function
        dataset <- strip_data(f,timeseries_attribute, key_attribute, add_attribute) 
      }
      else{ #this appends data to the dataset 
        temporary_dataset <- strip_data(f,timeseries_attribute, key_attribute, add_attribute)
        dataset <- left_join(dataset, temporary_dataset, by= c(key_attribute, add_attribute)) #appends the new column of data by the unique identifiers
        rm(temporary_dataset) #clears the variable so it can be reused
      }
    }
    else{
      print(f)
    }
  }
  return(dataset)
}


#SECTION 2: Working Code
timeseries_dataset <- build_dataset(filelist,timeseries_attribute, key_attribute, add_attribute)

#SECTION 3: Export dataset to a .csv
write.table(timeseries_dataset, file=(".csv"), row.names=F, sep=",") #Export dataset to a .csv, write out desire pathname of the file
