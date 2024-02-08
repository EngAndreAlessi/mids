library(igraph)
library(tidyverse)
library(logr)

source("~/mids/scripts/greedy.R")

# Open the log

logr::log_open("~/mids/logs/experiment.log")

# Read file with all instances names and dataset

logr::log_print("Reading instances.csv...")
all_instances <- readr::read_delim("~/mids/data/source/instances.csv", show_col_types = FALSE)
logr::log_print("Reading instances.csv... DONE")

# Set the random seed 
logr::log_print("Setting random seed to 12345...")
set.seed(12345)
logr::log_print("Setting random seed to 12345... DONE")

# Setting up experiment variables

logr::log_print("Setting up experiment variables...")

instances <- NULL
datasets <- NULL


for(i in 1:nrow(all_instances)){
    instance <- all_instances[i, ]
    instances <- c(instances, rep(instance$name, 30))
    datasets <- c(datasets, rep(instance$dataset, 30))
}

random_numbers <- 1:length(instances)
random_numbers <- sample(random_numbers)

experiment <- tibble::tibble(instances, datasets, random_numbers)

experiment <- experiment |> arrange(random_numbers)

logr::log_print("Setting up experiment variables... DONE")

# Running the experiment

logr::log_print("Starting experiment")

solution <- NULL
solutions <- NULL

for(i in 1:nrow(experiment)){
    instance <- experiment[i, ]
    logr::log_print(paste(i, " - Testing instance ", instance$name, " from ", instance$dataset, sep=""))
    solution <- greedy(instance$name, instance$dataset)
    logr::log_print(paste("Found solution length: ", length(solution)))
    logr::log_print("Found solution:")
    logr::log_print(solution)
    solutions <- c(solutions, solution)
    solution <- NULL
}

final_experiment <- experiment |> mutate(solution_lengths = solutions)

write_csv(final_experiment, "data/results.csv")





