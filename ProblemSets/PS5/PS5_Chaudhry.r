#######################
#PS5_Chaudhry.r
#######################

##Question No. 3

library(xml2)
library(tidyverse)
library(rvest)
library(polite)

m100 <- read_html("https://en.wikipedia.org/wiki/United_States_presidential_election") 
m100

us_elections_2020 <- 
  m100 %>%
  html_nodes("div.mw-parser-output > table:nth-child(188)") %>% ## select table element
  `[[` (1) %>%
  html_table(fill=TRUE)                                      ## convert to data frame
us_elections_2020

write.csv(us_elections_2020,file = "D:/Semester 4_Spring 21/ECON-5353 Data Science for Economists/ProblemSets/PS5/US_Presidential_Election_2020.csv",row.names = F)


##Question No. 4

library(tidyverse)
library(fredr)

incineq_CleavelandCountry_OK <- fredr(
  series_id = "2020RATIO040027",
  observation_start = as.Date("2010-01-01"),
  observation_end = as.Date("2019-01-01")
)
