output "public_ip" {
  value       = azurerm_public_ip.public_ip.ip_address
  description = "Adresse IP publique de la VM"
}