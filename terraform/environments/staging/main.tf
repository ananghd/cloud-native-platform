terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = "ap-southeast-1" }

module "vpc" {
  source = "../../modules/vpc"
  name   = "cloud-native-platform-staging"
  azs    = ["ap-southeast-1a", "ap-southeast-1b"]
}

module "eks" {
  source     = "../../modules/eks"
  name       = "cloud-native-platform-staging"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
}

module "rds" {
  source                = "../../modules/rds"
  name                  = "cloud-native-platform-staging"
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.private_subnet_ids
  app_security_group_id = "REPLACE-ME"
}

data "aws_iam_openid_connect_provider" "eks" {
  url = module.eks.cluster_oidc_issuer_url
}

module "app_irsa" {
  source            = "../../modules/iam"
  name              = "cloud-native-platform-staging-app"
  oidc_provider_arn = data.aws_iam_openid_connect_provider.eks.arn
  oidc_provider_url = module.eks.cluster_oidc_issuer_url
  namespace         = "app"
  service_account   = "app"
  policy_arns       = ["arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]
}

output "app_role_arn" { value = module.app_irsa.role_arn }
