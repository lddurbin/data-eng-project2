library("pacman")
p_load(dplyr)
p_load(janitor)

transform <- function(df_1, ...) {
df_2 <- df_1 |> 
  clean_names() |> 
  mutate(
    accession_year = as.Date(paste0("1jan", accession_year), "%d%b%Y"),
    object_begin_date = as.Date(paste0("1jan", object_begin_date), "%d%b%Y"),
    object_end_date = as.Date(paste0("1jan", object_end_date), "%d%b%Y")
  ) |> 
  filter(
    (accession_year >= as.Date("01-01-1900", "%d-%m-%Y") &
     accession_year <= as.Date("01-01-1909", "%d-%m-%Y")
     ) | ((accession_year >= as.Date("01-01-2000", "%d-%m-%Y") &
           accession_year <= as.Date("01-01-2009", "%d-%m-%Y")))
  )

  df_2
}
