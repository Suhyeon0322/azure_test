terraform {
    required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "test_rg1" 
    storage_account_name = "testsa150"                      
    container_name       = "tfstate"                      
    key                  = "prod.terraform.tfstate"        
  }
}
    
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  subscription_id = "b8d06fc7-c92e-4a44-8a98-597f53734a95"  # subscription1
}

resource "azurerm_virtual_network" "main" {
  name                = "test-network"
  address_space       = ["10.0.0.0/16"]
  location            = "koreacentral"
  resource_group_name = "test-rg1"
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = "test-rg1"
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "test-nic"
  location            = "koreacentral"
  resource_group_name = "test-rg1"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "test-vm"
  location              = "koreacentral"
  resource_group_name   = "test-rg1"
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  # delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
  storage_os_disk {
    name              = "test-vm_disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "admin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}