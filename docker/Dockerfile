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

# Start from the official R base image
FROM r-base:latest

# Install system dependencies required by R and renv
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory inside the container
WORKDIR /app

# Copy the necessary directories into the Docker image
COPY ./r /app/r
COPY ./mage /app/mage

# Install renv and restore packages
RUN Rscript -e "install.packages('renv')"
RUN cd /r && Rscript -e "renv::restore()"

# Command to run on container start (can be overridden by Docker run command)
# CMD [ "mage", "-v" ]
