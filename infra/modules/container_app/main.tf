resource "azurerm_container_app" "app" {
  name                         = var.name
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name    = "app"
      image   = var.image
      cpu     = var.cpu
      memory  = var.memory
      command = var.command
      args    = var.args

      env {
        name        = "MY_SECRET"
        secret_name = "my-secret-ref"
      }
    }

    init_container {
      name    = "init"
      image   = "alpine"
      command = ["/bin/sh", "-c", "echo 'Iniciando Init Container con Secreto...'; echo $MY_SECRET > /dev/null"]
      cpu     = 0.25
      memory  = "0.5Gi"

      env {
        name        = "MY_SECRET"
        secret_name = "my-secret-ref"
      }
    }
  }

  secret {
    name                = "my-secret-ref"
    key_vault_secret_id = var.key_vault_secret_id
    identity            = var.user_assigned_identity_id # Uses the UAI to fetch the secret
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  registry {
    server   = split("/", var.image)[0]
    identity = var.user_assigned_identity_id
  }

  ingress {
    external_enabled = true
    target_port      = var.target_port
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = var.tags
}
