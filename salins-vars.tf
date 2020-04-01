variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "ovh_application_key" {
  type = string
}

variable "ovh_application_secret" {
  type = string
}

variable "ovh_consumer_key" {
  type = string
}

variable "app_name" {
  type = string
  description = "name"
  default = "salins"
}

variable "app_environment" {
  type = string
  description = "environment type"
  default = "prod"
}

