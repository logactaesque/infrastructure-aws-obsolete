output "vpc_id" {
  value = data.terraform_remote_state.infrastructure.outputs.vpc_id
}

output "vpc_cidr_block" {
  value = data.terraform_remote_state.infrastructure.outputs.vpc_cidr_block
}

output "ecs_alb_listener_arn" {
  value = aws_alb_listener.logactaesque-dev-ecs-alb-https-listener.arn
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.logactaesque-dev-ecs-cluster.name
}

output "ecs_cluster_role_name" {
  value = aws_iam_role.logactaesque-dev-ecs-cluster_role.name
}

output "ecs_cluster_role_arn" {
  value = aws_iam_role.logactaesque-dev-ecs-cluster_role.arn
}

output "ecs_domain_name" {
  value = var.logactaesque-domain-name
}

output "ecs_public_subnets" {
  value = data.terraform_remote_state.infrastructure.outputs.public_subnets
}

output "ecs_private_subnets" {
  value = data.terraform_remote_state.infrastructure.outputs.private_subnets
}