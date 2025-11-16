# Final Project: Predicting Air Quality in India
## Figures and Plots

### Overview
This folder contains all figures placed in the final report. 

These are all directly referenced in the report, either in the main body or in the appendix.

### Figures
#### Missingness
- `appendix_eda_figure1.jpg`: an image depicting the missingness for each variable in the raw dataset
- `missing_clean_data.jpg`: an image depicting the missingness for each variable in the clean dataset

#### Target Variable Analysis
- `log_tv_distribution.jpg`: an image of the distribution for the air quality index value with a log10 transformation applied (includes a boxplot and a density graph)
- `missing_tv_graph.jpg`: an image depicting the missingness of the target variable, air quality index, as shown in a barplot
- `sqrt_tv_distribution.jpg`: an image of the distribution for the air quality index value with a square root transformation applied (includes a boxplot and a density graph)
- `tv_distribution.jpg`: an image of the distribution for the air quality index value (includes a boxplot and a density graph)

#### Exploratory Data Analysis
- `aqi_cities.jpg`: an image of the distribution of AQI values for each city in India, ordered by lowest AQI to highest AQI
- `aqi_trend.jpg`: an image of the change in AQI over time displaying the trend for each observation taken from 2015-2020
- `aqi_cities_heatmap.jpg`: an image of the change in AQI over time for each city in India displayed in a heatmap - shows both AQI value and number of observations to provide a comprehensize view of AQI in the dataset
- `benzene_distribution.jpg`: an image of the distribution for the benzene concentration in the training dataset
- `city_distribution.jpg`: an image of the number of observations for the each Indian city in the training dataset
- `co_distribution.jpg`: an image of the distribution for the carbon monoxide concentration in the training dataset
- `nh3_distribution.jpg`: an image of the distribution for the ammonia concentration in the training dataset
- `no_distribution.jpg`: an image of the distribution for the nitrogen monoxide concentration in the training dataset
- `no2_distribution.jpg`: an image of the distribution for the nitrogen dioxide concentration in the training dataset
- `nox_distribution.jpg`: an image of the distribution for the nitrous oxide concentration in the training dataset
- `o3_distribution.jpg`: an image of the distribution for the ground ozone concentration in the training dataset
- `pm2_5_distribution.jpg`: an image of the distribution for the small particulate matter concentration in the training dataset
- `pm10_distribution.jpg`: an image of the distribution for the large particulate matter concentration in the training dataset
- `so2_distribution.jpg`: an image of the distribution for the sulfur dioxide concentration in the training dataset
- `toluene_distribution.jpg`: an image of the distribution for the toluene concentration in the training dataset

#### Autoplots for Tuning Hyperparameter Analysis
- `bt_autoplot_fe.jpg`: an image of the autoplot for my boosted tree model hyperparameters on the feature engineering tree recipe
- `bt_autoplot.jpg`: an image of the autoplot for my boosted tree model hyperparameters on the simple tree recipe
- `elastic_autoplot_fe.jpg`: an image of the autoplot for my elastic net model hyperparameters on the feature engineering linear regression recipe
- `elastic_autoplot.jpg`: an image of the autoplot for my elastic net model hyperparameters on the simple linear regression recipe
- `kknn_autoplot_fe.jpg`: an image of the autoplot for my k-nearest neighbor model hyperparameters on the feature engineering tree recipe
- `kknn_autoplot.jpg`: an image of the autoplot for my k-nearest neighbor model hyperparameters on the simple tree recipe
- `rf_autoplot_fe.jpg`: an image of the autoplot for my random forest model hyperparameters on the feature engineering tree recipe
- `rf_autoplot.jpg`: an image of the autoplot for my random forest model hyperparameters on the simple tree recipe
- `ridge_autoplot_fe.jpg`: an image of the autoplot for my ridge regression model hyperparameters on the feature engineering linear regression recipe
- `ridge_autoplot.jpg`: an image of the autoplot for my ridge regression model hyperparameters on the simple linear regression recipe

#### Final Model Analysis
- `final_model_analysis_plot_aqi.jpg`: a scatterplot of the predicted versus actual air quality index values on the untransformed scale for the final model
- `final_model_analysis_plot.jpg`: a scatterplot of the predicted versus actual air quality index values on the transformed square-root scale for the final model


