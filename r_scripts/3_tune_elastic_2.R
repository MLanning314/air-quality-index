# Final Project ----
# Define, Fit, and Tune Elastic Net Model with Feature Engineering Recipe

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

## Load Data ----
load(here("data_splits/air_folds.rda"))

## Load Recipe ----
load(here("recipes/air_lm_recipe_2.rda"))

# use parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doMC::registerDoMC(cores = num_cores)

## Model Specifications ----
elastic_model <- 
  linear_reg(penalty = tune(),
             mixture = tune()) |> 
  set_engine("glmnet") |> 
  set_mode("regression") 

## Define Workflow ----
elastic_workflow_2 <- workflow() |>
  add_model(elastic_model) |>
  add_recipe(air_lm_recipe_2)

## Create Tuning Grid
# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(elastic_model)

# no need to update default hyperparameters
elastic_parameters <- parameters(elastic_model)

# build tuning grid
elastic_grid <- grid_regular(elastic_parameters, levels = 5)
elastic_grid
# fit workflows/models ----


elastic_tuned_2 <- 
  elastic_workflow_2 |> 
  tune_grid(
    air_folds, 
    grid = elastic_grid, 
    control = control_grid(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(elastic_tuned_2, file = here("results/elastic_tuned_2.rda"))
save(elastic_workflow_2, file = here("results/elastic_workflow_2.rda"))
