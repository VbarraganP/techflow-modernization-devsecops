terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }

  backend "azurerm" {} # Partial configuration, details passed via CLI
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    environment = var.environment
    project     = "TechFlow"
  }
}

locals {
  # Naming convention: type-project-env
  suffix = "${var.app_name}-${var.environment}"
}

# User Assigned Identity for Container Apps
resource "azurerm_user_assigned_identity" "ua" {
  location            = azurerm_resource_group.rg.location
  name                = "id-${local.suffix}"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "time_offset" "secret_expiration" {
  offset_years = 1
}

module "keyvault" {
  source              = "./modules/keyvault"
  name                = "kv-${local.suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  secret_value        = var.secret_value
  expiration_date     = time_offset.secret_expiration.rfc3339
  deployer_object_id  = data.azurerm_client_config.current.object_id
  allowed_ip_ranges   = var.allowed_ip_ranges

  tags = azurerm_resource_group.rg.tags
}

module "acr" {
  source              = "./modules/acr"
  name                = "acr${replace(local.suffix, "-", "")}" # ACR names must be alphanumeric
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = azurerm_resource_group.rg.tags
}

# --------------------------------------------------------------------------------------------------
# Role Assignments for User Assigned Identity
# --------------------------------------------------------------------------------------------------

# Allow Identity to Pull Images from ACR
resource "azurerm_role_assignment" "acr_pull" {
  scope                = module.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.ua.principal_id
}

# Allow Identity to Read Secrets from Key Vault
resource "azurerm_role_assignment" "kv_reader" {
  scope                = module.keyvault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.ua.principal_id
}

# Wait for RBAC to propagate
resource "time_sleep" "wait_for_rbac" {
  depends_on = [
    azurerm_role_assignment.acr_pull,
    azurerm_role_assignment.kv_reader
  ]

  create_duration = "180s"
}

module "container_app_env" {
  source              = "./modules/container_app_env"
  name                = "cae-${local.suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = azurerm_resource_group.rg.tags
}

module "container_app" {
  source                       = "./modules/container_app"
  name                         = "ca-${local.suffix}"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = module.container_app_env.id
  image                        = var.container_image
  target_port                  = var.target_port

  # Identities
  user_assigned_identity_id = azurerm_user_assigned_identity.ua.id

  # Inject secret reference
  key_vault_secret_id = module.keyvault.versionless_secret_id

  tags = azurerm_resource_group.rg.tags

  depends_on = [time_sleep.wait_for_rbac]
}

module "container_app_job" {
  source                       = "./modules/container_app_job"
  name                         = "job-${local.suffix}"
  location                     = azurerm_resource_group.rg.location
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = module.container_app_env.id

  tags = azurerm_resource_group.rg.tags
}


