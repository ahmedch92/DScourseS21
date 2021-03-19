library(tidyverse)
library(dplyr)
library(readr)
library(ggplot2)
library(ggthemes)

cf_state <- read_csv("DONT MERGE/State_Campaign_Finance_Data.csv")
cf_state <- as_tibble(cf_state)

cf_state <- select(cf_state, -c(1,2,3,5,6,8)) #delete unnecessary columns

cf_state$contribution_amount <- "Total_$"/100000

cf_state <- cf_state %>% mutate(contribution_amount = `Total_$`/1000000)
#Write campaign contributions in $millions

cf_state <- cf_state %>% mutate(cf_state, contrib_senate = case_when(
  `General_Office`== "State Senate" ~ `contribution_amount`
)) #gen new var which contains contributions to State Senate Only

cf_state <- cf_state %>% mutate(cf_state, contrib_house = case_when(
  `General_Office`== "State House/Assembly" ~ `contribution_amount`
)) #gen new var which contains contributions to State House/Assembly Only


cf_state <- cf_state %>% 
  filter(cf_state, Election_Year = 1999 & Election_Year = 2001) %>%
  select(cf_state, c(1,2,3,4,5,6,7,8,9))

cf_state <- cf_state[!(cf_state$Election_Year==1999 | cf_state$Election_Year==2001
                     | cf_state$Election_Year==2003 | cf_state$Election_Year==2005
                     | cf_state$Election_Year==2007 | cf_state$Election_Year==2009
                     | cf_state$Election_Year==2011 | cf_state$Election_Year==2013
                     | cf_state$Election_Year==2015),]
#drop non-election years


ggplot(data=cf_state, aes(x=Election_Year, y=contrib_house)) + 
  geom_bar(stat="identity") + theme_minimal() +
  labs(y = "Campaign Contributions (Million USD)" , x = "Election Years") +
  ggtitle("Campaign Contributions to \n State House/Assembly Candidates \n by Year Totals (1998-2014)")

ggsave("PS6a_Chaudhry.png")


ggplot(data=cf_state, aes(x=Election_Jurisdiction, y=contrib_house)) + 
  geom_bar(stat="identity") + theme_minimal() +
  labs(y = "Campaign Contributions (Million USD)" , x = "State") +
  ggtitle("Campaign Contributions \n to State House/Assembly Candidates \n by States Totals (1998-2014)") + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 6))

ggsave("PS6b_Chaudhry.png")


ggplot(data=cf_state,aes(x=Election_Year, y=contrib_house)) + 
  geom_jitter(aes(color=(Election_Jurisdiction=="CA"))) + theme_minimal() +
  labs(y = "Campaign Contributions (Million USD)" , x = "Election Years") +
  ggtitle("Campaign Contributions to \n State House/Assembly Candidates \n by CA vs Other Stats")

ggsave("PS6c_Chaudhry.png")

