library(tidyverse)
library(dunn.test)
library(logr)

# Reading the necessary data
instances <- read_csv("data/source/instances.csv", show_col_types = FALSE)
results <- read_csv("data/results/results-raw.csv", show_col_types = FALSE)
literature <- read_csv("data/source/literature_results.csv", show_col_types = FALSE)
info <- read_csv("data/results/instances_info.csv", show_col_types = FALSE)

# Summary
results_summary <- results |>
    group_by(instances) |>
    summarise(avg = mean(solutions),
              std = sd(solutions),
              min = min(solutions))

# Write to a csv file
write_csv(results_summary, "data/results/results-summary.csv")

# Get only the average to compare with literature results
greedy_results <- results_summary |>
    select(instances, avg)

literature <- literature |>
    select(instance, dataset, avg, method)

# Joining with instances data to get dataset column
greedy_results <- inner_join(greedy_results, instances, by = join_by(instances == name))

# Adding a column "method" with the value "greedy" and renaming column instances
greedy_results <- greedy_results |>
    mutate(method = "GREEDY") |>
    rename(instance = instances)

# Combining tables greedy_results and literature by binding rows
all_methods <- bind_rows(literature, greedy_results)

# Arranging by first column and converting necessary columns to factors
all_methods <- all_methods |>
    arrange(instance) |>
    mutate(dataset = as_factor(dataset),
           method = as_factor(method))

# Saving this table
write_csv(all_methods, "data/results/results-clean.csv")

# Relative deviation from lower bound
info_lbs <- info |>
    select(instances, lbs)

all_methods <- inner_join(all_methods, info_lbs, by = join_by(instance == instances))

all_methods <- all_methods |>
    mutate(ardp = (avg-lbs)/lbs * 100)

# Creating a linear model
model <- lm(ardp ~ method, data = all_methods)

# Getting the residuals
res <- residuals(model)

# Checking Q-Q plot

qqnorm(res)
qqline(res, col = "red")

# Shapiro-Wilk normality test
sw_test <- shapiro.test(res)

# Very likely not normal, Kruskal-Wallis rank sum test
kw_test <- kruskal.test(ardp ~ method, data = all_methods)

# Wilcoxon Rank-Sum tests for each pair of methods
w_test <- pairwise.wilcox.test(all_methods$ardp, all_methods$method, p.adjust.method = "bonferroni")

# Boxplot
ggplot(all_methods, aes(x = method, y = ardp)) +
    geom_boxplot() +
    theme_minimal()
