# Infrastructure AWS
Experimental attempt at provisioning the supporting infrastructure in AWS for Logactaesque using [Terraform](https://www.terraform.io/)

_**As of December 2021 this has been paused in an incomplete state.** Parts 1 and 2 function as expected.

Built using [this Udemy course](https://www.udemy.com/course/deploy-fargate-ecs-apps-infrastructure-aws-with-terraform/) on Fargate/AWS/Terraform

## Prerequisites
- An [AWS](https://aws.amazon.com/) account
- The AWS [CLI](https://aws.amazon.com/cli/) tool 
- An AWS IAM account with relevant privileges to construct AWS infrastructural components.
- AWS Access and Secret Key configured locally (e.g. for Linux, this would sit under `~/.aws`)
- Terraform (this work used version **v0.14.8**)
- An AWS S3 bucket to hold terraform state (presently *logactaesque-terraform-state-development*)

## Project Structure (Work-in Progress)
The project comprises three folders:
1. Supporting infrastructure
2. Platform 
3. Application

### 1-infrastructure 
This builds what is a development environment inside region eu-west-1 comprising
- VPC
- A single public subnet
- A single private subnet
- Corresponding public and private route tables
- A NAT gateway for instances in private subnet to connect to internet but prevent the internet from initiating a connection with those instances.
- An AWS internet gateway that allows communication between VPC and internet

Supporting commands to build the (run from the project folder *1-infrastructure*) are as follows:

Initialise Terraform and state management for the project:

    terraform init -backend-config="infrastructure-dev.config" 

See what will be applied by Terraform:

    terraform plan -var-file="development.tfvars"

To apply the changes:

    terraform apply -var-file="development.tfvars"

To see and subsequently teardown changes:

    terraform plan -destroy -var-file="development.tfvars"
    terraform destroy -var-file="development.tfvars"

### 2-platform 
Supporting commands to build the platform should be run from the project folder *2-platform*

    terraform init -backend-config="platform-dev.config"
    terraform plan -var-file="development.tfvars"
    terraform apply -var-file="development.tfvars"

### 3-application 
Supporting commands to build the application layer should be run from the project folder *3-application*

    terraform init -backend-config="application-dev.config"
    # terraform plan -var-file="development.tfvars"
    # terraform apply -var-file="development.tfvars"


