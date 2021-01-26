resource "azurerm_virtual_network" "vnet_sample" {
    name                = "vnet_sample"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.rg_sample.name

    tags = {
        environment = "Terraform Demo"
    }
}


resource "azurerm_subnet" "subnet_sample" {
    name                 = "subnet_sample"
    resource_group_name  = azurerm_resource_group.rg_sample.name
    virtual_network_name = azurerm_virtual_network.vnet_sample.name
    address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "public_sample" {
    name                         = "public_sample"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.rg_sample.name
    allocation_method            = "Dynamic"
}

resource "azurerm_network_security_group" "network_security_group_sample" {
    name                = "network_security_group_sample"
    location            = "eastus"
    resource_group_name = azurerm_resource_group.rg_sample.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "mic_sample" {
    name                        = "mic_sample"
    location                    = "eastus"
    resource_group_name         = azurerm_resource_group.rg_sample.name

    ip_configuration {
        name                          = "myNicConfiguration"
        subnet_id                     = azurerm_subnet.subnet_sample.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.public_sample.id
    }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nsga_sample" {
    network_interface_id      = azurerm_network_interface.mic_sample.id
    network_security_group_id = azurerm_network_security_group.network_security_group_sample.id
}