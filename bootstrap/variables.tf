variable "resource_group_name" {
  description = "Resource group for Terraform state storage."
  type        = string
  default     = "rg-tfstate"
}

variable "location" {
  description = "Azure region for Terraform state resources."
  type        = string
  default     = "francecentral"
}

variable "storage_account_name" {
  description = "Globally unique storage account name (3-24 lowercase letters and numbers)."
  type        = string
  default     = "dfpkstorage"

  validation {
    condition     = can(regex("^[a-z0-9]{3,24}$", var.storage_account_name))
    error_message = "The storage account name must be 3-24 lowercase letters or numbers."
  }
}

variable "container_name" {
  description = "Private blob container for Terraform state."
  type        = string
  default     = "tfstate"

  validation {
    condition     = can(regex("^[a-z0-9]([a-z0-9-]{1,61}[a-z0-9])$", var.container_name)) && !strcontains(var.container_name, "--")
    error_message = "The container name must be 3-63 lowercase letters, numbers, or non-consecutive hyphens, and start and end with a letter or number."
  }
}

variable "tags" {
  description = "Tags applied to Terraform state resources."
  type        = map(string)
  default = {
    project = "secure-adf-platform"
    purpose = "terraform-state"
  }
}
