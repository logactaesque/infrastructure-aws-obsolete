variable "region" {
  default     = "eu-west-1"
  description = "AWS region"
}

variable "remote_state_bucket" {}
variable "remote_state_key" {}

# application variables
variable "ecs_service_name" {}
variable "docker_image_url" {}
variable "memory" {}
variable "docker_container_port" {}
variable "spring_profile" {}
