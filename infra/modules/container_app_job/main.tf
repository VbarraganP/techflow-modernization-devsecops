resource "azurerm_container_app_job" "job" {
  name                         = var.name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id

  replica_timeout_in_seconds = 60
  replica_retry_limit        = 1

  schedule_trigger_config {
    cron_expression          = var.cron_expression
    parallelism              = 1
    replica_completion_count = 1
  }

  template {
    container {
      name    = "job"
      image   = "alpine"
      command = ["/bin/sh", "-c", "echo 'Mensaje del Job: Ejecución completada'; exit 0"]
      cpu     = 0.25
      memory  = "0.5Gi"
    }
  }

  tags = var.tags
}
