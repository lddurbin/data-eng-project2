library("pacman")
p_load(janitor)
p_load(dplyr)
p_load(stringr)

transform <- function(df_1, ...) {
df_1 <- df_1 |>
  clean_names() |> 
  mutate(
    term_start = as.Date(paste0("01-01-", word(term, 1)), "%d-%m-%Y"),
    term_end = ifelse(str_length(term) > 4, word(term, 3), NA),
    term_end = as.Date(paste0("01-01-", term_end), "%d-%m-%Y")
  ) |> 
  select(-image)
  
  saveRDS(df_1, "met_directors.rds")

  df_1
}
