library(tidyverse)
library(logr)

log_open("logs/analysis.log")

log_print("Reading data...")

results <- read_csv("data/results/results-clean.csv", show_col_types = FALSE)
graph_info <- read_csv("data/results/graph_info.csv", show_col_types = FALSE)

log_print("Reading data... DONE")

log_print("Mutating data...")

data <- inner_join(graph_info, results, by = join_by(names == name))
data <- data |> rename("Greedy" = "avg", "MAE-PB" = "BKAV")
data <- pivot_longer(data, cols = 5:6, names_to = "Method", values_to = "i(G)")
data <- data |> mutate(percent_excess = (`i(G)` - lower_bounds)/lower_bounds)
data <- data |> mutate(density = edges/(orders*(orders-1)/2))

log_print("Mutating data... DONE")

log_print("Creating plots...")

ggplot(data, aes(x = Method, y = percent_excess)) +
    geom_boxplot()

ggplot(data = data, 
       mapping = aes(x = density, y = percent_excess, color = Method)
       ) +
    geom_point() +
    geom_smooth(method = "lm")

log_print("Creating plots... DONE")

log_print("Starting wilcoxon test with 0.995 confidence level...")

data2 <- data |> select(names, Method, percent_excess)
data2 <- pivot_wider(data2, names_from = Method, values_from = percent_excess)
mae <- data2$`MAE-PB`
greedy <- data2$Greedy

w_test <- wilcox.test(greedy, mae, paired = TRUE, alternative = "less", conf.level = 0.995)

log_print("Wilcoxon test... DONE")

log_print(w_test)

log_close()