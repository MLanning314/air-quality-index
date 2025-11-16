# Final Project: Predicting Air Quality in India
## Data Splits

### Overview
This folder contains all the data splits and folds for this project.

These were created in the R-script `1a_initial_setup`

### Files
- `air_folds.rda`: Object identifying how the training set should be folded (used v-fold cross-validation as the resampling technique used for tuning and out of sample model performance estimation)
- `air_split.rda`: contains training and testing data files from initial split
- `air_testing.rda`: contains the testing data file and dataset, derived from `air_split`
- `air_training.rda`: contains the training data file and dataset, derived from `air_split`