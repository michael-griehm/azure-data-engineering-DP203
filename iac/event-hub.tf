resource "azurerm_eventhub_namespace" "ehns" {
  name                = "ehns-${local.fqrn}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = "Standard"
  capacity            = 1
}

resource "azurerm_eventhub" "eh" {
  name                = "eh-${local.fqrn}"
  namespace_name      = azurerm_eventhub_namespace.ehns.name
  resource_group_name = data.azurerm_resource_group.rg.name
  partition_count     = 2
  message_retention   = 1
}

