resource "docker_network" "private_network" {
  name = "tp_network"
}

resource "docker_container" "app" {
  name    = "tp-app"
  image   = "tp-app:latest"
  restart = "on-failure"
  
  networks_advanced {
    name = docker_network.private_network.name
  }
}

resource "docker_image" "nginx" {
  name         = "nginx:alpine"
  keep_locally = true
}

resource "docker_container" "nginx" {
  name  = "tp-proxy"
  image = docker_image.nginx.name

  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
    name = docker_network.private_network.name
  }

  volumes {
    host_path      = ("${path.module}/nginx.conf")
    container_path = "/etc/nginx/conf.d/default.conf"
  }

  depends_on = [docker_container.app]
}

output "app_url" {
  value = "http://localhost:8080"
}