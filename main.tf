provider "google" {
  project     = "citric-earth-319117"
  region      = "europe-west3"
}

resource "google_compute_firewall" "jenandprod" {
name    = "jenandprod"
network = "default"

allow {
ports    = ["443","22","80","8080"]
protocol = "tcp"
}
}

 resource "google_compute_instance" "jenk" {
  name         = "jenkins"
  machine_type = "n1-standard-1"
  zone         = "europe-west3-c"

  tags = ["jenkins"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  scratch_disk {
interface = "SCSI"
}

  network_interface {
    network = "default"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = <<EOF
"sudo apt update;
sudo apt install -y wget;
 wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -;
 sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > \
    /etc/apt/sources.list.d/jenkins.list';
 sudo apt update;
 sudo apt-get -y install openjdk-8-jdk;
 sudo ap install -y jenkins;
 sudo service jenkins start"
EOF
}
resource "google_compute_instance" "product" {
  name         = "prod"
  machine_type = "n1-standard-1"
  zone         = "europe-west3-c"

  tags = ["prod"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  scratch_disk {
interface = "SCSI"
}

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

 metadata_startup_script = <<EOF
"sudo apt update;
sudo apt install -y openjdk-8-jre-headless;
apt-cache policy docker-ce;
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -;
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable";
sudo apt update;
sudo apt install -y docker-ce"
EOF
}
