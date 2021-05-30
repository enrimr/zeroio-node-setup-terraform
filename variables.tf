variable "project" {
	type = string
}

variable "credentials_file" { }

variable "region" {
  default = "us-central1"
}

variable "zone" {
  default = "us-central1-a"
}

variable "node_instance_count" {
  type    = number
  default = 1
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "machine_types" {
  type    = map
  default = {
    dev  = "e2-standard-8"
    test = "n1-highcpu-32"
    prod = "n1-highcpu-32"
  }
}

variable "ssh_user" {
	type = string
	default = "zeroio"
}

variable "ssh_pub_key_file" {}

variable "ssh_private_key_file" {}