# PS4b_Chaudhry.R

library(tidyverse)
library(sparklyr)
library(dplyr)

#Set up connection to Spark
spark_install(version = "3.0.0")
sc <- spark_connect(master = "local")

#Create tibble called df1 that loads iris data
df1 <- (as_tibble(iris))

#Copy tibble in Spark
df <- copy_to(sc, df1)

#Verify Types
class(df1)	#"tbl_df", "tbl", "data.frame"
class(df)	#"tbl_spark", "tbl_sql", "tbl_lazy", "tbl"

#Column Names

#RDD/SQL:select (List 1st 6 rows)
df %>% select(Sepal_Length,Species) %>% head %>% print

#RDD: filter (List 1st 6 rows when Speal_Length > 5.5)
df %>% filter(Sepal_Length>5.5) %>% head %>% print

df %>% select(Sepal_Length,Species) %>% filter(Sepal_Length>5.5) %>% head %>% print


#RDD: groupby (Average Sepal length + No. of obs)
df2 <- df %>% group_by(Species) %>% summarize(mean = mean(Sepal_Length), count = n()) %>% head %>% print

#RDD: sort
df2 <- df %>% group_by(Species) %>% summarize(mean = mean(Sepal_Length), count = n()) %>% head %>% print
df2 %>% arrange(Species) %>% head %>% print



