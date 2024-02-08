library(igraph)
library(readr)
library(tibble)

greedy <- function(instance_name, instance_family, messages = FALSE){
    
    if(messages) {
        print(paste("Finding a solution for instance ", instance_name, sep = ""))
    }
    
    # Loading the instance
    
    if(messages) {
        print("Loading data...")
    }
    
    file_name <- paste(instance_name, ".txt", sep = "")
    file_path <- paste("data", instance_family, file_name, sep = "/")
    instance_df <- readr::read_delim(file_path, col_names = c("V1", "V2"), show_col_types = FALSE)
    instance_graph <- igraph::graph_from_data_frame(instance_df)
    instance_graph <- igraph::as.undirected(instance_graph)
    
    if(messages) {
        print("Data loaded")
        print(instance_graph)
    }
    
    # Initializing the solution
    
    solution <- NULL
    
    # Finding a solution
    
    iter <- 0
    count <- igraph::ecount(instance_graph)
    while(count > 0) {
        if(messages){
            print(paste("Starting iteration ", iter, sep=""))
            print(paste("Current ecount: ", count, sep=""))
        }
        # All node degree
        degrees <- igraph::degree(instance_graph)
        # Find maximum degree
        max_degree <- max(degrees)
        if(messages){
            print(paste("Maximum degree: ", max_degree, sep=""))
        }
        # Find nodes with maximum degree
        max_degree_nodes <- names(degrees[degrees == max_degree])
        # Select a node with max degree
        selected_node <- NULL
        if(length(max_degree_nodes) == 1) {
            selected_node <- max_degree_nodes
        } else {
            selected_node <- sample(max_degree_nodes, 1)
        }
        if(messages){
            print(paste("Selected node: ", selected_node, sep=""))
        }
        # Insert node into solution
        solution <- c(solution, selected_node)
        if(messages){
            print("Partial solution: ")
            print(solution)
        }
        # Remove neighbors
        instance_graph <- igraph::delete_vertices(instance_graph, igraph::neighbors(instance_graph, selected_node))
        # Remove selected node
        instance_graph <- igraph::delete_vertices(instance_graph, selected_node)
        # Update count and iter
        count <- igraph::ecount(instance_graph)
        iter <- iter + 1
    }
    
    # Return the solution
    return(solution)
}