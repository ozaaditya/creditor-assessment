variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
}

variable "eks_cluster_role_name" {
  description = "Name of the IAM role for the EKS cluster"
}

variable "eks_cluster_security_group_name" {
  description = "Name of the security group for the EKS cluster"
}

variable "vpc_id" {
  description = "ID of the VPC"
}

#This not mandatory
variable "public_subnet_ids" {
  description = "IDs of public subnets"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "IDs of private subnets"
  type        = list(string)
}
