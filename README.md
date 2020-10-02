# TimeSeries 
This code was written to quickly generate a time series dataset given a series of repetitive files. 

In order for the output dataset to be correctly labeled by date, all files should be named in a 'YYYYMMDD' format. 
(Download example data to see this format)

Note that this code was built more for it's functionality rather than efficiency by a non-cs major student. 
 So long as the code is credited where appropriate, users of this are welcome to learn from, modify, and extract
 helpful sections of this code as they please. 
 
 Prior to running the code, it is important to set / modify the following: 
 
 Set your working directory to be the data containing folder. 
 
 Define your constants: 
 
filelist - specify what type of file(s) to import (.dbf, .txt, .csv)
timeseries_attribute - the column name of the attribute to keep and compare across time
key_attribute - the attribute that uniquely identifies each entity
add_attribute <- #an additional attribute that unique identifies each entity (this is not necessary and can be deleted if desired)
