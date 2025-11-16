# Final Project ----
# Training Final Model (Random Forest Model with Simple Tree Recipe)

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# random processes will be used so we have to set a seed
set.seed(0310)

# Load Training Data and Best Fitted Model ----
load(here("results/rf_tuned.rda"))
load(here("data_splits/air_training.rda"))

# use parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
doMC::registerDoMC(cores = num_cores)

# Define Workflow ----
final_workflow <- rf_tuned |> 
  extract_workflow(rf_tuned) |>  
  finalize_workflow(select_best(rf_tuned, metric = "rsq"))

# Fit Final Model ----
final_fit <- fit(final_workflow, air_training)

# save out final fit
save(final_fit, file = here("results/final_fit.rda"))
save(final_workflow, file = here("results/final_workflow.rda"))