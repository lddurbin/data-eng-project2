library("pacman")
p_load(bigrquery)

bigrquery::bq_auth(path = "centered-center-420605-4ebabe82bb10.json")

export_data <- function(...) {
df_1 <- readRDS("met_directors.rds")

metmuseum <- bq_dataset("centered-center-420605", "met_museum")

directors_tbl <- bq_table(metmuseum, "met_directors")

bq_table_upload(directors_tbl, df_1)
}
