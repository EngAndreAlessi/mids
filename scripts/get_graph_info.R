library(igraph)
library(tidyverse)

instances <- readr::read_delim("data/source/instances.csv", show_col_types = FALSE)
source("~/mids/scripts/mids_lower_bound.R")

names <- NULL
orders <- NULL
edges <- NULL
lower_bounds <- NULL
densities <- NULL

for(i in 1:(nrow(instances))) {
    instance <- instances[i, ]
    instance_name <- instance$name
    instance_family <- instance$dataset
    file_name <- paste(instance_name, ".txt", sep = "")
    file_path <- paste("data", instance_family, file_name, sep = "/")
    instance_df <- readr::read_delim(file_path, col_names = c("V1", "V2"), show_col_types = FALSE)
    instance_graph <- igraph::graph_from_data_frame(instance_df, directed = FALSE)
    N <- igraph::vcount(instance_graph)
    M <- igraph::ecount(instance_graph)
    Delta <- max(degree(instance_graph))
    lb <- mids_lower_bound(N, Delta)
    names <- c(names, instance_name)
    orders <- c(orders, N)
    edges <- c(edges, M)
    lower_bounds <- c(lower_bounds, lb)
    densities <- c(densities, igraph::edge_density(instance_graph))
}

graph_info <- tibble(names, orders, edges, lower_bounds, densities)
write_csv(graph_info, "data/results/graph_info.csv")
