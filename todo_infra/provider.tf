terraform {
  required_version = ">= 1.0.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }

}
provider "azurerm" {
  features {}
  subscription_id = "3f7c4872-f198-45b7-984d-0ab188b016e6"
}
