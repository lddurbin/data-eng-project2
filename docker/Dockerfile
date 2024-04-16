# Use the official Golang image to create a build artifact.
FROM golang:1.16-alpine as builder

# Install git and other necessary tools.
RUN apk add --no-cache git

# Set up the working directory
WORKDIR /go/src/mage

# Clone the Mage repository
RUN git clone https://github.com/magefile/mage.git .

# Install Mage using Go
RUN go run bootstrap.go

# Start a new stage from scratch
FROM alpine:latest

# Copy the Mage binary from the builder stage
COPY --from=builder /go/bin/mage /usr/local/bin

# Install R and other dependencies required for your R environment
RUN apk add --no-cache R R-dev curl-dev openssl-dev g++ gcc libxml2-dev libgit2-dev curl

# Install R packages if needed right away
RUN R -e "install.packages(c('bigrquery', 'httr', 'dplyr', 'ggplot2', 'lubridate', 'tidyr', 'janeaustenr', 'tidytext'), repos='https://cran.rstudio.com/')"

# Set the working directory inside the container
WORKDIR /app

# Copy the necessary directories into the Docker image
COPY ./r /app/r
COPY ./mage /app/mage

# Set environment variables or perform other configuration

# Command to run on container start (can be overridden by Docker run command)
# CMD [ "mage", "-v" ]
