variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-techflow-challenge"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "app_name" {
  description = "Base name for the application resources"
  type        = string
  default     = "techflow"
}

variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "secret_value" {
  description = "Value for the secret to be stored in Key Vault"
  type        = string
  sensitive   = true
}

variable "container_image" {
  description = "Docker image for the Container App"
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "allowed_ip_ranges" {
  description = "List of public IP/CIDR ranges to allow access to Key Vault"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "target_port" {
  description = "Port on which the application listens"
  type        = number
  default     = 8000
}
