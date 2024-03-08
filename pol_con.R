# Step 1: Read the dataset from Excel
library(readxl)
library(plm)
library(stargazer)

pol_data <- read_excel("...pol_data2.xlsx", sheet = "data")

############# Summary Statistics ##################
# Filter the dataset when pol variable is equal to 1
pol_data_pol_1 <- pol_data[pol_data$pol == 1, ]

# Summary statistics for numeric variables
summary_stats_numeric <- summary(pol_data_pol_1)

# Frequency counts for categorical variables
summary_stats_categorical <- lapply(pol_data_pol_1, table)

# Convert list of frequency counts to data frame
summary_stats_categorical_df <- as.data.frame(do.call(cbind, summary_stats_categorical))

# Make sure the number of rows match
min_rows <- min(nrow(summary_stats_numeric), nrow(summary_stats_categorical_df))
summary_stats_numeric <- summary_stats_numeric[1:min_rows, ]
summary_stats_categorical_df <- summary_stats_categorical_df[1:min_rows, ]

# Create summary statistics table
summary_table <- cbind(summary_stats_numeric, summary_stats_categorical_df, check.names = FALSE)

# Print summary table
print(summary_table)

install.packages("openxlsx")
library(openxlsx)

# Save summary table as Excel file
write.xlsx(summary_table, "summary_statistics_pol_1.xlsx")

############ Log of Taxes Paid and Political Connection Regression ###########
# Convert tax variables to numeric
tax_cols <- c("tax2019", "tax2020", "tax2021", "tax2022", "tax2023")
pol_data[tax_cols] <- lapply(pol_data[tax_cols], as.numeric)

# Handle zero values in tax variables
epsilon <- 1e-10  # Small constant to add to avoid taking logarithm of zero
pol_data[tax_cols][pol_data[tax_cols] == 0] <- epsilon

# Convert ind_code to a factor
pol_data$ind_code <- as.factor(pol_data$ind_code)

# Compute logarithm of taxes paid
log_tax_cols <- paste0("log_", tax_cols)
pol_data[log_tax_cols] <- log(pol_data[tax_cols])

# Run the regression to check how political connection contributed to firm's performance in 2023
model2023 <- lm(log_tax2023 ~ age + pol + ind_code + size_code, data = pol_data)

# Print the summary of the model
summary(model2023)

# Create the table using stargazer
stargazer(model2023, type = "text", out = "table2023.txt")

# Run the regression to check how political connection contributed to the Covid-19 resistance
model2020 <- lm(log_tax2020 ~ age + pol + ind_code + size_code, data = pol_data)

# Print the summary of the model
summary(model2020)

### Next analysis - PANEL DATA analysis

# Load necessary packages
library(reshape2)
