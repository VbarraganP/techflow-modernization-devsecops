output "id" {
  value = azurerm_key_vault.kv.id
}

output "vault_uri" {
  value = azurerm_key_vault.kv.vault_uri
}

output "secret_id" {
  value = azurerm_key_vault_secret.secret.id
}

output "versionless_secret_id" {
  value = azurerm_key_vault_secret.secret.versionless_id
}
