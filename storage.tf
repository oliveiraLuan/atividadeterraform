resource "azurerm_storage_account" "luanstorage" {
    name                        = "luanstorage"
    resource_group_name         = azurerm_resource_group.rg_sample.name
    location                    = "eastus"
    account_replication_type    = "LRS"
    account_tier                = "Standard"

}