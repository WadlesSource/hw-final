data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}
# Создание VPC и подсети
resource "yandex_vpc_network" "main" {
  name = "project-network"
}

resource "yandex_vpc_subnet" "public" {
  name           = "public-subnet-a"
  zone           = var.default_zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = var.default_cidr
}

# Группы безопасности (22, 80, 443)
resource "yandex_vpc_security_group" "web_sg" {
  name        = "web-security-group"
  network_id  = yandex_vpc_network.main.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTPS"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

# Виртуальная машина
resource "yandex_compute_instance" "web_app" {
  name        = "web-app-vm"
  platform_id = "standard-v3"
  zone        = var.default_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.public.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.web_sg.id]
  }

  metadata = {
    ssh-keys = "ubuntu:${file("${path.module}/yes.pub")}"

    user-data = file("${path.module}/../cloud-init.yaml")
  }
}

output "external_ip" {
  value = yandex_compute_instance.web_app.network_interface.0.nat_ip_address
}
# --- Задание 5*. Yandex Lockbox ---
# Предполагается, что секрет уже создан вручную
data "yandex_lockbox_secret_version" "db_password" {
  secret_id = var.secret_id
