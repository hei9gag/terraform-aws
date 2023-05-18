## Project Setup
1. Install Terraform
2. Install pre-commit
3. Run `terraform init`
4. Run `pre-commit install`

## How to install Terraform
1. Run `brew tap hashicorp/tap`
2. Run `brew install hashicorp/tap/terraform`
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

## How to init project
Run `terraform init` in root folder

## How to review the state before applying changes
Run `terraform plan -out plan.tfplan`

## How to apply changes
Run `terraform apply plan.tfplan`

## How to validate syntax
Run `terraform validate`

## How to format
Run `terraform fmt`

## How to install pre-commit
Run `brew install pre-commit`

## How to run hooks manually
Run `pre-commit run -a`

## Where to check AWS access and secret key?
1. Login to AWS console
2. IAM dashboard -> Users -> Select user
3. In user detail page -> Security credentials -> Access keys

## Documents
1. https://registry.terraform.io/providers/hashicorp/aws/latest/docs
2. https://www.terraform.io/
