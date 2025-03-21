resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                     = "tbizetgroup"  # Choisissez un nom unique
  resource_group_name       = "rg-tbizetgroup"
  location                 = "UK South"
  account_tier              = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "flaskfiles"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "private"
}

resource "azurerm_postgresql_flexible_server" "db" {
  name                = var.db_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = "UK South"
  administrator_login    = var.db_username
  administrator_password = var.db_password
  sku_name            = "B_Standard_B1ms"
  version             = "13"
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_B1s"
  admin_username        = "adminuser"

  admin_password = var.admin_password
  disable_password_authentication = false

  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install -y python3-pip",
      "pip3 install flask psycopg2-binary azure-storage-blob",
      "echo 'from flask import Flask, request\\nimport psycopg2\\nfrom azure.storage.blob import BlobServiceClient\\nimport os\\n\\napp = Flask(__name__)\\n\\nDB_CONN = psycopg2.connect(\\n    dbname=\"${var.db_name}\",\\n    user=\"${var.db_username}\",\\n    password=\"${var.db_password}\",\\n    host=\"${azurerm_postgresql_flexible_server.db.fqdn}\"\\n)\\n\\nBLOB_SERVICE_CLIENT = BlobServiceClient(account_url=\"https://${azurerm_storage_account.storage.name}.blob.core.windows.net\", credential=None)\\nCONTAINER_CLIENT = BLOB_SERVICE_CLIENT.get_container_client(\"flaskfiles\")\\n\\n@app.route(\"/upload\", methods=[\"POST\"])\\ndef upload_file():\\n    file = request.files[\"file\"]\\n    blob_client = CONTAINER_CLIENT.get_blob_client(file.filename)\\n    blob_client.upload_blob(file.read())\\n    return \"File uploaded\", 200\\n\\n@app.route(\"/\")\\ndef home():\\n    return \"Hello from Flask with DB and Storage!\"\\n\\nif __name__ == \"__main__\":\\n    app.run(host=\"0.0.0.0\", port=5000)' > app.py",
      "nohup python3 app.py &"
    ]
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "${var.vm_name}-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.vm_name}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.vm_name}-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}