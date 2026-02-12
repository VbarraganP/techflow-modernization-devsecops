output "key_vault_uri" {
  value = module.keyvault.vault_uri
}

output "acr_login_server" {
  value = module.acr.login_server
}

output "container_app_fqdn" {
  value = module.container_app.fqdn
}

output "container_app_job_id" {
  value = module.container_app_job.id
}
