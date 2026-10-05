# VPC
resource "yandex_vpc_network" "homework-network" {
  name = "homework-network"
}

# Публичная подсеть
resource "yandex_vpc_subnet" "public-subnet" {
  name           = "public"
  zone           = var.zone
  network_id     = yandex_vpc_network.homework-network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Таблица маршрутизации для приватной подсети
resource "yandex_vpc_route_table" "private-rt" {
  name       = "private-rt"
  network_id = yandex_vpc_network.homework-network.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}

# Приватная подсеть (с привязкой таблицы маршрутов)
resource "yandex_vpc_subnet" "private-subnet" {
  name           = "private"
  zone           = var.zone
  network_id     = yandex_vpc_network.homework-network.id
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.private-rt.id
}

# Home-23-4
# Приватная подсеть в зоне B
resource "yandex_vpc_subnet" "private-subnet-b" {
  name           = "private-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.homework-network.id
  v4_cidr_blocks = ["192.168.30.0/24"]
  route_table_id = yandex_vpc_route_table.private-rt.id
}

# Public подсеть в зоне B (для Kubernetes)
resource "yandex_vpc_subnet" "public-subnet-b" {
  name           = "public-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.homework-network.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}

# Public подсеть в зоне D (для Kubernetes)
resource "yandex_vpc_subnet" "public-subnet-d" {
  name           = "public-d"
  zone           = "ru-central1-d"
  network_id     = yandex_vpc_network.homework-network.id
  v4_cidr_blocks = ["192.168.12.0/24"]
}
