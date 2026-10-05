resource "yandex_mdb_mysql_cluster" "mysql_cluster" {
  name        = "netology-mysql-cluster"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.homework-network.id
  version     = "8.0"

  resources {
    resource_preset_id = "s2.micro" 
    disk_type_id       = "network-ssd"
    disk_size          = 20
  }

  # Время backup
  backup_window_start {
    hours   = 23
    minutes = 59
  }

  maintenance_window {
    type = "ANYTIME"
  }

  # Защита от удаления
  deletion_protection = true 

  host {
    zone      = var.zone # ru-central1-a
    subnet_id = yandex_vpc_subnet.private-subnet.id
  }

  host {
    zone      = "ru-central1-b"
    subnet_id = yandex_vpc_subnet.private-subnet-b.id
  }
}

# Ресурс для базы данных
resource "yandex_mdb_mysql_database" "netology_db" {
  cluster_id = yandex_mdb_mysql_cluster.mysql_cluster.id
  name       = "netology_db"
}

# Ресурс для пользователя
resource "yandex_mdb_mysql_user" "netology_user" {
  cluster_id            = yandex_mdb_mysql_cluster.mysql_cluster.id
  name                  = "netology_user_db"
  password              = "NetologyPass123!"
  authentication_plugin = "MYSQL_NATIVE_PASSWORD"

  permission {
    database_name = yandex_mdb_mysql_database.netology_db.name
    roles         = ["ALL"]
  }
}
