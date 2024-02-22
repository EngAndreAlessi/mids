library(tidyverse)

time_results <- read_csv("data/results/time-results-raw.csv", show_col_types = FALSE)

time_clean <- time_results |>
    group_by(instances) |>
    summarise(mean = mean(times), std = sd(times))

write_csv(time_clean, "data/results/time-results-clean.csv")
