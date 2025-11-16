# Final Project ----
# Define, Fit, and Tune Random Forest Model

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# random processes will be used so we have to set a seed
set.seed(6969)

## Load Data ----
load(here("data_splits/air_folds.rda"))

## Load Recipe ----
load(here("recipes/air_tree_recipe.rda"))

# use parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doMC::registerDoMC(cores = num_cores)

## Model Specifications ----
rf_model <- 
  rand_forest(trees = tune(), 
              min_n = tune(),
              mtry = tune()) |>
  set_engine("ranger") |>
  set_mode("regression")

## Define Workflow ----
rf_workflow <- workflow() |>
  add_model(rf_model) |>
  add_recipe(air_tree_recipe)

## Create Tuning Grid ----

# hyperparameter tuning values
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_model)

# change hyperparameter ranges to fit our needs
rf_parameters <- parameters(rf_model) |>
  update(mtry = mtry(c(1, 10)),
         trees = trees(c(250, 500)),
         min_n = min_n(c(2,30)))
# change mtry to be 10 because we do not have a huge number of parameters
# tried to keep the number of trees high but without diminishing returns
# wanted to make the minimum data points in a node not too high but high enough to
# improve the model - good for a medium dataset with low number of predictors

# build tuning grid
rf_grid <- grid_regular(rf_parameters, levels = 5)

## Fit Random Forest Model ----

rf_tuned <- 
  rf_workflow |> 
  tune_grid(
    air_folds, 
    grid = rf_grid, 
    control = control_grid(save_workflow = TRUE)
  )

# Save Fitted Random Forest Model ----
save(rf_tuned, file = here("results/rf_tuned.rda"))
save(rf_workflow, file = here("results/rf_workflow.rda"))
