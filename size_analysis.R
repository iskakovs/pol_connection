#Install packages and libabries 
install.packages("stargazer")
library(stargazer)

# Install and load the writexl package 
install.packages("writexl")
library(writexl)

# Step 1: Read the dataset from Excel 
library(readxl)

data <- read_excel("...\\pol_data.xlsx", sheet = "data")

# Step 2: Prepare the data
# Convert reg_date to Date format 
data$reg_date <- as.Date(data$reg_date, format = "%d.%m.%Y")

# Calculate company age 
data$age <- as.numeric(format(Sys.Date(), "%Y")) - data$year
