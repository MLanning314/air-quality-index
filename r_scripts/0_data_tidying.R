# Final Project ----
# Data Tidying and Modification


## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)
library(naniar)
library(corrplot)

# handle common conflicts 
tidymodels_prefer()

## Load Data ----
air_data <- read_csv("data/city_day.csv") |>
  janitor::clean_names()

## Data Quality Check ----

dim(air_data)

# check for missingness in our dataset
skimr::skim_without_charts(air_data)

# visualize missingness in the dataset
missing_raw_data <- gg_miss_var(air_data) +
  labs(title = "Missing Data by Variable in the Raw Dataset",
       subtitle = "Almost every variable has significant missingness, specifically\nxylene and pm10",
       x = "Variable Name",
       y = "Number of Missing Values") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) 
ggsave("figures/appendix_eda_figure1.jpg", plot = missing_raw_data)
# there are some missing values for our outcome variable, but only around 15% - this is not
# ideal, but I do not think this should impact the data too severely

visdat::vis_miss(air_data)  
# all variables have above 75% of their observations other than the `xylene` variable
# xylene is missing over half the observations (61%) - probably should remove this variable

missing_raw_data <- colSums(is.na(air_data))
missing_raw_data |>
  knitr::kable()
# 4681 missing values for the outcome variable

# missingness for target variable specifically
skimr::skim_without_charts(air_data$aqi)

# create tibble of this information so I can format it into a nice dataset
missing_tv_table <- tibble(
  skim_variable = "data",
  n_missing = 4681,
  complete_rate = 0.841,
  mean = 166,
  sd = 141,
  p0 = 13,
  p25 = 81,
  p50 = 118,
  p75 = 208,
  p100 = 2049
)

# format the naniar missingness for the target variable into a nice table using kable()
missing_tv_table |>
  knitr::kable()

# missingness for target variable visualized in barplot
missing_tv_graph <- ggplot(air_data, aes(x = factor(is.na(aqi)))) + 
  geom_bar(aes(fill = factor(is.na(aqi)))) + 
  labs(x = "",
       y = "Count", 
       title = "Proportion of Missing Air Quality Index Observations",
       subtitle = "There are more observations present than missing") +
  scale_x_discrete(labels = c("Present", "Missing")) +
  scale_fill_manual(values = c("seagreen1", "red")) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5),
        panel.grid.major = element_blank(),  
        panel.grid.minor = element_blank()) +
  theme(legend.position = "none") 
ggsave("figures/missing_tv_graph.jpg", plot = missing_tv_graph)

# inspection of outcome variable distribution
# density graph
tva1 <- air_data |>
  filter(aqi < 500) |>
  ggplot(aes(x = aqi)) +
  geom_density() +
  labs(x = "AQI Value",
       y = "Density") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),  
       panel.grid.minor = element_blank())

# boxplot
tva2 <- air_data |>
  filter(aqi < 500) |>
  ggplot(aes(x = aqi)) +
  geom_boxplot() +
  theme_void()
# strong right skew - needs a log10 transformation

# create a nice plot using patchwork for a final figure
tv_distribution <- (tva2 / tva1) + 
  plot_layout(heights = c(1, 3)) + 
  plot_annotation(
    title = "Distribution of AQI",
    subtitle = "The distribution of AQI values has a significant right skew"
  ) & 
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5))
ggsave("figures/tv_distribution.jpg", plot = tv_distribution)

# inspection of outcome variable with log10 transformation
# density graph
tva_log1 <- air_data |>
  filter(aqi < 500) |>
  ggplot(aes(x = log10(aqi))) +
  geom_density() +
  labs(x = "AQI Value (Log10)",
       y = "Density") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),  
        panel.grid.minor = element_blank())
# log10 helps the skew, but it makes the distribution slightly bimodal - very small second peak
# so I think it should be okay, but might make it a little hard for linear regression models
# decision trees would probably be best model choice

# boxplot
tva_log2 <- air_data |>
  filter(aqi < 500) |>
  ggplot(aes(x = log10(aqi))) +
  geom_boxplot() +
  theme_void()
# still have some strong outliers, but on both sides, so I do not think the outliers will strongly
# influence prediction models

# create a nice figure using patchwork for final report
log_tv_distribution <- (tva_log2 / tva_log1) + 
  plot_layout(heights = c(1, 3)) + 
  plot_annotation(
    title = "Distribution of AQI with Log Transformation",
    subtitle = "The log transformation helps the symmetry of the air quality index distribution"
  ) & 
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5))
ggsave("figures/log_tv_distribution.jpg", plot = log_tv_distribution)

# inspection of outcome variable with sqrt transformation
# density graph
tva_sqrt1 <- air_data |>
  filter(aqi < 500) |>
  ggplot(aes(x = sqrt(aqi))) +
  geom_density() +
  labs(x = "AQI Value (SQRT)",
       y = "Density") +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),  
        panel.grid.minor = element_blank())

#boxplot
tva_sqrt2 <- air_data |>
  filter(aqi < 500) |>
  ggplot(aes(x = sqrt(aqi))) +
  geom_boxplot() +
  theme_void()

# create a nice figure using patchwork for final report
sqrt_tv_distribution <- (tva_sqrt2 / tva_sqrt1) + 
  plot_layout(heights = c(1, 3)) + 
  plot_annotation(
    title = "Distribution of AQI with Square Root Transformation",
    subtitle = "The square root transformation helps the symmetry of the air quality index"
  ) & 
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5))
ggsave("figures/sqrt_tv_distribution.jpg", plot = sqrt_tv_distribution)


## Complete Correlation Matrix for Predictors ----
# compute correlation matrix (excluding non-numeric columns)
correlation_matrix <- cor(air_data %>% select(where(is.numeric)), use = "complete.obs")
correlation_matrix |>
  knitr::kable()
# pm2_5 is 92% correlated
# pm10 is 91% correlated
# everything else is less than 60% correlated and should be okay


# visualize the correlation matrix
corrplot(correlation_matrix, method = "color", type = "upper", tl.cex = 0.8, order = "hclust")

# it seems that pm2_5 and pm10 are pretty highly correlated with our outcome variable
# need to be cautious of this when constructing our models to ensure this doesn't influence performance metrics

# examine the aqi_bucket variable to properly convert it to a factor
n_distinct(air_data$aqi_bucket)
# 7 distinct levels for the new factor

unique(air_data$aqi_bucket)
# NA, poor, very poor, severe, moderate, satisfactory, good


## Clean Data ----

# filter any aqi values above 500 because that is not reasonable (500 is the highest it can be)
# square root transform outcome variable
# rename confusing variables
# change binary variables to factors
# remove the `xylene` variable
# remove missing values for the aqi_category variable because they are the same missing values as
# aqi - we ideally want no missing values for our target variable, so this works out

air_clean <- air_data |>
  filter(aqi < 500) |>
  mutate(sqrt_aqi = sqrt(aqi)) |>
  rename(aqi_category = aqi_bucket) |>
  mutate(aqi_category = factor(aqi_category, 
                               levels = c("Very Poor", "Poor", "Moderate", 
                                          "Satisfactory", "Good", "Severe"),
                               ordered = TRUE)) |>
  select(-xylene) |>
  filter(!is.na(aqi_category))

str(air_clean)

dim(air_clean)
# 24305 rows 16 variables

# write/save new dataset
write_csv(air_clean, "data/air_clean.csv")

# check for missingness in our dataset
skimr::skim_without_charts(air_clean)
# pm2_5, pm10, and nh3 have large missingness, but everything else only has 15 and everything is above 75%

# visualize missingness in the clean dataset
missing_clean_data <- gg_miss_var(air_clean) +
  labs(title = "Missing Data by Variable in the Clean Dataset",
       subtitle = "There is less missingness in the clean dataset, but\npm10, nh3, and toulene have large missingness",
       x = "Variable Name",
       y = "Number of Missing Values") +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) 
ggsave("figures/missing_clean_data.jpg", plot = missing_clean_data)

## Creating and Saving Codebook ----
# Define the metadata for the codebook
air_clean_codebook <- data.frame(
  Variable = c("city", "date", "pm2_5", "pm10", "no", "no2", "n_ox", "nh3", "co", "so2",
               "o3", "benzene", "toulene", "aqi", "aqi category", "sqrt_aqi"),
  Description = c(
    "City in which the air quality data was collected (all cities are found in India)",
    "Date when the air quality data was collected written in yyyy-mm-dd format",
    "Measurement of PM 2.5 (micrometer in ug / m3) - fine particulant matter made up of particles that are 2.5 micrometers or less in diameter",
    "Measurement of PM 10 (micrometer in ug / m3) - fine particulant matter made up of particles that are 10 micrometers or less in diameter",
    "Measurement of nitric oxide (ug / m3)",
    "Measurement of nitric dioxide (ug / m3)",
    "Measurement of any nitric x-oxide (parts per billion - ppb)",
    "Measurement of ammonia (ug / m3)",
    "Measurement of carbon monoxide (mg / m3)",
    "Measurement of sulphur dioxide (ug / m3)",
    "Measurement of ozone (ug / m3)",
    "Measurement of benzene (ug / m3)",
    "Measurement of toulene (ug / m3)",
    "Air Quality Index value (ranges from 0-300+)",
    "Categorization of the AQI value where values of 0-50 are considered `Good`, 51-100 are considered `Moderate`, 101-150 are considered `Unhealthy for Sensitive Groups`, 151-200 are considered `Unhealthy`, 201-300 are considered `Very Unhealthy`, and 300+ are considered `Hazardous`",
    "Air Quality Index Value on the square root scale"))
    

# Write and save codebook as a csv
write.csv(air_clean_codebook, "data/air_clean_codebook.csv", row.names = FALSE)



