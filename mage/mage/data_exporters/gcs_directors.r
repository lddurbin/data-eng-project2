library("pacman")
p_load(googleCloudStorageR)
gcs_auth("centered-center-420605-4ebabe82bb10.json")

export_data <- function(...) {
    df_1 <- readRDS("met_directors.rds")
    
    gcs_global_bucket("splendid_melancholy_4532")

    gcs_upload(df_1, name = "metmuseumdirectors")
}