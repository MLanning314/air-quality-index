# Final Project ----
# Define, Fit, and Tune Ridge Model

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# random processes will be used so we have to set a seed
set.seed(0102)

## Load Data ----
load(here("data_splits/air_folds.rda"))

## Load Recipe ----
load(here("recipes/air_lm_recipe.rda"))

# use parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doMC::registerDoMC(cores = num_cores)

## Model Specifications ----
ridge_model <- linear_reg(penalty = tune(), 
                          mixture = 0) |> 
  set_engine("glmnet") |> 
  set_mode("regression")

## Define Workflow ----
ridge_workflow <- workflow() |> 
  add_model(ridge_model) |> 
  add_recipe(air_lm_recipe)

## Create Tuning Grid ----

# hyperparameter tuning values
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(ridge_model)

# no need to change hyperparameter values
ridge_parameters <- parameters(ridge_model)

# build tuning grid
ridge_grid <- grid_regular(ridge_parameters, levels = 5)

## Fit Ridge Model ----

ridge_tuned <- 
  ridge_workflow |> 
  tune_grid(
    air_folds, 
    grid = ridge_grid, 
    control = control_grid(save_workflow = TRUE)
  )

# Save Fitted Ridge Model ----
save(ridge_tuned, file = here("results/ridge_tuned.rda"))
save(ridge_workflow, file = here("results/ridge_workflow.rda"))

