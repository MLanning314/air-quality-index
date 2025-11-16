# Final Project ----
# Bivariate Analysis of Different Variables in the Dataset
# Examine Relations for Feature Engineering Recipe

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)

## Load Data ----
load(here("data_splits/air_training.rda"))

## Correlation Graphs Between Variables in the Dataset ----

# this can help me determine how to decide interactions for the feature engineered recipes

#create a function for correlation graphs (generative AI was used to help me construct this function)
create_correlation_graph <- function(data, target_var) {
  # select numeric columns in the dataset
  numeric_data <- data |>
    select(where(is.numeric))
  
  # calculate correlations with the target variable
  correlation_df <- numeric_data |>
    summarise(across(everything(), ~ cor(.x, numeric_data[[target_var]], use = "complete.obs"))) |>
    pivot_longer(cols = everything(), names_to = "variable", values_to = "correlation") |>
    filter(variable != target_var)  # exclude the target variable itself
  
  # create the ggplot object
  plot <- ggplot(correlation_df, aes(x = reorder(variable, correlation), y = correlation, fill = correlation)) +
    geom_bar(stat = "identity") +
    coord_flip() +
    scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0) +
    theme_minimal() +
    labs(
      title = paste("Correlation with", target_var),
      x = "Variables",
      y = "Correlation Coefficient"
    )
  
  # return the plot object
  return(plot)
}

create_correlation_graph(air_training, "aqi")
# the variables with the strongest positive correlation are pm10,
# co, and pm2_5
# the pm variables likely predict aqi most because they are the most obviously hazardous
# form of air pollution, so when their concentration is high, the aqi is much higher
# the variables with the weakest positive correlation are benzene and o3
# benzene has almost a 0 correlation, which is interesting because it is a very dangerous
# air pollutant
# maybe there is not a great way to detect benzene? or people do not understand its impact?
# most variables are below a 0.6 correlation, so they do not need to be removed

create_correlation_graph(air_training, "pm10")
# the variables with the strongest positive correlation are pm2_5, aqi, and n_ox
# I expected that aqi would be a high predictor, but I did not think that pm 2.5 would be
# maybe the particulate matter is in high concentrations in tandem? and so the concentrations
# rise and fall together - would love to explore this interaction in a recipe
# benzene has a zero correlation with particulate matter - are they mutually exclusive?
# co is also not a big predictor of particulate matter, but I don't know why it would be

create_correlation_graph(air_training, "n_ox")
# the variables with the strongest positive correlation are no, no2, and pm10
# not suprising that no and no2 are big predictors as they themselves are nitrous oxides
# maybe want to explore the relationship between no and no2?
# the variables with the weakest positive correlation are benzene, o3, and nh3
# wondering why the gasous pollutants have such a low correlation

create_correlation_graph(air_training, "so2")
# the variables with the strongest positive correlation are co, aqi, and no2
# co has a high correlation with co - maybe want to explore this relationship farther
# because it does not seem obvious as to why these two are so connected and they both
# predict aqi well
# interestingly, nh3 negatively correlates with so2 - I wonder why ammonia and sulphur
# dioxide do not interact well together

create_correlation_graph(air_training, "benzene")
# very very very interesting graph
# the only thing that actually correlates with benzene is toluene, but why?
# would love to explore this interaction more

create_correlation_graph(air_training, "toluene")
# benzene correlates highly with benzene, but also has moderate correlation with other variables
# wondering why benzene has only toluene, but toluene has more than benzene
# so2 and no2 also strong predictions
# nh3 has absolutely zero correlation - strange

create_correlation_graph(air_training, "o3")
# ozone has the highest correlation with no2 and pm10 - very interesting
# want to explore the relationship between ozone and pm10 more because I think it is 
# important to see the impact large particulate matter has on harmful ozone 
# I wonder if this interaction contributes to the smog effect of many urban cities, especially
# in India


## Explore Different Relationships in the Data ----
# (not for project, but for fun)

# what cities have the highest AQI values?
aqi_cities <- ggplot(air_training, aes(x = fct_reorder(city, aqi, .fun = median, .desc = TRUE), y = aqi)) +
  geom_boxplot(fill = "lightblue", color = "black") +
  coord_flip() +  # Flip for readability
  labs(
    title = "AQI Distribution by City",
    x = "City",
    y = "Air Quality Index (AQI)"
  ) +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))
  theme(panel.grid = element_blank())
ggsave("figures/aqi_cities.jpg", plot = aqi_cities)
# Aizawl has the lowest AQI value at around 0-50
# Ahmedabad has the highest AQI value with a mean around 300
# this graph does not take into account the number of observations in each city so it may be skewed

# what is the AQI trend over time
aqi_trend <- ggplot(air_training, aes(x = date, y = aqi)) +
  geom_line() +
  labs(title = "AQI Trends Over Time", x = "Year", y = "Air Quality Index (AQI)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(panel.grid = element_blank())
ggsave("figures/aqi_trend.jpg", plot = aqi_trend)
# there seem to be significant year to year fluctuations
# it seems as though during winter months there are higher AQI values
# in summer months there are lower AQI values each year
# in 2018 and 2019 there was less fluctuation, could have been natural disasters

# heatmap of AQI over time for cities - kind of cool to visualize the same thing 
# that the graph above shows 
aqi_cities_heatmap <- ggplot(air_training, aes(x = date, y = city, fill = aqi)) +
  geom_tile() +
  scale_fill_viridis_c() +
  labs(title = "Heatmap of AQI Levels Over Time", x = "Date", y = "City") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5)) +
  theme(panel.grid = element_blank()) 
ggsave("figures/aqi_cities_heatmap.jpg", plot = aqi_cities_heatmap)
# shows the number of observations for each city as well by nature of the graph 
# Delhi, Ahmedabad, and Patna seems to have the most consistent poor AQI (300-400)
# Chennai, Aizawl, and Hyderabad seem to have the best AQI (<100-200)
# good way to visualize the change over time in different cities while also seeing 
# the number of observations in each city
