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
