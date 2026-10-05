# Находим актуальный образ
#data "yandex_compute_image" "ubuntu" {
#  family = "ubuntu-2004-lts"
#}

# NAT-инстанс
#resource "yandex_compute_instance" "nat-instance" {
#  name        = "nat-instance"
#  platform_id = "standard-v1"
#  zone        = var.zone

#  resources {
#    cores  = 2
#    memory = 2
#  }

#  boot_disk {
#    initialize_params {
#      image_id = "fd80mrhj8fl2oe87o4e1"
#    }
#  }

#  network_interface {
#    subnet_id  = yandex_vpc_subnet.public-subnet.id
#    ip_address = "192.168.10.254"
#    nat        = true
#  }

#  metadata = {
#    ssh-keys = "ubuntu:${var.public_ssh_key}"
#  }
#}

# Публичная виртуалка (бастион для подключения)
#resource "yandex_compute_instance" "public-vm" {
#  name        = "public-vm"
#  platform_id = "standard-v1"
#  zone        = var.zone

#  resources {
#    cores  = 2
#    memory = 2
#  }

#  boot_disk {
#    initialize_params {
#      image_id = data.yandex_compute_image.ubuntu.id
#    }
#  }

#  network_interface {
#    subnet_id = yandex_vpc_subnet.public-subnet.id
#    nat       = true
#  }

#  metadata = {
#    ssh-keys = "ubuntu:${var.public_ssh_key}"
#  }
#}

# Приватная виртуалка
#resource "yandex_compute_instance" "private-vm" {
#  name        = "private-vm"
#  platform_id = "standard-v1"
#  zone        = var.zone

#  resources {
#    cores  = 2
#    memory = 2
#  }

#  boot_disk {
#    initialize_params {
#      image_id = data.yandex_compute_image.ubuntu.id
#    }
#  }

#  network_interface {
#    subnet_id = yandex_vpc_subnet.private-subnet.id
# nat = false
#  }

#  metadata = {
#    ssh-keys = "ubuntu:${var.public_ssh_key}"
#  }
#}
