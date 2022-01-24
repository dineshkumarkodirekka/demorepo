provider "azurerm" {
  
  version="=2.72.0"
  subscription_id ="88b6be55-12b5-47fb-81a3-50f62585e2de"
  tenant_id ="1c40c19c-fcf3-4de5-907d-022d314e0373"
  client_id = "b17d6cea-a05c-47ce-985c-941bd5681959"
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "azuregroup"
  location = "West Europe"
}
resource "azurerm_virtual_network" "example" {
  name                = "azurenetwork"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}
 
  resource "azurerm_subnet" "example" {
  name                            = "azuresubnet"
  resource_group_name             = azurerm_resource_group.example.name
  virtual_network_name            = azurerm_virtual_network.example.name
  address_prefixes                  = ["10.0.2.0/24"]
  }
  
  resource "azurerm_network_security_group" "security" {
    name                = "myNetworkSecurityGroup"
    location            = azurerm_resource_group.example.location
    resource_group_name = azurerm_resource_group.example.name

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
    resource "azurerm_linux_virtual_machine" "machine" {
    name                  = "azureVM"
    location              = azurerm_resource_group.example.location
    resource_group_name   = azurerm_resource_group.example.name
 source_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
        size      = "Standard_D2s_v3"
        os_disk {
        name              = "myOsDisk"
        caching           = "ReadWrite"
        storage_account_type = "Premium_LRS"
        }
        computer_name  = "azureVM"
    admin_username = "azureuser"
    disable_password_authentication = true
    
   admin_ssh_key {
        username       = "azureuser"
        public_key     = file("azurez@123456")
    }
 }
    }
  