# Step 1: Read the dataset from Excel
library(readxl)
library(plm)
library(stargazer)

pol_data <- read_excel("...pol_data2.xlsx", sheet = "data")

############# Summary Statistics ##################
# Filter the dataset when pol variable is equal to 1
pol_data_pol_1 <- pol_data[pol_data$pol == 1, ]

# Summary statistics for numeric variables
summary_stats_numeric
