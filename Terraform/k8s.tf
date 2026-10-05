# Home-23-4
# Сервисный аккаунт для Kubernetes
resource "yandex_iam_service_account" "k8s_sa" {
  name = "k8s-service-account"
}

# Назначаем роли сервисному аккаунту Kubernetes
#resource "yandex_resourcemanager_folder_iam_member" "k8s_sa_roles" {
#  for_each = toset([
#    "k8s.clusters.agent",
#    "k8s.nodes.agent",
#    "vpc.publicAdmin",
#    "container-registry.images.puller",
#    "editor"
#  ])

#  folder_id = var.folder_id
#  role      = each.key
#  member    = "serviceAccount:${yandex_iam_service_account.k8s_sa.id}"
#}

# Кластер Kubernetes (региональный мастер в трёх зонах)
resource "yandex_kubernetes_cluster" "k8s_cluster" {
  name       = "netology-k8s-cluster"
  network_id = yandex_vpc_network.homework-network.id

  master {
    regional {
      region = "ru-central1"

      # Мастер в зоне A
      location {
        zone      = yandex_vpc_subnet.public-subnet.zone
        subnet_id = yandex_vpc_subnet.public-subnet.id
      }

      # Мастер в зоне B
      location {
        zone      = yandex_vpc_subnet.public-subnet-b.zone
        subnet_id = yandex_vpc_subnet.public-subnet-b.id
      }

      # Мастер в зоне D
      location {
        zone      = yandex_vpc_subnet.public-subnet-d.zone
        subnet_id = yandex_vpc_subnet.public-subnet-d.id
      }
    }

    # Публичный IP для доступа к мастеру
    public_ip = true
  }

  # Сервисный аккаунт для управления кластером
  service_account_id = yandex_iam_service_account.k8s_sa.id

  # Сервисный аккаунт для нод кластера
  node_service_account_id = yandex_iam_service_account.k8s_sa.id

  # Шифрование секретов кластера ключом KMS
  kms_provider {
    key_id = yandex_kms_symmetric_key.storage_kms_key.id
  }
}

resource "yandex_kubernetes_node_group" "k8s_node_group" {
  for_each = {
    "a" = yandex_vpc_subnet.public-subnet.id
    "b" = yandex_vpc_subnet.public-subnet-b.id
    "d" = yandex_vpc_subnet.public-subnet-d.id
  }

  cluster_id = yandex_kubernetes_cluster.k8s_cluster.id
  name       = "k8s-node-group-${each.key}"

  # Шаблон инстанса для нод
  instance_template {
    platform_id = "standard-v3"

    # Сетевой интерфейс ноды (одна подсеть на группу)
    network_interface {
      nat        = true
      subnet_ids = [each.value]
    }

    # Ресурсы ноды (2 vCPU 50%, 4 ГБ RAM)
    resources {
      memory        = 4
      cores         = 2
      core_fraction = 50
    }

    # Загрузочный диск
    boot_disk {
      type = "network-ssd"
      size = 32
    }
  }

  # Политика автомасштабирования (1-2 ноды на группу, всего 3-6)
  scale_policy {
    auto_scale {
      min     = 1
      max     = 2
      initial = 1
    }
  }

  # Политика размещения нод (одна зона на группу)
  allocation_policy {
    location {
      zone = "ru-central1-${each.key}"
    }
  }
}
