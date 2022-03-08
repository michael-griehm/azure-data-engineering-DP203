data "azurerm_key_vault" "fn_vault" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = "fn-stream-producers"
}

resource "azurerm_storage_account" "fn_sa" {
  name                     = "fnstreamproducers"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags                     = var.tags

  network_rules {
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}

resource "azurerm_app_service_plan" "asp" {
  name                = "asp-stream-producers"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = var.tags

  sku {
    tier = "Dynamic"
    size = "D1"
  }

  depends_on = [
    azurerm_storage_account.fn_sa
  ]
}

resource "azurerm_key_vault_secret" "event_hub_connection" {
  name         = azurerm_eventhub_authorization_rule.producer.name
  value        = azurerm_eventhub_authorization_rule.producer.primary_connection_string
  key_vault_id = data.azurerm_key_vault.fn_vault.id
}

resource "azurerm_function_app" "fn" {
  name                       = "fn-quote-stream-producers"
  resource_group_name        = data.azurerm_resource_group.rg.name
  location                   = data.azurerm_resource_group.rg.location
  app_service_plan_id        = azurerm_app_service_plan.asp.id
  storage_account_name       = azurerm_storage_account.fn_sa.name
  storage_account_access_key = azurerm_storage_account.fn_sa.primary_access_key
  https_only                 = true
  version                    = "~3"
  tags                       = var.tags

  app_settings = {
    "CoinApiKeyAppSetting"         = "${var.coin_api_key_app_setting}"
    "EventHubConnectionAppSetting" = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.event_hub_connection.versionless_id})"
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_storage_account.fn_sa,
    azurerm_app_service_plan.asp,
    azurerm_key_vault_secret.event_hub_connection
  ]
}

resource "azurerm_key_vault_access_policy" "fn_acl" {
  key_vault_id = data.azurerm_key_vault.fn_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_function_app.fn.identity[0].principal_id

  secret_permissions = [
    "Get",
  ]

  depends_on = [
    azurerm_function_app.fn
  ]
}

resource "azurerm_log_analytics_workspace" "logs" {
  name                = "fnquotestreamproducers"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  sku                 = "Free"
  retention_in_days   = 7
  tags                = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "logs" {
  name                       = "fnquotestreamproducers"
  target_resource_id         = azurerm_function_app.fn.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.logs.id

  log {
    category = "FunctionAppLogs"

    retention_policy {
      enabled = true
      days    = 7
    }
  }

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = true
      days    = 7
    }
  }
}