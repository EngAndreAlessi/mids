library(tibble)
library(archive)
library(readr)

options(timeout = 10000)
my_dir <- "data/massive"
data_source <- readr::read_csv2("data/source/massive-networks.csv")
urls <- data_source$url

for (url_ in urls)
{
    td <- tempdir()
    tf <- tempfile()
    download.file(url_, tf)
    info <- archive::archive(tf)
    filename <- info$path[1]
    archive_extract(tf, dir = my_dir, files = filename)
}
