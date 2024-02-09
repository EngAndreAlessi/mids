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

# Setting up experiment variables

logr::log_print("Setting up experiment variables...")

instances <- NULL
datasets <- NULL

logr::log_print("Setting random seed to 12345...")
set.seed(12345)
logr::log_print("Setting random seed... DONE")

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
    logr::log_print(paste(i, " - Testing instance ", instance$instances, " from ", instance$datasets, sep=""))
    
    # Set the random seed 
    logr::log_print(paste("Setting random seed to ", i, "...", sep=""))
    set.seed(i)
    logr::log_print("Setting random seed... DONE")
    
    solution <- greedy(instance$instances, instance$datasets)
    logr::log_print(paste("Found solution length: ", length(solution)))
    logr::log_print("Found solution:")
    logr::log_print(solution)
    solutions <- c(solutions, length(solution))
    solution <- NULL
}

logr::log_print("Experiment DONE")

logr::log_print("Writing results...")

final_experiment <- tibble(experiment, solutions)

write_csv(final_experiment, "data/results/results-raw.csv")

logr::log_print("Writing results... DONE")

logr::log_close()





