library("pacman")
p_load(dplyr)
p_load(janitor)

transform <- function(df_1, ...) {
df_1 <- df_1 |> 
  clean_names() |> 
  mutate(
    accession_year = as.Date(paste0("1jan", accession_year), "%d%b%Y")
  )

  saveRDS(df_1, "met_objects.rds")

  df_1
}
