source("functions.R")

df <- get_bq_data(
  project_public = "gdelt-bq",
  dataset_public = "gdeltv2",
  table_public = "gkg",
  start_date_now = ymd("2023-11-27"),
  start_date_then = ymd("2017-10-26"),
  person_now = "Luxon",
  person_then = "Adern"
)
