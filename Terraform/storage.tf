# Home-23-2 (Оставляем закомментированным, как вы и просили)
# resource "yandex_storage_object" "hw23-2_image" {
#   bucket       = yandex_storage_bucket.hw23-2_bucket.bucket
#   key          = "image.jpg"
#   source       = "image.jpg"
#   content_type = "image/jpeg"
#   acl          = "public-read"
# }

# Создание бакета Object Storage (Задание 1 и 2)
resource "yandex_storage_bucket" "hw23-3_bucket" {
  bucket = "index-hw23-3-static-site"
  acl    = "public-read"

  anonymous_access_flags {
    read = true
    list = false
  }

  # Настройка для статического сайта (Задание 2)
  website {
    index_document = "index.html"
  }

  # Шифруем бакет с помощью KMS (Задание 1)
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.storage_kms_key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# Загружаем картинку в бакет
resource "yandex_storage_object" "hw23-3_image" {
  bucket       = yandex_storage_bucket.hw23-3_bucket.bucket
  key          = "image.jpg"
  source       = "image.jpg"
  content_type = "image/jpeg"
  acl          = "public-read"
}

# Загружаем наш index.html в бакет
resource "yandex_storage_object" "hw23-3_index" {
  bucket       = yandex_storage_bucket.hw23-3_bucket.bucket
  key          = "index.html"
  source       = "index.html" 
  content_type = "text/html"
  acl          = "public-read"
}