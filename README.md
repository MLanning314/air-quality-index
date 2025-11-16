# Final Project: Predicting Air Quality in India
## Data Subdirectory

### Overview
This folder contains all the datasets (raw, cleaned, and codebook) for this project 

The dataset used in this project is `city_day.csv` which was taken from Kaggle and was a larger part of 4 datasets relating to air quality in India from 2015-2020. 

This dataset contains the concentration of various airborne pollutants, the city and date the data was collected in/on, and the air quality index value/category on the given day the data was collected.

After cleaning up some of the data, which involved removing missing observations for the target variable, filtering any unrealistic data values out, transforming the target variable, and factoring some variables - the cleaned version of this dataset can also be found here, labeled as `air_clean.csv`. 

This cleaned data contains 24,305 observations of 16 variables.

A codebook with more details about the cleaned dataset can be found in this folder as well under `air_clean_codebook.csv`.


### Files
The files contains in this folder are
- `city_day.csv`: the raw dataset directly from Kaggle
- `air_clean.csv`: the cleaned dataset that is used for the predictive modeling process
- `air_clean_codebook.csv`: the codebook for the cleaned dataset

## Citation
Vopani. (2020). *Air Quality Data in India (2015 - 2020)*. [Dataset]. Kaggle. [https://www.kaggle.com/datasets/rohanrao/air-quality-data-in-india/code?datasetId=630055](https://www.kaggle.com/datasets/rohanrao/air-quality-data-in-india/code?datasetId=630055)


