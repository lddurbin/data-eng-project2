library(janeaustenr)
library(tidytext)
library(stopwords)
library(dplyr)
library(lubridate)
library(DBI)

bigrquery::bq_auth(path = Sys.getenv("GCS_AUTH_FILE"))

bucket_name <- function(num_words = 2) {
  bucket_words <- get_austen_words() |> get_bucket_words(num_words)
  bucket_numbers <- round(runif(1, 1, 10000))

  bucket_name <- paste0(c(bucket_words, bucket_numbers), collapse = "_")

  return(bucket_name)
}


get_austen_words <- function() {
  austen_words <- austen_books() |>
    unnest_tokens(word, text) |>
    anti_join(get_stopwords(), by = "word")

  return(austen_words)
}


get_bucket_words <- function(austen_words, num_words) {
  bucket_words <- austen_words |>
    pull(word) |>
    unique() |>
    sample(num_words)

  bucket_words <- gsub('[[:punct:] ]+','', bucket_words)

  return(bucket_words)
}

get_bq_data <- function(project_public, dataset_public, start_date_now, start_date_then, person_now, person_then) {
  con <- bq_connect("gdelt-bq", "gdeltv2", Sys.getenv("GCS_DEFAULT_PROJECT_ID"))

  cutoff_date_now <- date_to_int(today() - days(1))
  cutoff_date_then <- get_cutoff_date(start_date_now, start_date_then) |> date_to_int()

  start_date_now <- date_to_int(start_date_now)
  start_date_then <- date_to_int(start_date_now)

  query_now <- paste0(
    "SELECT CAST(DATE AS STRING) AS DATETIME, V2Themes, V2Tone from gkg where DATE>",
    start_date_now,
    " and DATE < ", cutoff_date_now,
    " and V2Persons like '%", person_now, "%';"
  )

  query_then <- paste0(
    "SELECT CAST(DATE AS STRING) AS DATETIME, V2Themes, V2Tone from gkg where DATE>",
    start_date_then,
    " and DATE < ", cutoff_date_then,
    " and V2Persons like '%", person_then, "%';"
  )

  person_now_themes <- dbGetQuery(con, query_then)
  person_then_themes <- dbGetQuery(con, query_then)

  dbDisconnect(con)
}


bq_connect <- function(project, dataset, billing) {
  con <- dbConnect(
    bigrquery::bigquery(),
    project = project,
    dataset = dataset,
    billing = billing
  )

  return(con)
}


get_cutoff_date <- function(start_date_now, start_date_then) {
  yesterday <- today() - days(1)
  days_offset <- as.integer(yesterday - start_date_now)
  cutoff_date <- start_date_then + days(days_offset)

  return(cutoff_date)
}


date_to_int <- function(date) {
  integer <- str_remove_all(date, "_") |>
    paste0("000000") |>
    as.integer()

  return(integer)
}
