resource "azurerm_storage_account" "example" {
  name                     = "fn${length(local.a_name) > 20 ? substr(local.a_name, 0, 20) : local.a_name}${substr(local.loc, 0, 1)}${substr(var.env, 0, 1)}"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  network_rules {
    default_action             = "Deny"
    ip_rules                   = ["74.83.138.51","24.31.171.98"]
    virtual_network_subnet_ids = []
  }
}