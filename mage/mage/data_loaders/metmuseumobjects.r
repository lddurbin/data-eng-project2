load_data <- function() {
    library("pacman")
    p_load(readr)
    
    # download.file("https://github.com/metmuseum/openaccess/raw/master/MetObjects.csv?download=", destfile = "MetObjects.csv", method = "libcurl")

    df <- read_csv("MetObjects.csv")

    df
}
