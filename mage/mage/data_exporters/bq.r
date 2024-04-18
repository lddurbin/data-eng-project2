
library("pacman")
p_load(bigrquery)

bigrquery::bq_auth(path = "centered-center-420605-4ebabe82bb10.json")

export_data <- function(...) {
df_1 <- readRDS("df_1.rds")

metmuseum <- bq_dataset("centered-center-420605", "met_museum_objects_sample")
dataset_exists <- bq_dataset_exists(metmuseum)

if(dataset_exists == FALSE) {
  bq_dataset_create(metmuseum)
}

objects_tbl <- bq_table(metmuseum, "met_objects")
table_exists <- bq_table_exists(objects_tbl)

if(table_exists == TRUE) {
  bq_table_delete(objects_tbl)
}

bq_table_upload(objects_tbl, values=df_1, fields = as_bq_fields(df_1))

}
