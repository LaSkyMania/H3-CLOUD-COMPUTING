variable "resource_group_name" {
  type    = string
  default = "MonGroupeRessources"
}

variable "location" {
  type    = string
  default = "francecentral"
}

variable "vm_name" {
  type    = string
  default = "MaVMFlask"
}

variable "admin_username" {
  type    = string
  default = "azureuser"
}

variable "admin_password" {
  type    = string
}