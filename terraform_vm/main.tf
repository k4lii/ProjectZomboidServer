provider "google" {
  credentials = file(var.credentials_file)
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = var.disk_image
      size  = 40
      type  = "pd-ssd"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_public_key)}"
  }

  allow_stopping_for_update = true

  tags = ["web"]
}

resource "google_compute_firewall" "allow_ports" {
  name    = "allow-ports-zomboid"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]   # SSH
  }

  allow {
    protocol = "udp"
    ports    = ["16261", "16262"]  # Steam and Direct Connection Ports
  }

  allow {
    protocol = "tcp"
    ports    = ["27015"]  # RCON Port
  }

  source_ranges = ["0.0.0.0/0"]  # Allow access from any IP
  target_tags   = ["web"]
}