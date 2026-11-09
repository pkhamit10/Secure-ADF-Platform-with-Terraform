variable "resource_group_name" {
  description = "Name of the resource group for the ADF platform."
  type        = string
}

variable "location" {
  description = "Azure region for the ADF platform resource group."
  type        = string
}

variable "tags" {
  description = "Tags applied to the ADF platform resource group."
  type        = map(string)
  default     = {}
}
