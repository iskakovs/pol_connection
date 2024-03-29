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

# Define ID variables (variables that remain unchanged during reshaping)
id_vars <- c("region", "pol", "age", "ind_code", "size_code")

# Melt the dataset to long format
melted_data <- melt(pol_data, id.vars = id_vars, 
                    variable.name = "year", value.name = "tax_paid" 
                    measure.vars = c("tax2019", "tax2020", "tax2021", "tax2022", "tax2023"))

# Convert year to numeric
melted_data$year <- as.numeric(gsub("tax", "", melted_data$year))

# Now 'melted_data' contains the dataset in long format suitable for panel data analysis

# Add a small constant to tax_paid to avoid zero and negative values
epsilon <- 1e-10
melted_data$tax_paid_pos <- melted_data$tax_paid + epsilon

# Convert tax_paid to logged variable
melted_data$log_tax_paid <- log(melted_data$tax_paid_pos)

# Now 'melted_data' contains the logged tax_paid variable

# Load necessary packages
library(plm)

# Let's balance the data
# Create a unique firm identifier
melted_data$firm_id <- paste0(melted_data$region, "-", melted_data$ind_code, "-", melted_data$size_code)

# Using assignment operator
melted_data$log_tax_paid[is.na(melted_data$log_tax_paid)] <- 0

#OLS Model
ols_model <- lm(log_tax_paid ~ region + pol + age + ind_code + size_code, data = melted_data)

# Fixed Effects Model
fe_model <- plm(log_tax_paid ~ region + pol + age + ind_code + size_code, 
                data = melted_data, index = c("firm_id", "year"), model = "within")

# Random Effects Model
re_model <- plm(log_tax_paid ~ region + pol + age + ind_code + size_code, 
                data = melted_data, index = c("firm_id", "year"), model = "random")

# Compare FE and RE models using Hausman test
hausman_test <- phtest(fe_model, re_model)

# Print results
summary(ols_model)
summary(fe_model)
summary(re_model)
print(hausman_test)

# Print out the summary table using stargazer
stargazer(ols_model, fe_model, re_model, type = "text", out = "three_models.txt")
