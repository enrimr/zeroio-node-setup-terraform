terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {

  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_firewall" "ssh-rule" {
  name    = "terraform-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags   = ["zeroio-node"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_address" "vm_static_ip" {
  name = "zeroio-instance-0-static-ip"
}


resource "google_compute_instance" "vm_instance" {
  name         = "zeroio-instance-0"
  machine_type = var.machine_types[var.environment]

  tags = ["zeroio-node"]

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
  }

  provisioner "local-exec" {
    command = "echo ${google_compute_instance.vm_instance.name}:  ${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip} >> logs/ip_address.txt"
  }

  provisioner "file" {
    source      = "scripts/test.sh"
    destination = "/tmp/create_zeroio_node.sh"

    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = file("${var.ssh_private_key_file}")
      host        = google_compute_address.vm_static_ip.address
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "${var.ssh_user}"
      private_key = file("${var.ssh_private_key_file}")
      host        = google_compute_address.vm_static_ip.address
    }

    inline = [
      "chmod +x /tmp/create_zeroio_node.sh",
      "/bin/bash /tmp/create_zeroio_node.sh args > script.log",
    ]
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-minimal-2004-lts"
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    access_config {
      nat_ip = google_compute_address.vm_static_ip.address
    }
  }
}
