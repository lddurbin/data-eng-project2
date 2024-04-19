library("pacman")
p_load(readr)

export_data <- function(...) {
directors <- readRDS("met_directors.rds")

readr::write_csv(directors, "met_directors.csv")
}
