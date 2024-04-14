# Analysing Media Coverage of Jacinda Adern and Christopher Luxon in Real Time

## Problem
This project uses data from [GDELT's Global Knowledge Graph](https://blog.gdeltproject.org/introducing-gkg-2-0-the-next-generation-of-the-gdelt-global-knowledge-graph/) to understand how the media covered the premierships of two New Zealand Prime Ministers, Jacinda Adern and Christopher Luxon, at the same stage of their premierships. Jacinda Adern was Prime Minister from 26 October 2017 to 25 January 2023, and Christopher Luxon has been Prime Minister since 27 November 2023.

## Technologies
* Google cloud platform (GCP):
  * VM Instance to run project.
  * Cloud Storage to store processed data.
  * BigQuery as data source for dashboard.
* Terraform to create cloud infrastructure as code (IaC).
* Docker for containerization, ensuring consistency across different environments.
* R main programming language
* Mage to orchestrate pipeline jobs.
* Spark to pre-process raw data.
* dbt to perform transformations.

## Infrastructure as Code
To get started, follow along with Terraform's Getting Started guide for Google Cloud: https://developer.hashicorp.com/terraform/tutorials/gcp-get-started
