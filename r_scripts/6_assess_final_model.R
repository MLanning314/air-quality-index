# Final Project ----
# Assess final model

## Load Packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()


## Load Testing Data and Final Fit ----
load(here("data_splits/air_testing.rda"))
load(here("results/final_fit.rda"))

## Assess Final Model with Testing Data for SQRT_AQI ----
# define the metric set
air_metrics <- metric_set(rmse, rsq, mae, mape)

# get prediction results on final model fit to testing set
air_predict <- predict(final_fit, new_data = air_testing) |>
  bind_cols(air_testing |> select(sqrt_aqi))

# format into a nice table
air_predict_table <- air_predict |>
  air_metrics(truth = sqrt_aqi, estimate = .pred)

# save nice table to results
save(air_predict_table, file = here("results/air_predict_table.rda"))

# build a plot with predicted values vs. true values
final_model_analysis_plot <- air_testing |> 
  bind_cols(predict(final_fit, air_testing)) |> 
  select(sqrt_aqi, .pred) |> 
  ggplot(aes(x = sqrt_aqi, y = .pred)) +
  geom_jitter(alpha = 0.3, width = 0.2) +
  geom_abline(color = "red") +
  coord_obs_pred() +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) +
  labs(x = "Actual Air Quality Index (Square-Root Transformed)", 
       y = "Predicted Air Quality Index (Square-Root Transformed)", 
       title = "Predicted Air Quality Index vs. Actual Air Quality Index",
       subtitle = "With the exception of a few outliers, our final model\nis very accurate at predicting air quality index")

ggsave("figures/final_model_analysis_plot.jpg", plot = final_model_analysis_plot)

## Assess Final Model with Testing Data for Actual AQI (Untransformed) ----
# untransform the predicted and actual AQI values (square them)
air_predict_aqi <- air_predict |>
  mutate(
    aqi_pred = .pred^2,   
    aqi_actual = sqrt_aqi^2  
  )

# format into a nice table
air_predict_table_aqi <- air_predict_aqi |>
  air_metrics(truth = aqi_actual, estimate = aqi_pred)

# save a nice table to results 
save(air_predict_table_aqi, file = here("results/air_predict_table_aqi.rda"))

# build a plot with predicted values vs. true values
final_model_analysis_plot_aqi <- air_testing |> 
  bind_cols(predict(final_fit, air_testing)) |> 
  mutate(
    actual_aqi = sqrt_aqi^2,  
    predicted_aqi = .pred^2    
  ) |> 
  ggplot(aes(x = actual_aqi, y = predicted_aqi)) +
  geom_jitter(alpha = 0.3, width = 0.2) +
  geom_abline(color = "red") +  # Reference line y = x
  coord_obs_pred() +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5),
        plot.subtitle = element_text(hjust = 0.5)) +
  labs(
    x = "Actual Air Quality Index",
    y = "Predicted Air Quality Index",
    title = "Predicted Air Quality Index vs. Actual Air Quality Index",
    subtitle = "On the untransformed scale, our model continues to predict the\nair quality index value with high accuracy"
  )
ggsave("figures/final_model_analysis_plot_aqi.jpg", plot = final_model_analysis_plot_aqi)

# find rsq values for transformed and untransformed predictions
sqrt_aqi_tbl <- air_predict |>
  rsq(truth = sqrt_aqi, estimate = .pred)
# 0.974

actual_aqi_tbl <- air_predict_aqi |>
  rsq(truth = aqi_actual, estimate = aqi_pred)
# 0.975
