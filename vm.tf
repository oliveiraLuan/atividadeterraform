resource "azurerm_linux_virtual_machine" "luanvm" {
    name                  = "vm_sample"
    location              = "eastus"
    resource_group_name   = azurerm_resource_group.rg_sample.name
    network_interface_ids = [azurerm_network_interface.mic_sample.id]
    size                  = "Standard_DS1_v2"

    os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    computer_name  = "myvm"
    admin_username = "azureuser"
    admin_password = "4zureUser!"
    disable_password_authentication = false

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.luanstorage.primary_blob_endpoint
    }

}