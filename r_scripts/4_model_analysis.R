# Final Project ----
# Analysis of Models

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

## Load Data and Trained Workflows ----
load(here("results/fit_null.rda"))
load(here("results/fit_baseline.rda"))
load(here("results/ridge_tuned.rda"))
load(here("results/ridge_tuned_2.rda"))
load(here("results/elastic_tuned.rda"))
load(here("results/elastic_tuned_2.rda"))
load(here("results/kknn_tuned.rda"))
load(here("results/kknn_tuned_2.rda"))
load(here("results/rf_tuned.rda"))
load(here("results/rf_tuned_2.rda"))
load(here("results/bt_tuned.rda"))
load(here("results/bt_tuned_2.rda"))

## Performance Metrics for Fitted Models ----
# obtain null model performance metrics
null_metrics <- fit_null |>
  collect_metrics() |>
  mutate(model = "Null Model") |>
  filter(.metric == "rmse")
null_metrics

# obtain baseline linear regression performance metrics
baseline_metrics <- fit_baseline |>
  collect_metrics() |>
  mutate(model = "Simple Linear Regression Model") |>
  filter(.metric == "rsq")
baseline_metrics


## Visual Inspection of Tuned Models ----

# ridge model
ridge_autoplot <- autoplot(ridge_tuned, metric = "rsq")
ggsave("figures/ridge_autoplot.jpg", plot = ridge_autoplot)
# model performance decreases with an increase in the amount of regularization 
# the model seems to perform the same until around 1e-02 regularization when it falls off to
# an RSQ of less than 0.91
# at the best, the model has an RSQ of around 0.930

# ridge model with feature engineering
ridge_autoplot_fe <- autoplot(ridge_tuned_2, metric = "rsq")
ggsave("figures/ridge_autoplot_fe.jpg", plot = ridge_autoplot_fe)
# model performance decreases with an increase in the amount of regularization
# the model performs well until a regularization of before 1e-02 regularization but then
# decreases to an RSQ of 0.905
# at the best, the model has an RSQ of above 0.930

# elastic model
elastic_autoplot <- autoplot(elastic_tuned, metric = "rsq")
ggsave("figures/elastic_autoplot.jpg", plot = elastic_autoplot)
# model performance seems to decrease with an increase in regularization and lasso proportion
# all models perform the same until around 1e-02 regularization when they begin to fall off
# model with lasso proportion of 1.000 has the lowest RSQ of 0.75 and 
# the model with lasso proportion of 0.0500 has the highest performance with 0.90

# elastic model with feature engineered recipe
elastic_autoplot_fe <- autoplot(elastic_tuned_2, metric = "rsq")
ggsave("figures/elastic_autoplot_fe.jpg", plot = elastic_autoplot_fe)
# this plot looks very similar to the elastic net model with the simple linear regression recipe
# all models perform the same until a little before 1e-02 regularization when they all decrease
# the model with lasso proportion of 1.000 has lowest RSQ of 0.75 and 
# the model with lasso proportion 0.0500 has the highest performance of over 0.90

# nearest neighbor model
kknn_autoplot <- autoplot(kknn_tuned, metric = "rsq")
ggsave("figures/kknn_autoplot.jpg", plot = kknn_autoplot)
# model performance seems to improve as neighbors increase until around 15 neighbors when
# it begins to decrease as neighbors increase - seems our parameters have done a good
# job of capturing the peak neighbor value
# the highest value seen in the model is over 0.96, which is really good!!

# nearest neighbor model with feature engineering
kknn_autoplot_fe <- autoplot(kknn_tuned_2, metric = "rsq")
ggsave("figures/kknn_autoplot_fe.jpg", plot = kknn_autoplot_fe)
# this plot is almost identical to the nearest neighbor model with the simple linear tree
# has an increase in performance with increase in neighbors until 15 when increasing
# neighbors begins to have a negative impact on model performance 
# the highest value in the model is over 0.96, like the last model, which is a great RSQ


# random forest model
rf_autoplot <- autoplot(rf_tuned, metric = "rsq")
ggsave("figures/rf_autoplot.jpg", plot = rf_autoplot)
# all the plots seem very similar - minimal node size does not seem to have a huge impact
# as the number of randomly selected predictors increases, RSQ increases
# the number of trees does not seem to have a huge impact either - all the models overlap
# from this plot it seems the best is min_n = 2 and trees = 500, and mtry = 10
# the trees seem to level off, but may continue to increase - 500 might be too low 

# random forest model with feature engineering
rf_autoplot_fe <- autoplot(rf_tuned_2, metric = "rsq")
ggsave("figures/rf_autoplot_fe.jpg", plot = rf_autoplot_fe)
# this looks very simple to the random forest autoplot using the simple tree recipe
# does not seem like the number of trees impacts RSQ - same with minimal node size
# mtry definitely has an impact - an increase in mtry means an increase in RSQ
# same issue with trees - the graph levels off so maybe a value of 750 or 100 would be better?

# boosted tree model
bt_autoplot <- autoplot(bt_tuned, metric = "rsq")
ggsave("figures/bt_autoplot.jpg", plot = bt_autoplot)
# this graph is very hard to interpret and it seems as most graphs level off towards the end
# seems like a smaller minimum node size is the best
# learn rate of 0.0398 seems to be the best regardless of minimum node size
# tree size does not seem to impact RSQ - all the lines overlap after a mtry value of 6
# (before that some of the tree sizes differ marginally)
# mtry impacts RSQ - as mtry increases so does rsq

# boosted tree model with feature engineering
bt_autoplot_fe <- autoplot(bt_tuned_2, metric = "rsq")
ggsave("figures/bt_autoplot_fe.jpg", plot = bt_autoplot_fe)
# this plot looks almost identical to the boosted tree on simple tree recipe 
# seems like a smaller minimum node size is the best
# learn rate of 0.0398 seems to be the best regardless of minimum node size
# tree size does not seem to impact RSQ - all the lines overlap after a mtry value of 6
# (before that some of the tree sizes differ marginally)
# mtry impacts RSQ - as mtry increases so does rsq


## Select Best Hyperparameters for Tuned Models ----
# use select_best to find best hyperparameters for each model

# ridge model
ridge_best <- select_best(ridge_tuned, metric = "rsq") |>
  mutate(.config = "Simple Linear Regression")
# penalty = 1e-10

# ridge model with feature engineering
ridge_fe_best <- select_best(ridge_tuned_2, metric = "rsq") |>
  mutate(.config = "Feature Engineering")
# penalty = 1e-10

# elastic model
elastic_best <- select_best(elastic_tuned, metric = "rsq") |>
  mutate(.config = "Simple Linear Regression")
# penalty: 1e10, mixture: 0.288

# elastic model with feature engineered recipe
elastic_fe_best <- select_best(elastic_tuned_2, metric = "rsq") |>
  mutate(.config = "Feature Engineering")
# penalty: 1e10, mixture: 0.525

#nearest neighbor
kknn_best <- select_best(kknn_tuned, metric = "rsq") |>
  mutate(.config = "Simple Tree")
# neighbors = 15

# nearest neighbor with feature engineering
kknn_fe_best <- select_best(kknn_tuned, metric = "rsq") |>
  mutate(.config = "Feature Engineering")
# neighbors = 15

# random forest
rf_best <- select_best(rf_tuned, metric = "rsq") |>
  mutate(.config = "Simple Tree")
# mtry = 10, trees = 500, min_n = 2

# random forest with feature engineering
rf_fe_best <- select_best(rf_tuned_2, metric = "rsq") |>
  mutate(.config = "Feature Engineering")
# mtry = 10, trees = 500, min_n = 2

# boosted tree
bt_best <- select_best(bt_tuned, metric = "rsq") |>
  mutate(.config = "Simple Tree")
# mtry = 10, trees = 500, min_n = 11, learn rate = 0.0398

# boosted tree with feature engineering
bt_fe_best <- select_best(bt_tuned_2, metric = "rsq") |>
  mutate(.config = "Feature Engineering")
# mtry = 10, trees = 437, min_n = 11, learn rate = 0.398




## Create Tables for Best Hyperparameters ----
# create a table for the ridge regression model hyperparameters
bind_rows(ridge_best, ridge_fe_best) |>
  knitr::kable(col.names = c("Penalty", "Recipe"))

# create a table for the elastic net model hyperparameters
bind_rows(elastic_best, elastic_fe_best) |>
  knitr::kable(col.names = c("Penalty", "Mixture", "Recipe"))

# create a table for the nearest neighbor model hyperparameters
bind_rows(kknn_best, kknn_fe_best) |>
  knitr::kable(col.names = c("Neighbors", "Recipe"))

# create a table for the random forest model hyperparameters
bind_rows(rf_best, rf_fe_best) |>
  knitr::kable(col.names = c("Randomly Selected Predictors", "Trees", "Minimum Node Size",
                             "Recipe"))

# create a table for the boosted tree model hyperparameters
bind_rows(bt_best, bt_fe_best) |>
  knitr::kable(col.names = c("Randomly Selected Predictors", "Trees", "Minimum Node Size",
                             "Learn Rate", "Recipe"))


## Build a Table to Compare Models ----
# show_best for each model to build table

# create null model table
tbl_null <- null_metrics |>
  select(mean, n, std_err) |>
  mutate(model = "Null",
         recipe = "Null") 

# create baseline simple linear regression model table
tbl_baseline <- baseline_metrics |>
  select(mean, n, std_err) |>
  mutate(model = "Simple Linear Regression",
         recipe = "Linear/Kitchen Sink")

# create ridge table
tbl_ridge <- show_best(ridge_tuned, metric = "rsq", n = 1) |>
  slice_max(mean) |>
  select(mean, n, std_err) |>
  mutate(model = "Ridge", 
         recipe = "Linear/Kitchen Sink")

# create ridge (feature engineering) table
tbl_ridge_2 <- show_best(ridge_tuned_2, metric = "rsq", n = 1) |>
  slice_max(mean) |>
  select(mean, n, std_err) |>
  mutate(model = "Ridge", 
         recipe = "Feature Engineering")


# create elastic model table
tbl_elastic <- show_best(elastic_tuned, metric = "rsq", n=1) |>
  slice_max(mean) |>
  select(mean, n, std_err) |>
  mutate(model = "Elastic Net", 
         recipe = "Linear/Kitchen Sink")

# create elastic model (feature engineered recipe) table
tbl_elastic_2 <- show_best(elastic_tuned_2, metric = "rsq", n=1) |>
  slice_max(mean) |>
  select(mean, n, std_err) |>
  mutate(model = "Elastic Net", 
         recipe = "Feature Engineering")

# create nearest neighbor table
tbl_kknn <- show_best(kknn_tuned, metric = "rsq") |>
  slice_max(mean) |>
  select(mean, n, std_err) |>
  mutate(model = "Nearest Neighbor", 
         recipe = "Tree Recipe")

# create nearest neighbor (feature engineered) table
tbl_kknn_2 <- show_best(kknn_tuned_2, metric = "rsq") |>
  slice_max(mean) |>
  select(mean, n, std_err) |>
  mutate(model = "Nearest Neighbor", 
         recipe = "Feature Engineering")

# create random forest table
tbl_rf <- show_best(rf_tuned, metric = "rsq", n=1) |>
  slice_max(mean) |>
  select(mean, n, std_err) |>
  mutate(model = "Random Forest", 
         recipe = "Tree Recipe")

# create random forest (feature engineering) table
tbl_rf_2 <- show_best(rf_tuned_2, metric = "rsq") |>
  slice_max(mean) |>
  select(mean, n, std_err) |>
  mutate(model = "Random Forest", 
         recipe = "Feature Engineering")

# create boosted tree table
tbl_bt <- show_best(bt_tuned, metric = "rsq") |>
  slice_max(mean) |>
  select(mean, n, std_err) |>
  mutate(model = "Boosted Tree", 
         recipe = "Tree Recipe")

# create boosted tree (feature engineering) table
tbl_bt_2 <- show_best(bt_tuned_2, metric = "rsq") |>
  slice_max(mean) |>
  select(mean, n, std_err) |>
  mutate(model = "Boosted Tree", 
         recipe = "Feature Engineering")



model_results_table <- bind_rows(tbl_baseline, tbl_elastic, tbl_elastic_2,
                           tbl_rf, tbl_rf_2, tbl_bt, tbl_bt_2,
                           tbl_kknn, tbl_kknn_2, tbl_ridge, tbl_ridge_2)
model_results_table |>
  arrange(desc(mean))

# save out model results table
save(model_results_table, file = here("results/model_results_table.rda"))









