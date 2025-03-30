variable "vnet_name" { type = string }
variable "vnet_cidr" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "subnets" {
  type = map(object({
    cidr = string
  }))
  default = {}
}
variable "enable_nsg" {
  type    = bool
  default = false
}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}
