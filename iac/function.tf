resource "azurerm_storage_account" "fn_sa" {
  name                     = "fnquotestreamproducers"
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  network_rules {
    default_action = "Allow"
    # ip_rules                   = ["74.83.138.51", "24.31.171.98"]
    virtual_network_subnet_ids = []
  }
}

resource "azurerm_app_service_plan" "asp" {
  name                = "asp-quote-stream-producers"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  sku {
    tier = "Standard"
    size = "S1"
  }

  depends_on = [
    azurerm_storage_account.fn_sa
  ]
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

  app_settings = {
    "CoinApiKeyAppSetting"         = "${var.coin_api_key_app_setting}"
    "EventHubConnectionAppSetting" = "${var.event_hub_connection_app_setting}"
  }

  identity {
    type = "SystemAssigned"
  }

  depends_on = [
    azurerm_storage_account.fn_sa,
    azurerm_app_service_plan.asp
  ]
}