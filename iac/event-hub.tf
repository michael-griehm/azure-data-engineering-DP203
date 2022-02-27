resource "azurerm_eventhub_namespace" "ehns" {
  name                = "ehns-quote-streams"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "Standard"
  capacity            = 1
  zone_redundant      = true
  network_rulesets {
    default_action                 = "Allow"
    trusted_service_access_enabled = true
  }
}

resource "azurerm_eventhub" "eh" {
  name                = "eh-crypto-stream"
  namespace_name      = azurerm_eventhub_namespace.ehns.name
  resource_group_name = data.azurerm_resource_group.rg.name
  partition_count     = 32
  message_retention   = 1
}

resource "azurerm_eventhub_authorization_rule" "sap" {
  name                = "sap-function-stream"
  namespace_name      = azurerm_eventhub_namespace.ehns.name
  eventhub_name       = azurerm_eventhub.eh.name
  resource_group_name = data.azurerm_resource_group.rg.name
  listen              = false
  send                = true
  manage              = false
}
