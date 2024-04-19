terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.6.0"
    }
  }
}

provider "google" {
  project = var.project
  zone    = var.zone
  region  = var.region
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "e2-standard-4"
  tags         = ["zoomcamp", "r"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.public_key_path)}"
  }

   provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "docker pull mageai/mageai:latest",
      "git clone https://github.com/lddurbin/data-eng-project2.git"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }
}


resource "google_storage_bucket" "demo-bucket" {
  name          = "splendid_melancholy_4532"
  location      = var.region
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}


resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id = "met_museum"
  location   = var.bq_location
}