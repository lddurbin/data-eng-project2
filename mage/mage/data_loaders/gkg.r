library("pacman")
pacman::p_load(dplyr, bigrquery, lubridate, stringr)

load_data <- function() {
bigrquery::bq_auth(path = "mage/bigquerylearning-402002-64c78651a8f9.json")

df <- get_bq_data(
  project_public = "gdelt-bq",
  dataset_public = "gdeltv2",
  table_public = "gkg",
  start_date_now = ymd("2023-11-27"),
  start_date_then = ymd("2017-10-26"),
  person_now = "Luxon",
  person_then = "Adern"
)

return(df)
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
    "bigquerylearning-402002",
    query_now
  )

  tb_then <- bigrquery::bq_project_query(
    "bigquerylearning-402002",
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