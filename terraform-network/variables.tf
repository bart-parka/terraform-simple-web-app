### General Variables ###
variable "profile" {
  description = "Account to deploy into"
  type        = string
  default     = null
}

variable "region" {
  description = "AWS region in which to deploy"
  type        = string
  default     = "eu-west-2"
}

variable "stage" {
  description = "The environment to deploy into"
  type        = string
}