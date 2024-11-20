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