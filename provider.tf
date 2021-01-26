# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_sample" {
  name     = "rg_sample"
  location = "westus2"
}

resource "azurerm_mysql_server" "luanmysql" {
  name                = "luanmysql"
  location            = azurerm_resource_group.rg_sample.location
  resource_group_name = azurerm_resource_group.rg_sample.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "null_resource" "db" {
  # ...

   triggers = {
            order = azurerm_linux_virtual_machine.luanvm.id
        }

  provisioner "remote-exec" {

        connection {
            type     = "ssh"
            user     = "azureuser"
            password = "4zureUser!"
            host     = azurerm_public_ip.public_sample.ip_address
        }

        inline = [
            "sudo apt-get -y update",
            "sudo apt-get install -y mysql-server-5.7",
            "sudo service mysql start"
        ]
  }
}