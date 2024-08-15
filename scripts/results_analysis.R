library(tidyverse)
library(dunn.test)
library(logr)

# Opening log
logr::log_open("~/mids/logs/results_analysis.log")
logr::log_print("STARTING RESULTS ANALYSIS")

# Reading the necessary data
logr::log_print("Reading the necessary data...")
instances <- readr::read_csv("data/source/instances.csv", show_col_types = FALSE)
results <- readr::read_csv("data/results/results-raw.csv", show_col_types = FALSE)
literature <- readr::read_csv("data/source/literature_results.csv", show_col_types = FALSE)
info <- readr::read_csv("data/results/instances_info.csv", show_col_types = FALSE)
logr::log_print("Reading data DONE.")

# Summary
logr::log_print("Creating summary of results...")
results_summary <- results |>
    dplyr::group_by(instances) |>
    dplyr::summarise(avg = mean(solutions),
              std = sd(solutions),
              min = min(solutions))
logr::log_print("Creating summary DONE.")
# Write to a csv file
readr::write_csv(results_summary, "data/results/results-summary.csv")
logr::log_print("Summary saved to data/results/results-summary.csv")

logr::log_print("Cleaning data...")

# Get only the average to compare with literature results
greedy_results <- results_summary |>
    dplyr::select(instances, avg)

literature <- literature |>
    dplyr::select(instance, dataset, avg, method)

# Joining with instances data to get dataset column
greedy_results <- dplyr::inner_join(greedy_results, instances, by = join_by(instances == name))

# Adding a column "method" with the value "greedy" and renaming column instances
greedy_results <- greedy_results |>
    dplyr::mutate(method = "GREEDY") |>
    dplyr::rename(instance = instances)

# Combining tables greedy_results and literature by binding rows
all_methods <- dplyr::bind_rows(literature, greedy_results)

# Arranging by first column and converting necessary columns to factors
all_methods <- all_methods |>
    dplyr::arrange(instance) |>
    dplyr::mutate(dataset = as_factor(dataset),
           method = forcats::as_factor(method))

# Relative deviation from lower bound
info_lbs <- info |>
    dplyr::select(instances, lbs)

all_methods <- dplyr::inner_join(all_methods, info_lbs, by = join_by(instance == instances))

all_methods <- all_methods |>
    dplyr::mutate(ardp = (avg-lbs)/lbs * 100)

all_methods <- all_methods |>
    dplyr::mutate(log_ratio = log(avg/lbs))

logr::log_print("Data cleaning DONE.")

# Saving this table
readr::write_csv(all_methods, "data/results/results-clean.csv")
logr::log_print("Cleaned data saved to data/results/results-clean.csv")

# Statistical tests for all data
logr::log_print("Starting statistical tests...")

# Creating a linear model
model <- lm(log_ratio ~ method, data = all_methods)
logr::log_print(model)

# Getting the residuals
res <- residuals(model)

# Checking Q-Q plot

qqplot <- ggplot2::ggplot(all_methods, aes(sample = log_ratio)) +
    stat_qq() +
    theme_minimal() +
    labs(x = "Theoretical Quantiles", y = "Sample Quantiles")

ggplot2::ggsave("data/plots/qqplot.png", qqplot, width = 8, height = 6, dpi = 300)
logr::log_print("QQ plot saved to data/plots/qqplot.png")

# Shapiro-Wilk normality test
sw_test <- shapiro.test(res)
logr::log_print(sw_test)

# Very likely not normal, Kruskal-Wallis rank sum test
kw_test <- kruskal.test(log_ratio ~ method, data = all_methods)
logr::log_print(kw_test)

# Wilcoxon Rank-Sum tests for each pair of methods
w_test <- pairwise.wilcox.test(all_methods$log_ratio, all_methods$method, p.adjust.method = "bonferroni")
logr::log_print(w_test)

# Boxplot
g <- ggplot(all_methods, aes(x = method, y = log_ratio, color = method)) +
    geom_boxplot() +
    theme_minimal() +
    theme(legend.position = "none") +
    labs(x = NULL, y = "RDP")

ggplot2::ggsave("data/plots/boxplot.png", g, width = 8, height = 6, dpi = 300)
logr::log_print("Boxplot saved to data/plots/boxplot.png")

logr::log_print("ANALYSIS DONE")
