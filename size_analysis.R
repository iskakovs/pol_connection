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

# Convert region and ind_code to factors
data$region <- as.factor(data$region)
data$ind_code <- as.factor(data$ind_code)

# Step 3: Run the regression
model <- lm(size_code ~ age + region + ind_code + pol, data = data)

# Step 4: Check the results
summary(model)

# Create the table using stargazer
stargazer(model, type = "text", out = "table.txt")

# Export the table to CSV format 
write.csv(summary(model), file = "table.csv", row.names = TRUE)

# Extract coefficients from the model summary 
coefficients <- coef(summary(model))

# Convert to data frame
coefficients_df <- as.data.frame(coefficients)
