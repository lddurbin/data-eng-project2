variable "project" {}

variable "region" {
  description = "Project Region"
  default     = "asia"
}

variable "zone" {
  description = "Zone"
  default     = "australia-southeast2-a"
}

variable "bq_location" {
  description = "Location"
  default     = "australia-southeast2"
}

variable "public_key_path" {}

variable "private_key_path" {}