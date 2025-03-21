variable "resource_group_name" {
  type    = string
  default = "mon-resource-group"
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "vm_name" {
  type    = string
  default = "mon-vm"
}

variable "admin_password" {
  type    = string
  default = "H3hitema@"
}

variable "storage_account_name" {
  type    = string
  default = "monstorageaccount"
}

variable "db_name" {
  type    = string
  default = "mon-db"
}

variable "db_username" {
  type    = string
  default = "postgresql"
}

variable "db_password" {
  type    = string
  default = "H3hitema@"
}