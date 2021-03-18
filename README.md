## Infrastructure AWS
Provision supporting infrastructure AWS for Logactaesque using [Terraform](https://www.terraform.io/)

### Prerequisites
- An [AWS](https://aws.amazon.com/) account
- The AWS [CLI](https://aws.amazon.com/cli/) tool 
- An AWS IAM account with relevant privileges to construct AWS infrastructural components.
- AWS Access and Secret Key configured locally (e.g. for Linux, this would sit under `~/.aws`)
- Terraform (this work used version **v0.12.26**)
- An AWS S3 bucket to hold terraform state (presently *logactaesque-terraform-state-development*)

### Project Structure (Work-in Progress)
The project comprises three folders:
1. Supporting infrastructure
2. TBC
3. TBC


#### 1-infrastructure 
This builds what is a development environment inside region eu-west-1 comprising
- VPC
- A single public subnet
- A single private subnet
- Corresponding public and private route tables
- A NAT gateway for instances in private subnet to connect to internet but prevent the internet from initiating a connection with those instances.
- An AWS internet gateway that allows communication between VPC and internet

Supporting commands to build the (run from the folder 1-infrastructure) are as follows:

Initialise Terraform and state management for the project:

    terraform init -backend-config="infrastructure-dev.config" 

See what will be applied by Terraform:

    terraform plan -var-file="development.tfvars"

To apply the changes:

    terraform apply -var-file="development.tfvars"

To see and subsequently teardown changes:

    terraform plan -destroy -var-file="development.tfvars"
    terraform destroy -var-file="development.tfvars"



