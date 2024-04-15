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
      "sudo apt-get install -y wget",
      "wget -O ~/anaconda.sh https://repo.anaconda.com/archive/Anaconda3-2020.02-Linux-x86_64.sh",
      "bash ~/anaconda.sh -b -p $HOME/anaconda3",
      "export PATH=\"$HOME/anaconda3/bin:$PATH\"",
      "conda init",
      "sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"",
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce",
      "sudo usermod -aG docker $USER"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.network_interface[0].access_config[0].nat_ip
    }
  }
}