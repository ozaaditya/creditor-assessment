resource "aws_iam_role" "eks_cluster_role" {
  name = var.eks_cluster_role_name
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "eks.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

resource "aws_security_group" "eks_cluster_security_group" {
  name_prefix   = var.eks_cluster_security_group_name
  description   = "Security group for the EKS cluster"
  vpc_id        = var.vpc_id

  # Define your security group rules here
}

