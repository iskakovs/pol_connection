#Install packages and libabries 
install.packages("stargazer")
library(stargazer)

# Install and load the writexl package 
install.packages("writexl")
library(writexl)

# Step 1: Read the dataset from Excel
library(readxl)

data <- read_excel("C:\\Users\\777\\Desktop\\pol_data.xlsx", sheet = "data")
