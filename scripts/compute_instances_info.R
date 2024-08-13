library(tidyverse)
library(igraph)

source("~/mids/scripts/mids_lower_bound.R")

all_instances <- readr::read_delim("~/mids/data/source/instances.csv", show_col_types = FALSE)

instances <- NULL
n_nodes <- NULL
n_edges <- NULL
densities <- NULL
max_degrees <- NULL
lbs <- NULL

for(i in 1:nrow(all_instances)){
    instance <- all_instances[i, ]
    file_name <- paste(instance$name, ".txt", sep = "")
    file_path <- paste("data", instance$dataset, file_name, sep = "/")
    instance_df <- readr::read_delim(file_path, col_names = c("V1", "V2"), show_col_types = FALSE)
    graph <- igraph::graph_from_data_frame(instance_df, directed = FALSE)
    n <- vcount(graph)
    m <- ecount(graph)
    density <- edge_density(graph)
    max_degree <- max(degree(graph))
    lb <- mids_lower_bound(n, max_degree)
    instances <- c(instances, instance$name)
    n_nodes <- c(n_nodes, n)
    n_edges <- c(n_edges, m)
    densities <- c(densities, density)
    max_degrees <- c(max_degrees, max_degree)
    lbs <- c(lbs, lb)
}

df <- tibble(instances, n_nodes, n_edges, densities, max_degrees, lbs)

write_csv(df, "data/results/instances_info.csv")
