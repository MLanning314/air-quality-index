# Final Project ----
# Fit baseline (Simple Regression) Model

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)


# handle common conflicts
tidymodels_prefer()

## Load Folded Data -----
load(here("data_splits/air_folds.rda"))

## Load Baseline Recipe ----
load(here("recipes/air_baseline_recipe.rda"))


# use parallel processing to speed up the modeling process with folds
num_cores <- parallel::detectCores(logical = TRUE)
doMC::registerDoMC(cores = num_cores)
# 8 cores currently being used to run models

### Model Specifications ----
baseline_model <- linear_reg() |> 
  set_mode("regression") |> 
  set_engine("lm")

### Define Workflow ----
baseline_workflow <- workflow() |>
  add_model(baseline_model) |>
  add_recipe(air_baseline_recipe)

### Fit Model ----
fit_baseline <- baseline_workflow |>
  fit_resamples(resamples = air_folds,
                control = control_resamples(save_workflow = TRUE))

### Save Fitted Baseline Model ----
save(fit_baseline, file = here("results/fit_baseline.rda"))
