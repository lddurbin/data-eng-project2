library("pacman")
p_load(rvest)
p_load(polite)

load_data <- function() {
url <- "https://en.wikipedia.org/wiki/List_of_directors_of_the_Metropolitan_Museum_of_Art"

url_bow <- polite::bow(url)

directors_html <- polite::scrape(url_bow) |> 
  rvest::html_nodes("table.wikitable") |>
  rvest::html_table(fill = TRUE) 

  df <- directors_html[[1]]

  df
}
