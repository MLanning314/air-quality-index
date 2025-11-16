# Final Project ----
# Fit Null Model

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)


# handle common conflicts
tidymodels_prefer()

## Load Folded Data -----
load(here("data_splits/air_folds.rda"))

## Load Null Recipe ----
load(here("recipes/air_null_recipe.rda"))


# use parallel processing to speed up the modeling process with folds
num_cores <- parallel::detectCores(logical = TRUE)
doMC::registerDoMC(cores = num_cores)
# 8 cores currently being used to run models

## Model Specifications ----
null_model <- null_model() |> 
  set_mode("regression") |> 
  set_engine("parsnip")

## Define Workflow ----
null_workflow <- workflow() |>
  add_model(null_model) |>
  add_recipe(air_null_recipe)

## Fit Model ----
fit_null <- null_workflow |>
  fit_resamples(resamples = air_folds,
                control = control_resamples(save_workflow = TRUE))

## Save Fitted Baseline Model ----
save(fit_null, file = here("results/fit_null.rda"))
