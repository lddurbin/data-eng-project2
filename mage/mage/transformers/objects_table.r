library("pacman")
p_load(bigrquery)

bigrquery::bq_auth(path = "centered-center-420605-4ebabe82bb10.json")

transform <- function(..) {
df_1 <- readRDS("met_objects.rds")

metmuseum <- bq_dataset("centered-center-420605", "met_museum")

objects_tbl <- bq_table(metmuseum, "met_objects")
table_exists <- bq_table_exists(objects_tbl)

if(table_exists == FALSE) {
  fields <- as_bq_fields(df_1)
  
  bq_table_create(objects_tbl, fields)
}

df_1
}
