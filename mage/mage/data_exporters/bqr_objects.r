library("pacman")
p_load(bigrquery)

bigrquery::bq_auth(path = "centered-center-420605-4ebabe82bb10.json")

export_data <- function(...) {
df_1 <- readRDS("met_objects.rds")

metmuseum <- bq_dataset("centered-center-420605", "met_museum")

objects_tbl <- bq_table(metmuseum, "met_objects")

bq_table_upload(objects_tbl, df_1)

}
