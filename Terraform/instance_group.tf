# Создание Instance Group с LAMP
resource "yandex_compute_instance_group" "lamp_group" {
  name               = "lamp-group-hw23-2"
  service_account_id = var.service_account_id 
  
  instance_template {
    name        = "lamp-vm-{instance.index}"
    platform_id = "standard-v1"
    
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
        size     = 10
      }
    }
    
    resources {
      cores  = 2
      memory = 2
    }
    
    network_interface {
      subnet_ids = [yandex_vpc_subnet.public-subnet.id]
      nat        = true
    }
    
    metadata = {
      ssh-keys  = "ubuntu:${var.public_ssh_key}"
      user-data = <<-EOF
        #!/bin/bash
        cat > /var/www/html/index.html << 'HTML'
        <!DOCTYPE html>
        <html>
        <head>
            <title>LAMP Server</title>
        </head>
        <body>
            <h1>Welcome to LAMP Server!</h1>
            <img src="https://${yandex_storage_bucket.hw23-2_bucket.bucket}.storage.yandexcloud.net/image.jpg" alt="Image from Yandex Object Storage" />
            <p>Image loaded directly from our Yandex Object Storage bucket!</p>
        </body>
        </html>
        HTML
        
        systemctl restart apache2
      EOF
    }
    
    scheduling_policy {
      preemptible = true
    }
  }
  
  scale_policy {
    fixed_scale {
      size = 3
    }
  }
  
  allocation_policy {
    zones = [var.zone]
  }
  
  deploy_policy {
    max_unavailable = 1
    max_expansion   = 1
  }

  # Создаем группу для балансировщика
  load_balancer {
    target_group_name        = "lamp-target-group"
    target_group_description = "Target group for LAMP instance group"
  }
}

# Создаем балансировщик (Network Load Balancer)
resource "yandex_lb_network_load_balancer" "lamp_nlb" {
  name = "lamp-network-load-balancer"

  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_compute_instance_group.lamp_group.load_balancer[0].target_group_id

    healthcheck {
      name = "http"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
