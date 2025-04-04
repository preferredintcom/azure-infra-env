variable "client_id" {
  type = string
}

variable "client_secret" {
  type = string
  sensitive = true  # Optional: Marks it as sensitive
}

variable "tenant_id" {
  type = string
}

variable "subscription_id" {
  type = string
}