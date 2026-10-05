# Создаем ключ KMS для шифрования бакета
resource "yandex_kms_symmetric_key" "storage_kms_key" {
  name              = "storage-kms-key-hw23-3"
  description       = "Ключ для шифрования содержимого Object Storage"
  default_algorithm = "AES_256"
  rotation_period   = "8760h"
  deletion_protection   = false
}
