# Use the official Golang image to create a build artifact.
FROM golang:1.16-alpine as builder

# Install git.
RUN apk add --no-cache git

# Install Mage
RUN go get -u -d github.com/magefile/mage
RUN cd $GOPATH/src/github.com/magefile/mage && go run bootstrap.go

# Start a new stage from scratch
FROM alpine:latest

# Install R, R-dev, and common dependencies for the required R packages
RUN apk add --no-cache R R-dev curl-dev openssl-dev g++ gcc libxml2-dev libgit2-dev curl

# Install R packages
RUN R -e "install.packages(c('bigrquery', 'httr', 'dplyr', 'ggplot2', 'lubridate', 'tidyr', 'janeaustenr', 'tidytext'), repos='https://cran.rstudio.com/')"

# Copy Mage binary from builder
COPY --from=builder /go/bin/mage /usr/local/bin

# Set the working directory inside the container
WORKDIR /app

# Copy the necessary directories into the Docker image
COPY ./r /app/r
COPY ./mage /app/mage

# Set environment variables or perform other configuration

# Command to run on container start (can be overridden by Docker run command)
# CMD [ "mage", "-v" ]
