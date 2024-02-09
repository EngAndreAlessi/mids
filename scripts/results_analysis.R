library(tidyverse)
library(logr)

log_open("logs/analysis.log")

log_print("Reading cleaned results data...")

results <- read_csv("data/results/results-clean.csv")

log_print("Reading cleaned results data... DONE")

log_print("Starting wilcoxon test...")

bkav <- results$BKAV
avg <- results$avg

w_test <- wilcox.test(avg, bkav, paired = TRUE, alternative = "less", conf.level = 0.995)

log_print("Wilcoxon test... DONE")

log_print(w_test)

log_close()