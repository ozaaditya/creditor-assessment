resource "aws_eks_cluster" "creditor-assessment-cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = [
      var.private_subnet_ids[0],
      var.private_subnet_ids[1],
    ]
    security_group_ids = [aws_security_group.eks_cluster_security_group.id]
    endpoint_private_access = true
    endpoint_public_access = false
  }
  # Add the specified tags
  tags = {
    Owner        = "ozaditya"
    Environment   = "Prod"
    Project      = "creditor-assessment"
    CostCenter   = "xyz"
    Application  = "transcation-platform"
  }
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
  depends_on = [
    aws_security_group.eks_cluster_security_group
  ]
}

resource "aws_eks_addon" "cluster_coredns" {
  cluster_name = aws_eks_cluster.creditor-assessment-cluster.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "cluster_aws_cni" {
  cluster_name = aws_eks_cluster.creditor-assessment-cluster.name
  addon_name   = "vpc-cni"
}

module "self_managed_node_group" {
  source = "./self-managed-node-group"  # Path to the child module
  
  eks_cluster_name = var.eks_cluster_name
  node_instance_type = "t2.micro"  # Set instance type
  desired_capacity = 2  # Set the desired capacity
  node_group_name = "creditor-assessment-group"  # Set the node group name
}