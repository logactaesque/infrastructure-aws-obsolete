provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
  }
}

data "terraform_remote_state" "infrastructure" {
  backend = "s3"

  config = {
    region = var.region
    bucket = var.remote_state_bucket
    key    = var.remote_state_key
  }
}

resource "aws_ecs_cluster" "logactaesque-dev-ecs-cluster" {
  name = "Logactaesque Development ECS Cluster"
}

resource aws_alb "logactaesque-dev-ecs-cluster-alb" {
  name            = "${var.ecs_cluster_name}-ALB"
  internal        = false
  security_groups = [aws_security_group.ecs-alb-security-group.id]
  subnets = split(",", join(",", data.terraform_remote_state.infrastructure.outputs.public_subnets,),)
}

resource aws_alb_listener "logactaesque-dev-ecs-alb-https-listener" {
  load_balancer_arn = aws_alb.logactaesque-dev-ecs-cluster-alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = aws_acm_certificate.logactaesque-domain-certificate.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.logactaesque-dev-ecs-default-target-group.arn
  }

  depends_on = [aws_alb_target_group.logactaesque-dev-ecs-default-target-group]
}

resource "aws_alb_target_group" "logactaesque-dev-ecs-default-target-group" {
  name     = "${var.ecs_cluster_name}-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = data.terraform_remote_state.infrastructure.outputs.vpc_id
}

resource "aws_route53_record" "logactaesque-dev-ecs-cluster-alb-record" {
  name    = "*.${var.logactaesque-domain-name}"
  type    = "A"
  zone_id = data.aws_route53_zone.logactaesque_domain_zone.zone_id

  alias {
    evaluate_target_health = false
    name                   = aws_alb.logactaesque-dev-ecs-cluster-alb.dns_name
    zone_id                = aws_alb.logactaesque-dev-ecs-cluster-alb.zone_id
  }
}


resource "aws_iam_role" "logactaesque-dev-ecs-cluster_role" {
  name               = "${var.ecs_cluster_name}-IAM-Role"
  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Effect": "Allow",
    "Principal": {
      "Service": ["ecs.amazonaws.com", "ec2.amazonaws.com", "application-autoscaling.amazonaws.com"]
    },
    "Action": "sts:AssumeRole"
  }
  ]
}
EOF

}

resource "aws_iam_role_policy" "logactaesque-dev-ecs-cluster_policy" {
  name = "${var.ecs_cluster_name}-IAM-Policy"
  role = aws_iam_role.logactaesque-dev-ecs-cluster_role.id
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecs:*",
        "ec2:*",
        "elasticloadbalancing:*",
        "ecr:*",
        "dynamodb:*",
        "cloudwatch:*",
        "s3:*",
        "rds:*",
        "sqs:*",
        "sns:*",
        "logs:*",
        "ssm:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}