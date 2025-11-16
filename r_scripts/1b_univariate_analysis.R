# Final Project ----
# Univariate Analysis of Different Variables in the Dataset

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)

## Load Data ----
load(here("data_splits/air_training.rda"))

## Create Functions ----
# create function to create histograms
create_histogram <- function(data, column, bins = 30, fill_color = "blue", border_color = "black") {
  ggplot(data, aes_string(x = column)) +
    geom_histogram(bins = bins, fill = fill_color, color = border_color, alpha = 0.7) +
    theme_minimal() +
    labs(title = paste("Histogram of", column),
         x = column,
         y = "Frequency")
}
# create_histogram(mtcars, "mpg", bins = 20, fill_color = "red")

# create function to create density graphs
create_density_plot <- function(data, column, fill_color = "white", line_color = "black", alpha = 0.5) {
  ggplot(data, aes_string(x = column)) +
    geom_density(fill = fill_color, color = line_color, alpha = alpha) +
    theme_minimal() +
    labs(x = column,
         y = "Density") +
    theme(
      plot.title = element_text(hjust = 0.5),
      panel.grid = element_blank(),   
      panel.border = element_blank(), 
      axis.line = element_blank()     
    )
}
# create_density_plot(your_data, "your_numeric_column")

# create function to create boxplots
create_boxplot <- function(data, x_var, fill_color = "white", outlier_color = "black") {
  ggplot(data, aes_string(x = x_var)) +
    geom_boxplot(fill = fill_color, outlier.color = outlier_color, alpha = 0.7) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5)) +
    theme_void()
}

# create_boxplot(your_data, "numeric_column")


## Exploring the Distribution of Predictors in the Dataset ----
# explore the number of observations for the categorical variable `city`
city_distribution <- ggplot(air_training, aes(x = city)) +
  geom_bar(fill = "pink", color ="black") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(
  panel.grid = element_blank(),
  panel.border = element_blank(), 
  axis.line = element_blank()) +
  labs(title = "Number of AQI Observations by City in India",
       x = "City in India",
       y = "Number of Observations")
ggsave("figures/city_distribution.jpg", plot = city_distribution)
# they do not have an equal number of observations - some cities have over 1500 and other
# cities have much less than 500
# this can impact how well the model predicts values from certain cities

# explore the distribution of the small particulate matter (pm2_5) 
create_histogram(air_training, "pm2_5", bins = 20, fill_color = "pink") 
pm2_5_density <- create_density_plot(air_training, "pm2_5") +
  labs(x = "Concentration of Small Particulate Matter (micrometer in ug / m3)")
pm2_5_boxplot <- create_boxplot(air_training, "pm2_5")
pm2_5_distribution <- (pm2_5_boxplot / pm2_5_density) + 
  plot_layout(heights = c(1, 3)) + 
  plot_annotation(
    title = "Distribution of Small Particulate Matter Concentration",
    subtitle = "There is a significant right-skew for small particulate matter with\na lot of high outliers"
  ) & 
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5))
ggsave("figures/pm2_5_distribution.jpg", plot = pm2_5_distribution)
# there is a very significant right skew for this predictor
# most observations can be found below 250 ppm
# assuming there are a few outliers that are heavily impacting the distribution to the right


# explore distribution of the large particulate matter (pm10)
create_histogram(air_training, "pm10", bins = 20, fill_color = "pink") 
pm10_density <- create_density_plot(air_training, "pm10") +
  labs(x = "Concentration of Large Particulate Matter (micrometer in ug / m3)")
pm10_boxplot <- create_boxplot(air_training, "pm10")
pm10_distribution <- (pm10_boxplot / pm10_density) + 
  plot_layout(heights = c(1, 3)) + 
  plot_annotation(
    title = "Distribution of Large Particulate Matter Concentration",
    subtitle = "There is a significant right-skew for large particulate matter with\na moderate number of high outliers"
  ) & 
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5))
ggsave("figures/pm10_distribution.jpg", plot = pm10_distribution)
# there is a right skew for this predictor, but not as bad as pm2_5
# most observations are below 400 ppm
# as seen in boxplot, there are a few high outliers skewing the data

# explore the distribution of nitrogen monoxide (no)
create_histogram(air_training, "no", bins = 20, fill_color = "pink") 
no_density <- create_density_plot(air_training, "no") +
  labs(x = "Concentration of Nitrogen Monoxide (ug / m3)")
no_boxplot <- create_boxplot(air_training, "no")
no_distribution <- (no_boxplot / no_density) + 
  plot_layout(heights = c(1, 3)) + 
  plot_annotation(
    title = "Distribution of Nitrogen Monoxide Concentration",
    subtitle = "There is a very significant right-skew for nitrogen monoxide with\na very large number of outliers at a high concentration"
  ) & 
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5))
ggsave("figures/no_distribution.jpg", plot = no_distribution)
# this is incredibly right skewed (worse than small particulate matter)
# almost all the values are below 50, but the largest outlier is almost at 400

# explore the distribution of nitrogen dioxide (no2)
create_histogram(air_training, "no2", bins = 20, fill_color = "pink") 
no2_density <- create_density_plot(air_training, "no2") +
  labs(x = "Concentration of Nitrogen Dioxide (ug / m3)")
no2_boxplot <- create_boxplot(air_training, "no2")
no2_distribution <- (no2_boxplot / no2_density) + 
  plot_layout(heights = c(1, 3)) + 
  plot_annotation(
    title = "Distribution of Nitrogen Dioxide Concentration",
    subtitle = "There is a significant right-skew for nitrogen dioxide with\na large number of outliers at a high concentration"
  ) & 
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5))
ggsave("figures/no2_distribution.jpg", plot = no2_distribution)
# also right skewed but not as bad as the nitrogen monoxide predictor
# almost all the values are below 100, but there are some outliers above 350
# very pointy peak - not gradual like some of the other variables - looks like an upside down V

# explore the distribution of nitrous oxides (n_ox)
create_histogram(air_training, "n_ox", bins = 20, fill_color = "pink") 
nox_density <- create_density_plot(air_training, "n_ox") +
  labs(x = "Concentration of Nitrous Oxides (parts per billion - ppb)")
nox_boxplot <- create_boxplot(air_training, "n_ox")
nox_distribution <- (nox_boxplot / nox_density) + 
  plot_layout(heights = c(1, 3)) + 
  plot_annotation(
    title = "Distribution of Nitrous Oxide Concentration",
    subtitle = "There is a significant right-skew for nitrous oxides with\na large number of outliers at a high concentration"
  ) & 
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5))
ggsave("figures/nox_distribution.jpg", plot = nox_distribution)
# this has a right skew, but it is more moderate than some of the predictors we have seen
# most values are below 100, but there are some outliers above 350
# like no2, there is a very pointy peak, which is interesting 

# explore the distribution of ammonia (nh3)
create_histogram(air_training, "nh3", bins = 20, fill_color = "pink") 
nh3_density <- create_density_plot(air_training, "nh3") +
  labs(x = "Concentration of Ammonia (ug / m3)")
nh3_boxplot <- create_boxplot(air_training, "nh3")
nh3_distribution <- (nh3_boxplot / nh3_density) + 
  plot_layout(heights = c(1, 3)) + 
  plot_annotation(
    title = "Distribution of Ammonia Concentration",
    subtitle = "There is a significant right-skew for ammonia with\na very large number of outliers at a high concentration"
  ) & 
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5))
ggsave("figures/nh3_distribution.jpg", plot = nh3_distribution)
# also very right skewed
# most values are below 50, but some outliers are above 350
# has a more rounded top - not so pointy

# explore the distribution of carbon monoxide (co)
create_histogram(air_training, "co", bins = 20, fill_color = "pink") 
co_density <- create_density_plot(air_training, "co") +
  labs(x = "Concentration of Carbon Monoxide (mg / m3)")
co_boxplot <- create_boxplot(air_training, "co")
co_distribution <- (co_boxplot /co_density) + 
  plot_layout(heights = c(1, 3)) + 
  plot_annotation(
    title = "Distribution of Carbon Monoxide Concentration",
    subtitle = "There is a very very significant right-skew for carbon monoxide with\noutliers at extremely high concentrations"
  ) & 
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5))
ggsave("figures/co_distribution.jpg", plot = co_distribution)
# SO RIGHT SKEWED - like this might be the most right-skewed graph I have ever seen
# most values are below 10, but there are outliers up to over 150!!
# crazy distribution honestly

# explore the distribution of sulfur dioxide (so2)
create_histogram(air_training, "so2", bins = 20, fill_color = "pink") 
so2_density <- create_density_plot(air_training, "so2") +
  labs(x = "Concentration of Sulfur Dioxide (ug / m3)")
so2_boxplot <- create_boxplot(air_training, "so2")
so2_distribution <- (so2_boxplot /so2_density) + 
  plot_layout(heights = c(1, 3)) + 
  plot_annotation(
    title = "Distribution of Sulfur Dioxide Concentration",
    subtitle = "There is a significant right-skew for sulfur dioxide with\na lot of outliers at high concentrations"
  ) & 
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5))
ggsave("figures/so2_distribution.jpg", plot = so2_distribution)
# right skewed with a pointy top at the peak density
# most values are below 25, but some outliers are above 150
# less right skewed than co

# explore the distribution of ground ozone (o3)
create_histogram(air_training, "o3", bins = 20, fill_color = "pink") 
o3_density <- create_density_plot(air_training, "o3") +
  labs(x = "Concentration of Ground Ozone (ug / m3)")
o3_boxplot <- create_boxplot(air_training, "o3")
o3_distribution <- (o3_boxplot /o3_density) + 
  plot_layout(heights = c(1, 3)) + 
  plot_annotation(
    title = "Distribution of Ground Ozone Concentration",
    subtitle = "There is a moderate right-skew for ground ozone with\na decent amount of outliers at high concentrations"
  ) & 
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5))
ggsave("figures/o3_distribution.jpg", plot = o3_distribution)
# best distribution we have explored so far, but still has a moderate right skew
# most values are under 50, but there are some values at 200

# explore the distribution of benzene
create_histogram(air_training, "benzene", bins = 20, fill_color = "pink") 
benzene_density <- create_density_plot(air_training, "benzene") +
  labs(x = "Concentration of Benzene (ug / m3)")
benzene_boxplot <- create_boxplot(air_training, "benzene")
benzene_distribution <- (benzene_boxplot /benzene_density) + 
  plot_layout(heights = c(1, 3)) + 
  plot_annotation(
    title = "Distribution of Benzene Concentration",
    subtitle = "There is an incredibly severe right-skew for benzene with\na lot of outliers, specifically at extraordinarily high concentrations"
  ) & 
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5))
ggsave("figures/benzene_distribution.jpg", plot = benzene_distribution)
# this is somehow worse than the CO distribution, which I didn't think was possible
# most values are at around 1-3, but there are some outliers at over 400
# very strange distribution

# explore the distribution of toluene
create_histogram(air_training, "toluene", bins = 20, fill_color = "pink") 
toluene_density <- create_density_plot(air_training, "toluene") +
  labs(x = "Concentration of Toluene (ug / m3)")
toluene_boxplot <- create_boxplot(air_training, "toluene")
toluene_distribution <- (toluene_boxplot /toluene_density) + 
  plot_layout(heights = c(1, 3)) + 
  plot_annotation(
    title = "Distribution of Toluene Concentration",
    subtitle = "There is an incredibly severe right-skew for benzene with\na lot of outliers, specifically at extraordinarily high concentrations"
  ) & 
  theme(plot.title = element_text(hjust = 0.5), 
        plot.subtitle = element_text(hjust = 0.5))
ggsave("figures/toluene_distribution.jpg", plot = toluene_distribution)
# also a very very very right skewed distribution
# very similar to benzene and co distributions
# has most values below 10, but some predictors over 400

# explore the number of observations for the categorical variable `aqi_category`
aqi_category_distribution <- ggplot(air_training, aes(x = aqi_category)) +
  geom_bar(fill = "pink", color ="black") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  theme(
    plot.title = element_text(hjust = 0.5),
    panel.grid = element_blank(),   
    panel.border = element_blank(), 
    axis.line = element_blank()     
  ) +
  labs(title = "Number of Observations for each AQI Category",
       y = "Number of Observations",
       x = "AQI Category")
ggsave("figures/aqi_category_distribution.jpg", plot = aqi_category_distribution)
# more values for moderate/satisfactory
# not a lot of observations for good air quality or very poor/severe air quality
# could cause our model to be less effective on the very low and very high ends of 
# the aqi spectrum, but good in the middle (around 100-200 AQI)

# overall many of the predictors seem to be significantly right skewed, which can cause 
# predictions to be favored towards lower values/underpredict higher values
# I will need to be on the lookout for this when testing my final model and 
# looking at accuracy/assessment metrics. 

