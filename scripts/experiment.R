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

solutions <- NULL
times <- NULL
iters <- NULL

for(i in 1:nrow(experiment)){
    instance <- experiment[i, ]
    logr::log_print(paste(i, " - Testing instance ", instance$instances, " from ", instance$datasets, sep=""))
    
    # Set the random seed 
    logr::log_print(paste("Setting random seed to ", i, "...", sep=""))
    set.seed(i)
    logr::log_print("Setting random seed... DONE")
    time <- microbenchmark::microbenchmark({
        s <- greedy(instance$instances, instance$datasets)
    }, times = 1L)
    logr::log_print(paste("Found solution length: ", s$i))
    logr::log_print(paste("Number of iterations: ", s$iter))
    mean_time <- mean(time$time)/1000000
    logr::log_print(paste("Elapsed time: ", mean_time, " ms"))
    solutions <- c(solutions, s$i)
    times <- c(times, mean_time)
    iters <- c(iters, s$iter)
}

logr::log_print("Experiment DONE")

logr::log_print("Writing results...")

final_experiment <- tibble(experiment, solutions, iters, times)

write_csv(final_experiment, "data/results/results-raw.csv")

logr::log_print("Writing results... DONE")

logr::log_close()





