library(tidyverse)

# Read the results data
results <- read_csv("data/results/results-raw.csv")

# Split the datasets and summarize the data

dimacs <- results |>
    filter(datasets == "dimacs") |>
    select(instances, solutions) |>
    group_by(instances) |>
    summarise(avg = mean(solutions),
              std = sd(solutions))

bhoslib <- results |>
    filter(datasets == "bhoslib") |>
    select(instances, solutions) |>
    group_by(instances) |>
    summarise(avg = mean(solutions),
              std = sd(solutions))

# Read the data with the best known values for the instances

dimacs_bkav <- read_delim("data/source/dimacs.csv")

bhoslib_bkav <- read_delim("data/source/bhoslib.csv")

# Clean the data

dimacs_bkav <- dimacs_bkav |>
    select(name, BKAV)

bhoslib_bkav <- bhoslib_bkav |>
    select(name, BKAV)

# Join the data

dimacs_joined <- inner_join(dimacs_bkav, dimacs, by = join_by(name == instances))

bhoslib_joined <- inner_join(bhoslib_bkav, bhoslib, by = join_by(name == instances))

# Merge the data

results_cleaned <- bind_rows(dimacs_joined, bhoslib_joined)

# Save the clean data

write_csv(results_cleaned, "data/results/results-clean.csv")