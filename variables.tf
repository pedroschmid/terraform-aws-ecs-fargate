variable "ENVIRONMENT" {
  type        = string
  description = "Enviroment of infrastructure"
}

variable "REGION" {
  type        = string
  description = "Region where aws will create resources"
}

variable "PROFILE" {
  type        = string
  description = "Profile of aws"
}

variable "ACCESS_KEY" {
  type        = string
  description = "AWS access key"
}

variable "SECRET_KEY" {
  type        = string
  description = "AWS secret key"
}