library(tibble)
library(readr)

instance <- read_delim(file = "data/massive/rec-dating.edges", col_names = c("V1", "V2", "|E|"), col_select = c(1,2))
write_delim(instance, file = "data/massive/rec-dating.txt", col_names = FALSE)

instance <- read_delim(file = "data/massive/rec-epinions.edges", col_names = c("V1", "V2", "|E|"), col_select = c(1,2))
write_delim(instance, file = "data/massive/rec-epinions.txt", col_names = FALSE)

instance <- read_delim(file = "data/massive/rec-libimseti-dir.edges", col_names = c("V1", "V2", "|E|"), col_select = c(1,2))
write_delim(instance, file = "data/massive/rec-libimseti-dir.txt", col_names = FALSE)

instance <- read_delim(file = "data/massive/sc-rel9.edges", col_names = c("V1", "V2", "|E|"), col_select = c(1,2))
write_delim(instance, file = "data/massive/sc-rel9.txt", col_names = FALSE)

instance <- read_delim(file = "data/massive/web-wikipedia-growth.edges", col_names = c("V1", "V2", "|E|"), col_select = c(1,2))
write_delim(instance, file = "data/massive/web-wikipedia-growth.txt", col_names = FALSE)
