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

resource "azurerm_virtual_network" "example" {
  name                = "test-vnet"
  resource_group_name = "test_rg1" 
  location            = "koreacentral"
  address_space       = ["172.16.0.0/16"]
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = "test_rg1" 
  virtual_network_name = "koreacentral"
  address_prefixes     = ["172.16.1.0/24"]
}