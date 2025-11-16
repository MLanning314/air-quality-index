# Final Project ----
# Define, Fit, and Tune Ridge Model with Feature Engineering

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# random processes will be used so we have to set a seed
set.seed(0104)

## Load Data ----
load(here("data_splits/air_folds.rda"))

## Load Recipe ----
load(here("recipes/air_lm_recipe_2.rda"))

# use parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doMC::registerDoMC(cores = num_cores)

## Model Specifications ----
ridge_model <- linear_reg(penalty = tune(), 
                          mixture = 0) |> 
  set_engine("glmnet") |> 
  set_mode("regression")

## Define Workflow ----
ridge_workflow_2 <- workflow() |> 
  add_model(ridge_model) |> 
  add_recipe(air_lm_recipe_2)

## Create Tuning Grid ----

# hyperparameter tuning values
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(ridge_model)

# no need to change hyperparameter values
ridge_parameters <- parameters(ridge_model)

# build tuning grid
ridge_grid <- grid_regular(ridge_parameters, levels = 5)

## Fit Ridge Model ----

ridge_tuned_2 <- 
  ridge_workflow_2 |> 
  tune_grid(
    air_folds, 
    grid = ridge_grid, 
    control = control_grid(save_workflow = TRUE)
  )

# Save Fitted Ridge Model ----
save(ridge_tuned_2, file = here("results/ridge_tuned_2.rda"))
save(ridge_workflow_2, file = here("results/ridge_workflow_2.rda"))

