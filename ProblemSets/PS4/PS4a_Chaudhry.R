# PS4a_Chaudhry.R

#load file
system('wget -O dates.json "https://www.vizgr.org/historical-events/search.php?format=json&begin_date=00000101&end_date=20210219&lang=en"')
system('cat dates.json')	#Display the file

#Convet to dataframe
library(jsonlite)
library(tidyverse)
mylist <- fromJSON('dates.json')
mydf <- bind_rows(mylist$result[-1])

#Type of object
class(mydf)		#"tbl_df", "tbl", "data.frame"
class(mydf$date)	#"character"

#List first n rows
head(mydf)
head(mydf,10) #To display first 10 rows, for example
