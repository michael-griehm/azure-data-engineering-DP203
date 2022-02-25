resource "azurerm_storage_account" "example" {
  name                     = "sa${local.fqrn_no_dashes}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["74.83.138.51"]
    virtual_network_subnet_ids = []
  }
}