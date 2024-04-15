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
To get started, [install Terraform](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/install-cli). The following steps assume that you've followed the **Getting Started** and **Set up GCP sections** of [this tutorial](https://developer.hashicorp.com/terraform/tutorials/gcp-get-started/google-cloud-platform-build) - in other words, you've created a GCP account and installed the gcloud CLI, you've created a new GCP project, and you've enabled the Google Compute Engine API.

Before proceeding, authenticate to Google Cloud:

`gcloud auth application-default login`

Now you're ready to generate a SSH key, which we'll use to connect to our VM after we've created it. Run the following command, preferably under the ~/.ssh directory:

`ssh-keygen -t rsa -f gcp -C ubuntu -b 2048`

Don't bother setting a password when it asks.

Finally, we can run our Terraform script. First we'll need to download the privoders defined in our configuration:

`terraform init`

Now we're ready to create our infrastructure. There's only two things you'll need to define by creating a terraform.tfvars file - just add the below into it and fill in the details:

    project = "<YOU-PROJECT-ID>"
    public_key_path = "<PATH-TO-YOUR-GCP.PUB-FILE>"

Now we can create the infrastructure:

`terraform apply`

To test your connection to the newly-created VM, run `./connect.sh`.