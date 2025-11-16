# Final Project ----
# Data splitting and folding

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts 
tidymodels_prefer()

## Load Data ----
air_clean <- read_csv("data/air_clean.csv")

## Split Data ----
# we will be using a random process to split the data, so we will need to set a seed
set.seed(0416)

# initially split the data into 80% training and 20% testing
# use stratified sampling
air_split <- initial_split(air_clean, prop = 0.8, strata = sqrt_aqi)

# split into training and testing datasets for modeling
air_training <- air_split |>
  training()
air_testing <- air_split |> 
  testing()

# check dimensions to ensure the datasets were split correctly
dim(air_training) # 19441 rows - around 80%
dim(air_testing) # 4864 rows - around 20%

## Fold Data (V-Fold Cross-Validation) ----

# performing v-fold cross-validation as a resampling technique
# this will ensure more reliable performance estimates of our model
# this can also reduce errors with data imbalance, so is important for us specifically
# choosing 10 folds and 5 repeats

air_folds <- vfold_cv(air_training, v = 10, repeats = 5, strata = sqrt_aqi)

## Saving New Datasets ----
save(air_split, file = here("data_splits/air_split.rda"))
save(air_training, file = here("data_splits/air_training.rda"))
save(air_testing, file = here("data_splits/air_testing.rda"))
save(air_folds, file = here("data_splits/air_folds.rda"))


