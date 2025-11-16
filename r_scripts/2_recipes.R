# Final Project ----
# Setup Pre-Processing/Recipes for Models

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts 
tidymodels_prefer()

## Load Data ----
load(here("data_splits/air_training.rda"))


## Creating Null Model Recipe ----
# null recipe with minimal preprocessing to act as a comparison with other models
air_null_recipe <- recipe(sqrt_aqi ~ ., data = air_training) |> 
  step_rm(date, aqi) |>
  step_dummy(all_nominal_predictors()) |>
  step_normalize(all_numeric_predictors()) 

# check to see if new recipe works
air_null_recipe |>
  prep() |>
  bake(new_data = slice_head(air_training, n = 100))
# seems to work well

## Creating Baseline Recipe ----
# baseline recipe with minimal preprocessing for our baseline linear regression model
air_baseline_recipe <- recipe(sqrt_aqi ~ ., data = air_training) |>
  step_rm(date, aqi) |> 
  step_impute_median(all_numeric_predictors()) |> 
  step_impute_mode(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())
# remove variables that would be poor predictors
# step impute for missing numeric values

# check to see if the new recipe works
air_baseline_recipe |>
  prep() |>
  bake(new_data = slice_head(air_training, n = 100))
# recipe appears to be successful!

## Creating Logistic Recipe ----

# first logistic recipe (kitchen sink)
air_lm_recipe <- recipe(sqrt_aqi ~ ., data = air_training) |>
  step_rm(date, aqi) |> 
  step_impute_median(all_numeric_predictors()) |> 
  step_impute_mode(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())
# I considered removing pm2_5 and pm10 because of their high correlation, but I decided against it
# because it did not change the rsq value by much for the baseline model


# check to see if the new recipe works
air_lm_recipe |>
  prep() |>
  bake(new_data = slice_head(air_training, n = 100))
# recipe appears to be successful!

## Creating Feature Engineered Logistic Recipe ----

air_lm_recipe_2 <- recipe(sqrt_aqi ~., data = air_training) |>
  step_rm(date, aqi) |> 
  step_impute_median(all_numeric_predictors()) |> 
  step_impute_mode(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors()) |> 
  step_interact(~ pm2_5:pm10) |>
  step_interact(~ no:no2:n_ox) |>
  step_interact(~ so2:co) |>
  step_interact(~benzene:toluene) |>
  step_interact(~o3:no2) |>
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())
# seeing interaction between different particulate matter sizes (pm2_5 and pm10)
# seeing interaction between different nitrous oxides (no and no2)
# seeing interaction between sulphur dioxide and co because of their high correlation
# seeing interaction between benzene and toluene because toluene is the only variable to 
# have a strong correlation with benzene
# seeing interaction between ozone and nitrous dioxide (o3 and no2) to see if they strongly
# relate to aqi (they are both strong components of pollution smog)

# check to see if the new recipe works
air_lm_recipe_2 |>
  prep() |>
  bake(new_data = slice_head(air_training, n = 100))
# recipe appears to be successful!

## Creating Tree-Based Recipe ----

# creating a basic tree recipe (similar to logistic recipe)
# using one hot dummy variables
air_tree_recipe <- recipe(sqrt_aqi ~., data = air_training) |>
  step_rm(date, aqi) |> 
  step_impute_median(all_numeric_predictors()) |> 
  step_impute_mode(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors())

# check to see if the new recipe works
air_tree_recipe |>
  prep() |>
  bake(new_data = NULL)
# recipe appears to be successful!


## Creating Feature Engineered Tree-Based Recipe ----
# this recipe is very similar to the feature engineered logistic recipe
# using one hot dummy variables
air_tree_recipe_2 <- recipe(sqrt_aqi ~., data = air_training) |>
  step_rm(date, aqi) |> 
  step_impute_median(all_numeric_predictors()) |> 
  step_impute_mode(all_nominal_predictors()) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |>
  step_interact(~ pm2_5:pm10) |>
  step_interact(~ no:no2) |>
  step_interact(~ so2:co) |>
  step_interact(~benzene:toluene) |>
  step_interact(~o3:no2) |>
  step_zv(all_predictors())

# check to see if the new recipe works
air_tree_recipe_2 |>
  prep() |>
  bake(new_data = NULL)
# recipe appears to be successful!

## Saving Recipes ----
# save out recipe
save(air_null_recipe, file = here("recipes/air_null_recipe.rda"))
save(air_baseline_recipe, file = here("recipes/air_baseline_recipe.rda"))
save(air_lm_recipe, file = here("recipes/air_lm_recipe.rda"))
save(air_lm_recipe_2, file = here("recipes/air_lm_recipe_2.rda"))
save(air_tree_recipe, file = here("recipes/air_tree_recipe.rda"))
save(air_tree_recipe_2, file = here("recipes/air_tree_recipe_2.rda"))
