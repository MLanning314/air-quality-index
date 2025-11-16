# Final Project: Predicting Air Quality in India
## Recipes

### Overview
This folder contains all the recipes used for this project. These played a role in setting the model workflows and improving prediction accuracy for the models.

Feature engineering for the advanced recipes can be found in the final report or in the R-script `1c_multivariate_analysis`

### Files

- `air_null_recipe.rda`: recipe for the null model - very simple recipe (only enough details to get the model to run)
- `air_baseline_recipe.rda`: recipe for the baseline simple linear regression model - more advanced than null, but less advanced than the linear regression recipes (only enough details to get the model to run)
- `air_lm_recipe.rda`: basic simple linear regression recipe (used for ridge and elastic net models)
- `air_lm_recipe_2.rda`: feature engineering linear regression recipe (used for ridge and elastic net models)
- `air_tree_recipe.rda`: simple tree based recipe (used for k-nearest neighbor, random forest, and boosted tree models)
- `air_tree_recipe_2.rda`: feature engineering tree based recipe (used for k-nearest neighbor, random forest, and boosted tree models)