provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

#Creating VPC
module "my_vpc" {
  source = "./vpc"  # Path to your VPC module
  region = "us-east-1"  # Replace with your AWS region
  vpc_cidr_block = "10.0.0.0/16"  # Replace with your desired VPC CIDR block
  public_subnet_cidr_blocks = ["10.0.0.0/24"]  # Replace with your public subnet CIDR
  private_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]  # Replace with your private subnets' CIDR
  availability_zones = ["us-east-1a", "us-east-1b"]  # Replace with your desired AZs
}

#Creating EKS cluster
module "eks_cluster" {
 source = "./eks-cluster"  # Path to the EKS cluster module
 eks_cluster_name             = "assessment_cluster"
 eks_cluster_role_name        = "assessment_cluster_role"
 eks_cluster_security_group_name = "assessment_security_group"
 vpc_id = module.my_vpc.vpc_id
 private_subnet_ids = module.my_vpc.private_subnet_ids

  #Additional input variables for the EKS cluster module
  #...
}

output "vpc_id" {
  value = module.my_vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.my_vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.my_vpc.private_subnet_ids
}

output "eks_cluster_id" {
 value = module.eks_cluster.eks_cluster_id
}
