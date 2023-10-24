resource "aws_eks_node_group" "self_managed_node_group" {
  cluster_name    = var.eks_cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.node_group_role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = [var.node_instance_type]
  desired_capacity = var.desired_capacity
}

resource "aws_iam_policy" "node_group_policy" {
  name        = "WorkerNodeGroupPolicyName"
  description = "Your policy description"
  # Attach the AmazonEKSWorkerNodePolicy to the IAM role
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "eks:CreateCluster",
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = "eks:DescribeCluster",
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = "eks:DeleteCluster",
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = "eks:ListClusters",
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = "eks:AccessKubernetesApi",
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = "eks:ListFargateProfiles",
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = "eks:CreateFargateProfile",
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = "eks:DeleteFargateProfile",
        Effect = "Allow",
        Resource = "*"
      },
      {
        Action = "eks:DescribeFargateProfile",
        Effect = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "node_group_role" {
  name = "creditor-assessment-role"  # Set a name for the IAM role

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        }
      }
    ]
  })

  # Attach policies to the IAM role as needed

  tags = {
    Name = "ecreditor-assessment-node-group-role"
    Owner        = "ozaditya"
    Environment   = "Prod"
    Project      = "creditor-assessment"
    CostCenter   = "xyz"
    Application  = "transcation-platform"
    # Add additional tags as required
  }
}

resource "aws_iam_policy_attachment" "node_group_policy_attachment" {
  name = "WorkerNodeGroupPolicyNameAttachmentName"
  policy_arn = aws_iam_policy.node_group_policy.arn
  roles = [aws_iam_role.node_group_role.name]
}