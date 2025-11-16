# Final Project: Predicting Air Quality in India
## Results Sub-Directory

### Overview
This directory contains results from all scripts used for fitting/training and/or tuning models. 

Each model's workflow and fit/tuned result is saved to this folder as well as certain results tables that were saved for an easier retrieval

### Files
#### Baseline Models
- `fit_null.rda`: Results from fitting a null model/workflow to resamples (`3_fit_null.R`)
- `fit_baseline.rda`: Results from fitting a baseline simple linear regression model/workflow to resamples (`3_fit_baseline.R`)

#### Parametric Models
- `ridge_tuned.rda`: Results from tuning a ridge regression model/workflow with a simple linear regression recipe on resamples (`3_tune_ridge.R`)
- `ridge_workflow.rda`: Ridge model with simple linear regression recipe workflow
- `ridge_tuned_2.rda`: Results from tuning a ridge regression model/workflow with a feature engineered linear regression recipe on resamples (`3_tune_ridge_2.R`)
- `ridge_workflow_2.rda`: Ridge model with feature engineering linear regression recipe workflow
- `elastic_tuned.rda`: Results from tuning elastic net logistic regression model/workflow with a simple linear regression recipe on resamples (`3_tune_elastic.R`)
- `elastic_workflow.rda`:  Elastic net with simple linear regression recipe workflow
- `elastic_tuned_2.rda`: Results from tuning elastic net logistic regression model/workflow with a feature engineering linear regression recipe on resamples (`3_tune_elastic_2.R`)
- `elastic_workflow_2.rda`: Elastic net with feature engineering linear regression recipe workflow

#### Non-Parametric Models
- `kknn_tuned.rda`: Results from tuning k-nearest neighbor model/workflow with a simple tree recipe on resamples (`3_tune_kknn.R`)
- `kknn_workflow.rda`: K-nearest neighbor model with simple tree recipe workflow
- `kknn_tuned_2.rda`: Results from tuning k-nearest neighbor model/workflow with a feature engineered tree recipe on resamples (`3_tune_kknn_2.R`)
- `kknn_workflow_2.rda`:  K-nearest neighbor model model with feature engineering tree recipe workflow
- `rf_tuned.rda`: Results from tuning random forest model/workflow with a simple tree recipe on resamples (`3_tune_rf.R`)
- `rf_workflow.rda`: Random forest model with simple tree recipe workflow
- `rf_tuned_2.rda`: Results from tuning random forest model/workflow with a feature engineered tree recipe on resamples (`3_tune_rf_2.R`)
- `rf_workflow_2.rda`: Random forest model with feature engineering tree recipe workflow
- `bt_tuned.rda`: Results from tuning boosted tree model/workflow with simple tree recipe on resamples (`3_tune_bt.R`)
- `bt_workflow.rda`: Boosted Tree model with simple tree recipe workflow
- `bt_tuned_2.rda`: Results from tuning boosted tree model/workflow with a feature engineered tree recipe on resamples (`3_tune_bt_2.R`)
- `bt_workflow_2.rda`: Boosted Tree model with feature engineering tree recipe workflow

#### Final Model (Best Random Forest Model)
- `final_fit.rda`: The final fit of my best model (random forest using a simple tree recipe) on the entire training dataset
- `final_workflow.rda`: The workflow for the final fit of my best model (random forest using a simple tree recipe) 

#### Results Tables
- `model_results_table.rda`: A table containing the mean RSQ and standard error for each best model on each recipe - used for model comparison and to select the final model
- `air_predict_table.rda`: A table containing the assessment metrics (RMSE, RSQ, MAE, MAPE) for my final model predicting the square-root transformed air quality index value
- `air_predict_table_aqi.rda`: A table containing the assessment metrics (RMSE, RSQ, MAE, MAPE) for my final model predicting the untransformed/actual air quality index value


