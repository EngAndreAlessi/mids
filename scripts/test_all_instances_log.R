library(igraph)
library(readr)
library(logr)

source("~/mids/scripts/greedy.R")

# Read file with all instances names and dataset

all_instances <- readr::read_delim("~/mids/data/source/instances.csv", show_col_types = FALSE)

# Open the log

logr::log_open("~/mids/logs/test.log")

# Start the test

logr::log_print("Starting test - loading every instance and finding one solution")

for(i in 1:nrow(all_instances)){
    instance <- all_instances[i, ]
    logr::log_print(paste("Testing instance ", instance$name, " from ", instance$dataset, sep=""))
    time <- system.time({
        solution <- greedy(instance$name, instance$dataset)
    })
    logr::log_print(paste("Found solution length: ", length(solution)))
    logr::log_print(paste("Elapsed time: ", time))
}

# Close log
logr::log_close()
