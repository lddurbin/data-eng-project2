library(janeaustenr)
library(tidytext)
library(stopwords)
library(dplyr)
library(lubridate)
library(stringr)

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


get_bq_data <- function(project_public, dataset_public, table_public, start_date_now, start_date_then, person_now, person_then) {
  cutoff_date_now <- date_to_int(today() - days(1))
  cutoff_date_then <- get_cutoff_date(start_date_now, start_date_then) |> date_to_int()

  start_date_now <- date_to_int(start_date_now)
  start_date_then <- date_to_int(start_date_then)

  query_now <- construct_query(project_public, dataset_public, table_public,
                               start_date_now, cutoff_date_now, person_now)
  query_then <- construct_query(project_public, dataset_public, table_public,
                                start_date_then, cutoff_date_then, person_then)

  tb_now <- bigrquery::bq_project_query(
    Sys.getenv("GCS_DEFAULT_PROJECT_ID"),
    query_now
  )

  tb_then <- bigrquery::bq_project_query(
    Sys.getenv("GCS_DEFAULT_PROJECT_ID"),
    query_then
  )

  df_now <- bigrquery::bq_table_download(tb_now)
  df_then <- bigrquery::bq_table_download(tb_then)

  datasets <- list(df_now, df_then)

  return(datasets)
}


get_cutoff_date <- function(start_date_now, start_date_then) {
  yesterday <- today() - days(1)
  days_offset <- as.integer(yesterday - start_date_now)
  cutoff_date <- start_date_then + days(days_offset)

  return(cutoff_date)
}


date_to_int <- function(date) {
  integer <-  str_remove_all(date, "-") |>
    paste0("000000")

  return(integer)
}


construct_query <- function(project_public, dataset_public, table_public, start_date, end_date, person) {
  query <- paste0(
    "SELECT CAST(DATE AS STRING) AS DATETIME, DocumentIdentifier, V2Themes, V2Tone FROM ",
    project_public,".",dataset_public,".",table_public,
    " WHERE DATE > ",
    start_date,
    " and DATE < ", end_date,
    " and V2Persons like '%", person, "%';"
  )

  return(query)
}
