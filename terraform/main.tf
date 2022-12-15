# declare provider
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.1"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "prometheus" {
  name   = "prometheus"
  driver = "bridge"
}

resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = "prom/prometheus"

  ports {
    internal = "9090"
    external = "9090"
  }

  volumes {
    container_path  = "/etc/prometheus/prometheus.yml"
    read_only = false
    host_path = "/tmp/prometheus/prometheus.yml"
  }

  networks_advanced {
    name    = docker_network.prometheus.name
    aliases = ["prometheus"]
  }

}

resource "docker_container" "alertmanager" {
  name  = "alertmanager"
  image = "prom/alertmanager"

  ports {
    internal = "9093"
    external = "9093"
  }

  volumes {
    container_path  = "/etc/alertmanager/conf/alertmanager.conf"
    read_only = false
    host_path = "/tmp/prometheus/alertmanager.conf"
  }

  networks_advanced {
    name    = docker_network.prometheus.name
    aliases = ["prometheus"]
  }

}

