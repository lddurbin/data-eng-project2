
library("pacman")
p_load(bigrquery)

bigrquery::bq_auth(path = "centered-center-420605-4ebabe82bb10.json")

export_data <- function(...) {
df_1 <- readRDS("df_1.rds")
df_2 <- readRDS("")

metmuseum <- bq_dataset("centered-center-420605", "met_museum")
dataset_exists <- bq_dataset_exists(metmuseum)

if(dataset_exists == FALSE) {
  bq_dataset_create(metmuseum)
}

objects_tbl <- bq_table(metmuseum, "met_objects")
table_exists <- bq_table_exists(objects_tbl)

if(table_exists == FALSE) {
  fields <- as_bq_fields(df_1)
  
  bq_table_create(stats_tbl, fields)
}

directors_tbl <- bq_table(metmuseum, "met_directors")
table_exists <- bq_table_exists(directors_tbl)

if(table_exists == FALSE) {
  fields <- as_bq_fields(df_1)
  
  bq_table_create(stats_tbl, fields)
}

nrow(df_1)

#bq_table_upload(objects_tbl, values=df_1, fields = as_bq_fields(df_1))

}
