variable "name" {
  description = "Name of the Job"
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

variable "container_app_environment_id" {
  description = "ID of the Container App Environment"
  type        = string
}

variable "cron_expression" {
  description = "Cron expression for the schedule"
  type        = string
  default     = "*/5 * * * *" # Every 5 minutes
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
