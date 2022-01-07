provider "google" {
project = "kubernetesgcp-334613"
region = "us-east1"
zone = "us-east1-b"
}

resource "google_compute_instance" "vm_instance" {
  name         = "test"
  machine_type = "e2-micro"
tags         = ["vm-instance"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {

 network = google_compute_network.vpc_network.self_link
  access_config {
}
}
  metadata = {
   ssh-keys = "pani:${file("~/.ssh/id_rsa.pub")}"
}
  metadata_startup_script = file("startup_script.sh")
}
resource "google_compute_network" "vpc_network" {
  name = "testvpc"
  auto_create_subnetworks = "true"
}

resource "google_compute_firewall" "ssh-rule" {
  name = "demo-ssh"
  network = google_compute_network.vpc_network.name
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  target_tags = ["vm-instance"]
  source_ranges = ["0.0.0.0/0"]
}
