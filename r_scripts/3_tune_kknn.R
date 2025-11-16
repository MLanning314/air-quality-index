# Final Project ----
# Define, Fit, and Tune Nearest Neighbor Model

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# random processes will be used so we have to set a seed
set.seed(0923)

## Load Data ----
load(here("data_splits/air_folds.rda"))

## Load Recipe ----
load(here("recipes/air_tree_recipe.rda"))

# use parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doMC::registerDoMC(cores = num_cores)

## Model Specifications ----
kknn_model <- nearest_neighbor(neighbors = tune()) |>
  set_engine("kknn") |>
  set_mode("regression")

## Define Workflow ----
kknn_workflow <-  workflow() |>
  add_model(kknn_model) |>
  add_recipe(air_tree_recipe)

## Create Tuning Grid ----

# hyperparameter tuning values
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(kknn_model)

#update the neighbors value to be 30
# chose this because I wanted it to be large enough to catch more than general trends
# but small enough to not miss details
kknn_parameters <- parameters(kknn_model) |>
  update(neighbors = neighbors(c(1, 30)))

# build tuning grid
kknn_grid <- grid_regular(kknn_parameters, levels = 5)

## Fit Nearest Neighbor Model ----

kknn_tuned <- 
  kknn_workflow |> 
  tune_grid(
    air_folds, 
    grid = kknn_grid, 
    control = control_grid(save_workflow = TRUE)
  )

# Save Fitted Nearest Neighbor Model ----
save(kknn_tuned, file = here("results/kknn_tuned.rda"))
save(kknn_workflow, file = here("results/kknn_workflow.rda"))

