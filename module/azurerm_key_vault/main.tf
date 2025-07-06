data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name = var.key_vault_name
  resource_group_name = var.resource_group_name
  location = var.location
enabled_for_disk_encryption = true
tenant_id = data.azurerm_client_config.current.tenant_id
purge_protection_enabled = true
soft_delete_retention_days = 7
 sku_name            = "standard"

access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get", "List", "Delete", "Set"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}