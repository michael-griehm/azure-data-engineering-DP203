variable "sql_admin_principal_name" {
  type        = string
  sensitive   = true
  description = "The user principal name of the admin for the app."
  default     = "mikeg@ish-star.com"
}

data "azuread_user" "sql_admin" {
  user_principal_name = var.sql_admin_principal_name
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault" "sql_vault" {
  resource_group_name         = data.azurerm_resource_group.rg.name
  location                    = data.azurerm_resource_group.rg.location
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  name                        = "sqluseralertsettings"
  enabled_for_disk_encryption = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  tags                        = var.tags
}

resource "azurerm_key_vault_access_policy" "sql_vault_deployer_acl" {
  key_vault_id = azurerm_key_vault.sql_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Backup",
    "Delete",
    "Get",
    "List",
    "Purge",
    "Recover",
    "Restore",
    "Set"
  ]
}

resource "azurerm_key_vault_access_policy" "admin_acl" {
  key_vault_id = azurerm_key_vault.sql_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_user.sql_admin.object_id

  secret_permissions = [
    "Get",
    "List"
  ]
}

resource "azurerm_sql_server" "sql" {
  name                         = "sql-metadata"
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = data.azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "sa"
  administrator_login_password = random_password.password.result
  tags                         = var.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_sql_database" "example" {
  name                = "db-alerts"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  server_name         = azurerm_sql_server.sql.name
  tags                = var.tags
}

