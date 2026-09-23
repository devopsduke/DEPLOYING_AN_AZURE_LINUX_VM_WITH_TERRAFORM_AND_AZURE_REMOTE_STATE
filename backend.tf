terraform {
  backend "azurerm" {
    resource_group_name  = "tfstatebackendz-rg"
    storage_account_name = "azuretfstateawq28746u"
    container_name       = "tfstate"
    key                  = "terraform-azuretfstateawq28746u.tfstate"
  }
}