variable "zone" {
  description = "Выбранная зона"
  type        = string
  default     = "ru-central1-a"
}

variable "public_ssh_key" {
  description = "Публичный SSH-ключ для доступа к ВМ"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICTH5QK0W5D9Pmm11wIt6fSbxBnTVXoQIcj7PQciCw2B coursework"
}

variable "bucket_name" {
  description = "Имя бакета Object Storage"
  type        = string
  default     = ""
}

variable "folder_id" {
  description = "ID каталога Yandex Cloud"
  type        = string
}

variable "service_account_id" {
  description = "ID сервисного аккаунта"
  type        = string
  default     = ""
}