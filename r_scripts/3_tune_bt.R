# Final Project ----
# Define, Fit, and Tune Boosted Tree Model

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# random processes will be used so we have to set a seed
set.seed(8888)

## Load Data ----
load(here("data_splits/air_folds.rda"))

## Load Recipe ----
load(here("recipes/air_tree_recipe.rda"))

# use parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doMC::registerDoMC(cores = num_cores)

## Model Specifications ----
bt_model <- boost_tree(
    trees = tune(),
    mtry = tune(),
    min_n = tune(),
    learn_rate = tune()) |>
  set_engine("xgboost") |>
  set_mode("regression")

## Define Workflow ----
bt_workflow <- workflow() |>
  add_model(bt_model) |>
  add_recipe(air_tree_recipe)

## Create Tuning Grid ----

# hyperparameter tuning values
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(bt_model)

# change hyperparameter ranges to fit our needs
bt_parameters <- parameters(bt_model) |>
  update(mtry = mtry(c(1,10)),
         min_n = min_n(c(2,30)),
         learn_rate = learn_rate(c(-5, -0.2)),
         trees = trees(c(250, 500)))
# change mtry to be 10 because we do not have a huge number of parameters
# tried to keep the number of trees high but without diminishing returns
# learn rate is on the log scale 
# wanted to make the minimum data points in a node not too high but high enough to
# improve the model - good for a medium dataset with low number of predictors

# build tuning grid
bt_grid <- grid_regular(bt_parameters, levels = 5)

## Fit Boosted Tree Model ----
tic()
bt_tuned <- 
  bt_workflow |> 
  tune_grid(
    air_folds, 
    grid = bt_grid, 
    control = control_grid(save_workflow = TRUE)
  )
toc()
# Save Fitted Boosted Tree Model ----
save(bt_tuned, file = here("results/bt_tuned.rda"))
save(bt_workflow, file = here("results/bt_workflow.rda"))


