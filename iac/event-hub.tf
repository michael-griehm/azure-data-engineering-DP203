terraform {
  required_providers {
    azuread = "~>2.16.0"
  }

  backend "azurerm" {
  }
}

provider "azurerm" {
  features {}
}

variable "app_name" {
  default = "data-model-demo"
  type      = string
  sensitive = false
}

variable "env" {
  default   = "demo"
  sensitive = false
}

variable "location" {
  default   = "East US 2"
  sensitive = false
}

locals {
  loc     = lower(replace(var.location, " ", ""))
  a_name  = replace(var.app_name, "-", "")
  fqrn    = "${var.app_name}-${var.env}-${local.loc}"
  rg_name = "rg-${local.fqrn}"
}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = var.location
}

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

