variable "name" {
  description = "Name of the Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tenant_id" {
  description = "Tenant ID"
  type        = string
}

variable "secret_value" {
  description = "Value for the test secret"
  type        = string
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

variable "expiration_date" {
  description = "Expiration date for the secret (RFC3339)"
  type        = string
  default     = null
}

variable "deployer_object_id" {
  description = "Object ID of the user/SP deploying Terraform (for RBAC assignment)"
  type        = string
  default     = null
}

variable "allowed_ip_ranges" {
  description = "List of public IP/CIDR ranges to allow access to Key Vault"
  type        = list(string)
  default     = []
}
