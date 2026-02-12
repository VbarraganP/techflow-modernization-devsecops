variable "name" {
  description = "Name of the Container App"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "container_app_environment_id" {
  description = "ID of the Container App Environment"
  type        = string
}

variable "image" {
  description = "Docker image to deploy"
  type        = string
}

variable "cpu" {
  description = "CPU cores"
  type        = number
  default     = 0.5
}

variable "memory" {
  description = "Memory in Gi"
  type        = string
  default     = "1Gi"
}

variable "target_port" {
  description = "Target port for ingress"
  type        = number
  default     = 8000
}

variable "key_vault_secret_id" {
  description = "ID (Versioning) of the Key Vault secret"
  type        = string
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "command" {
  description = "Command to execute in the container"
  type        = list(string)
  default     = null
}

variable "args" {
  description = "Arguments for the command"
  type        = list(string)
  default     = null
}

variable "user_assigned_identity_id" {
  description = "ID of the User Assigned Identity for the Container App"
  type        = string
  default     = null
}
