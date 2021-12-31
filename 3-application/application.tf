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
    task_definition_name  = var.ecs_service_name,
    ecs_service_name      = var.ecs_service_name,
    docker_image_url      = var.docker_image_url,
    memory                = var.memory,
    docker_container_port = var.docker_container_port,
    spring_profile        = var.spring_profile,
    region                = var.region
  }
}

resource "aws_ecs_task_definition" "app-task-definition" {
  container_definitions    = data.template_file.ecs_task_definition_template
  family                   = var.ecs_service_name
  cpu                      = 512
  memory                   = var.memory
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = ""
  task_role_arn            = ""
}

resource "aws_iam_role" "fargate_iam_role" {
  name               = "${var.ecs_service_name}-IAM-role"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
  "Effect": "Allow",
  "Principal" : {
    ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
  },
  "Action": "sts:AssumeRole"
}
]
}
EOF
}


resource "aws_iam_role_policy" "fargate-iam_role_policy" {
  name = "${var.ecs_service_name}-IAM-role-policy"
  role = aws_iam_role.fargate_iam_role.id
  policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
  "Effect": "Allow",
  "Action": [
    "ecs:*,
    "ecr:*,
    "logs:*",
    "cloudwatch:*",
    "elasticloadbalancing:*"   ],
  "Resource": *
  }
  ]
}
EOF
}
