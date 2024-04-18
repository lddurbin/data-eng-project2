library("pacman")
p_load(dplyr)
p_load(janitor)

transform <- function(df_1, ...) {
df_1 <- df_1 |> 
  clean_names() |> 
  mutate(
    accession_year = as.Date(paste0("1jan", accession_year), "%d%b%Y")
  ) |> 
  filter(
    (accession_year >= as.Date("01-01-1900", "%d-%m-%Y") &
     accession_year <= as.Date("01-01-1909", "%d-%m-%Y")
     ) | ((accession_year >= as.Date("01-01-2000", "%d-%m-%Y") &
           accession_year <= as.Date("01-01-2009", "%d-%m-%Y")))
  )

  saveRDS(df_1, "df_1.rds")
}
