library(tidyverse)

log <- read_lines("logs/log/experiment.log")

string1 <- "Testing instance"
string2 <- "Found solution length"

count <- 0
counting <- FALSE
instances <- NULL
times <- NULL

for(line in log) {
    if(str_detect(line, string1)) {
        splitted <- str_split_1(line, "Testing instance ")[2]
        instance <- str_split_1(splitted, " ")[1]
        instances <- c(instances, instance)
    }
    if(str_detect(line, string2)) {
        counting <- TRUE
    }
    if(counting) {
        count <- count + 1
    }
    if(count == 4) {
        split1 <- str_split_1(line, "NOTE: Elapsed Time: ")[2]
        split2 <- str_split_1(split1, " secs")[1]
        time <- as.numeric(split2)
        times <- c(times, time)
        count <- 0
        counting <- FALSE
    }
}

time_results <- tibble(instances, times)
write_csv(time_results, "data/results/time-results-raw.csv")
