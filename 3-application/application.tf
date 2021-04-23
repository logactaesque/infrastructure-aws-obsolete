provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {}
}

data "terraform_remote_state" "platform" {
  backend = "s3"

  config = {
    region = var.region
    bucket = var.remote_state_bucket
    key    = var.remote_state_key
  }
}

data "template_file" "ecs_task_definition_template" {
  template = file("task-definition.json")

  vars = {
    task_definitions_name = var.ecs_service_name}
  }
}