# Final Project: Predicting Air Quality in India
## R-Scripts

### Overview
This folder contains all the R scripts for this project.

This includes the necessary scripts for data cleaning, exploratory data analysis, initial modeling setup, recipe creation, fitting/tuning models, and model comparison.


### Files
#### Initial Setup and Recipe Creation

- `0_data_tidying.R`: cleaning raw data, analyzing target variable and missingness in dataset
- `1a_initial_setup.R`: initial data split & forming of resamples - this resulted in four new datasets: the split dataset, the folded dataset, the training dataset, and the testing dataset
- `1b_univariate_analysis.R`: exploratory data analysis on predictor variables in the dataset to see the distribution of our variables
- `1c_multivariate_analysis.R`: exploratory data analysis on the predictor variables - mostly for feature engineering exploration and determining correlation between predictors
- `2_recipes.R`: creation of the five recipes used to fit/tune models in this project: null recipe, baseline recipe, simple linear regression recipe, feature engineered linear regression recipe, simple tree recipe, feature engineered tree recipe

#### Fitting/Tuning Models
- `3_fit_null.R`: fitting of null model to resamples
- `3_fit_baseline.R`: fitting of baseline simple linear regression to resamples
- `3_tune_ridge.R`: fitting/tuning of ridge regression model with simple linear regression recipe to resamples 
- `3_tune_ridge.R`: fitting/tuning of ridge regression model with feature engineered linear regression recipe to resamples
- `3_tune_elastic.R`: fitting/tuning of elastic net regression model with simple linear regression recipe to resamples 
- `3_tune_elastic_2.R`: fitting/tuning of elastic net regression model with feature engineered linear regression recipe to resamples
- `3_tune_kknn.R`: fitting/tuning of k-nearest neighbor model with simple tree recipe to resamples 
- `3_tune_kknn_2.R`: fitting/tuning of k-nearest neighbor model with feature engineered tree recipe to resamples
- `3_tune_rf.R`: fitting/tuning of random forest model with simple tree recipe to resamples 
- `3_tune_rf_2.R`: fitting/tuning of random forest model with feature engineered tree recipe to resamples
- `3_tune_bt.R`: fitting/tuning of boosted tree model with simple tree recipe to resamples 
- `3_tune_bt_2.R`: fitting/tuning of boosted tree model with feature engineered tree recipe to resamples 

#### Model Comparison and Final Model Analysis
- `04_model_analysis.R`: comparison of best model fits using the assessment metric of RSQ. This script includes the creation of autoplots, the selection of best hyperparameters, and the creation of comparison tables that results in the selection of the best performing model
- `05_train_final_model.R`: training/fitting of final model on the entire training dataset (random forest model with simple tree recipe)
- `06_assess_final_model.R`: assessment of final model on the testing dataset. This script includes the creation of tables with different regression assessment metrics as well as figures to visualize the accuracy of the model