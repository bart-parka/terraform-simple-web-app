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

variable "vpc_stage" {
  description = "The environment to deploy into"
  type        = string
  default     = "dev"
}

variable "app_name" {
  description = "The name of the application"
  type        = string
}

variable "task_cpu" {
  description = "CPU assigned to task"
  type        = string
  default     = "1024"
}

variable "task_memory" {
  description = "Memory assigned to task"
  type        = string
  default     = "2048"
}