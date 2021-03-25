##########################
#Name:  Ahmed Chaudhry
#PS#:   7
#Date:  March 25, 2021
##########################

library(tidyverse)
library(dplyr)
library(readr)
library(modelsummary)
library(mice)

#Q4
wages <- read_csv("ProblemSets/PS7/wages.csv")
datasummary_skim(wages, histogram=F,output="latex")

#Q5
wages <- wages %>% drop_na(logwage, hgc)


#Q6
datasummary_skim(wages, histogram=F,output="latex")


#Q7
wages <- read_csv("ProblemSets/PS7/wages.csv")

#Listwise Deletion
listwise_deletion <- lm(logwage ~ hgc + as.factor(college) + poly(tenure,2,raw=T)
           + age + as.factor(married), data=wages)

#Mean Imputation
wages <- wages %>% mutate(logwage2 = mean(wages$logwage, na.rm=T)) #1 way
wages <- wages %>% mutate(logwage3 = case_when(!is.na(logwage) ~ logwage, is.na(logwage) ~ logwage2))

mean_imputation <- lm(logwage3 ~ hgc + as.factor(college) + poly(tenure,2,raw=T)
                      + age + as.factor(married), data=wages)

#Regression imputation
pred.data = predict(mean_imputation, wages)

wages <- wages %>% mutate(logwage4 = case_when(!is.na(logwage) ~ logwage, is.na(logwage) ~ pred.data))

reg_imputation <- lm(logwage4 ~ hgc + as.factor(college) + poly(tenure,2,raw=T)
                      + age + as.factor(married), data=wages)

#Mice imputation
dat_imputed <- mice(wages, m = 10, printFlag = FALSE, seed = 1234, meth="norm.boot")

fit_mice <- with(dat_imputed, lm(logwage ~ hgc + as.factor(college) + poly(tenure,2,raw=T)
                  + age + as.factor(married)))

mice_imputation <- mice::pool(fit_mice)


#Model Summary
modelsummary(list(listwise_deletion, mean_imputation, reg_imputation, mice_imputation), output="latex")
