variable "region" {
  default     = "eu-west-1"
  description = "AWS region"
}


variable "remote_state_bucket" {}
variable "remote_state_key" {}

variable "ecs_service_name" {}