provider "google" {
project = "kubernetesgcp-334613"
region = "us-east1"
zone = "us-east1-b"
}

resource "google_compute_instance" "vm_instance" {
  name         = "test"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
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
    ports = ["22"]
  }
  target_tags = ["vm_instance"]
  source_ranges = ["0.0.0.0/0"]
}
